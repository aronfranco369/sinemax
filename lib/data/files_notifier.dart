import 'dart:async';

import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/media.dart';
import 'connectivity_notifier.dart';

part 'files_notifier.g.dart';

SupabaseClient get _db => Supabase.instance.client;

@riverpod
class FilesNotifier extends _$FilesNotifier {
  Box<MediaFile> get _box => Hive.box<MediaFile>('files_cache');
  Box<bool> get _fetched => Hive.box<bool>('files_fetched');
  Box<String> get _meta => Hive.box<String>('metadata');
  RealtimeChannel? _channel;
  StreamSubscription<BoxEvent>? _hiveSub;

  /// Watermark: ISO timestamp of the most recent `updated_at` we've synced.
  static const _kLastSynced = 'files_last_synced';

  @override
  Future<List<MediaFile>> build() async {
    ref.onDispose(() {
      _hiveSub?.cancel();
      _channel?.unsubscribe();
    });

    // When the connection comes back, pull whatever changed while offline.
    ref.listen(connectionStatusProvider, (prev, next) {
      if (prev == false && next == true) _syncDelta();
    });

    // Catch files changed/added (e.g. new episodes) while the app was closed,
    // but only for media we've already cached — others load lazily on demand.
    Future.microtask(_syncDelta);

    // Hive watcher — fires when any file is added/updated/deleted.
    _hiveSub = _box.watch().listen((_) {
      state = AsyncData(_box.values.toList());
    });

    _setupRealtime();
    return _box.values.toList();
  }

  /// Fetches files for [mediaId] from Supabase if not already cached.
  ///
  /// Never throws: on network failure the mediaId stays unmarked in
  /// `files_fetched`, so the next access (or reconnect) retries the fetch.
  Future<void> ensureLoaded(String mediaId) async {
    if (_fetched.get(mediaId) == true) return;
    final Object data;
    try {
      data = await _db
          .from('files')
          .select()
          .eq('media_id', mediaId)
          .order('episode_number', ascending: true, nullsFirst: false)
          .order('label', ascending: true, nullsFirst: false);
    } catch (_) {
      // Guard: the provider may have been disposed during the async gap.
      if (ref.mounted) ref.read(connectionStatusProvider.notifier).recheck();
      return;
    }
    final files = (data as List)
        .map((r) => MediaFile.fromJson(r as Map<String, dynamic>))
        .toList();
    await _box.putAll({for (final f in files) f.id: f});
    await _fetched.put(mediaId, true);
    _advanceWatermark(files);
  }

  /// Pulls files whose `updated_at` is newer than our watermark, keeps only
  /// those belonging to media we've already cached, and upserts them. This
  /// surfaces server-side edits and newly added episodes for cached content.
  Future<void> _syncDelta() async {
    final since = _meta.get(_kLastSynced);
    // Nothing cached yet — lazy loading via [ensureLoaded] handles first reads.
    if (since == null) return;

    final Object data;
    try {
      data = await _db
          .from('files')
          .select()
          .gt('updated_at', since)
          .order('updated_at', ascending: true, nullsFirst: true);
    } catch (_) {
      // Guard: the provider may have been disposed during the async gap.
      if (ref.mounted) ref.read(connectionStatusProvider.notifier).recheck();
      return;
    }
    final files = (data as List)
        .map((r) => MediaFile.fromJson(r as Map<String, dynamic>))
        .toList();
    if (files.isEmpty) return;

    final relevant =
        files.where((f) => _fetched.get(f.mediaId) == true).toList();
    if (relevant.isNotEmpty) {
      await _box.putAll({for (final f in relevant) f.id: f});
    }

    // Advance past every returned row so we don't re-pull them next launch,
    // even the ones we filtered out (they load lazily if opened later).
    _advanceWatermark(files);
  }

  /// Moves the watermark forward to the latest `updated_at` in [files].
  void _advanceWatermark(List<MediaFile> files) {
    DateTime? mx;
    for (final f in files) {
      final u = f.updatedAt;
      if (u != null && (mx == null || u.isAfter(mx))) mx = u;
    }
    if (mx == null) return;
    final current = _meta.get(_kLastSynced);
    final currentTs = current == null ? null : DateTime.tryParse(current);
    if (currentTs == null || mx.isAfter(currentTs)) {
      _meta.put(_kLastSynced, mx.toUtc().toIso8601String());
    }
  }

  void _setupRealtime() {
    _channel?.unsubscribe();
    _channel = _db
        .channel('files_realtime')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'files',
          callback: (payload) {
            if (payload.eventType == PostgresChangeEvent.delete) {
              final id = payload.oldRecord['id'] as String?;
              if (id != null) _box.delete(id);
            } else {
              final f = MediaFile.fromJson(payload.newRecord);
              // Only cache if we're tracking this media; otherwise it'll be
              // fetched fresh on first open via [ensureLoaded].
              if (_fetched.get(f.mediaId) == true) {
                _box.put(f.id, f);
              }
              _advanceWatermark([f]);
            }
          },
        )
        .subscribe();
  }
}
