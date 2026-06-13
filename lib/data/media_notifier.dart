import 'dart:async';

import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/media.dart';
import 'connectivity_notifier.dart';

part 'media_notifier.g.dart';

SupabaseClient get _db => Supabase.instance.client;

@riverpod
class MediaNotifier extends _$MediaNotifier {
  Box<Media> get _box => Hive.box<Media>('media_cache');
  Box<String> get _meta => Hive.box<String>('metadata');
  RealtimeChannel? _channel;
  StreamSubscription<BoxEvent>? _hiveSub;

  /// Watermark: ISO timestamp of the most recent `updated_at` we've synced.
  static const _kLastSynced = 'media_last_synced';

  @override
  Future<List<Media>> build() async {
    ref.onDispose(() {
      _hiveSub?.cancel();
      _channel?.unsubscribe();
    });

    // When the connection comes back, pull whatever changed while offline.
    ref.listen(connectionStatusProvider, (prev, next) {
      if (prev == false && next == true) _syncDelta();
    });

    if (_box.isEmpty) {
      // First launch: block until the initial (full) sync completes.
      await _syncDelta();
    } else {
      // Warm cache: serve it immediately and pull only changed rows in the
      // background. Catches edits/additions made while the app was closed.
      Future.microtask(_syncDelta);
    }

    // Hive watcher — fires on any box mutation (delta sync or Realtime).
    _hiveSub = _box.watch().listen((_) {
      state = AsyncData(_sorted(_box.values.toList()));
    });

    _setupRealtime();
    return _sorted(_box.values.toList());
  }

  /// Pulls only rows whose `updated_at` is newer than our watermark, upserts
  /// them into Hive, and advances the watermark. When no watermark exists
  /// (first launch) this fetches the whole table.
  ///
  /// Never throws: offline/network failures leave the Hive cache as-is and
  /// the reconnect listener in [build] retries when connectivity returns.
  Future<void> _syncDelta() async {
    final since = _meta.get(_kLastSynced);

    final Object data;
    try {
      final query = _db.from('media').select();
      data = await (since == null
          ? query.order('updated_at', ascending: true, nullsFirst: true)
          : query
              .gt('updated_at', since)
              .order('updated_at', ascending: true, nullsFirst: true));
    } catch (_) {
      // Guard: the provider may have been disposed during the async gap.
      if (ref.mounted) ref.read(connectionStatusProvider.notifier).recheck();
      return;
    }

    final list = (data as List)
        .map((r) => Media.fromJson(r as Map<String, dynamic>))
        .toList();
    if (list.isEmpty) return;

    await _box.putAll({for (final m in list) m.id: m});

    final watermark = _maxUpdatedAt(list);
    if (watermark != null) await _meta.put(_kLastSynced, watermark);
  }

  /// Returns the latest non-null `updated_at` in [list] as an ISO string.
  String? _maxUpdatedAt(List<Media> list) {
    DateTime? mx;
    for (final m in list) {
      final u = m.updatedAt;
      if (u != null && (mx == null || u.isAfter(mx))) mx = u;
    }
    return mx?.toUtc().toIso8601String();
  }

  void _setupRealtime() {
    _channel?.unsubscribe();
    _channel = _db
        .channel('media_realtime')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'media',
          callback: (payload) {
            if (payload.eventType == PostgresChangeEvent.delete) {
              final id = payload.oldRecord['id'] as String?;
              if (id != null) _box.delete(id);
            } else {
              final m = Media.fromJson(payload.newRecord);
              _box.put(m.id, m);
              final u = m.updatedAt;
              if (u != null) {
                _meta.put(_kLastSynced, u.toUtc().toIso8601String());
              }
            }
          },
        )
        .subscribe();
  }

  List<Media> _sorted(List<Media> list) =>
      list..sort((a, b) => a.title.compareTo(b.title));
}
