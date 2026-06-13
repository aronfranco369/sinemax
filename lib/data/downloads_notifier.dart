import 'package:hive_ce/hive_ce.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/library_item.dart';
import '../models/media.dart';
import 'download_engine.dart';
import 'media_notifier.dart';

part 'downloads_notifier.g.dart';

/// Mirrors the `download_records` Hive box, keyed by fileId. The actual work
/// (downloading, encrypting, persisting) happens in [DownloadEngine]; this just
/// keeps the UI in sync and forwards user actions.
@Riverpod(keepAlive: true)
class Downloads extends _$Downloads {
  Box<DownloadRecord> get _box => Hive.box<DownloadRecord>('download_records');

  @override
  Map<String, DownloadRecord> build() {
    final sub = DownloadEngine.instance.changes.listen((_) => _reload());
    ref.onDispose(sub.cancel);
    return _snapshot();
  }

  Map<String, DownloadRecord> _snapshot() => {for (final r in _box.values) r.fileId: r};

  void _reload() => state = _snapshot();

  Future<void> start(Media media, MediaFile file) => DownloadEngine.instance.enqueue(media, file);
  Future<void> retry(DownloadRecord rec) => DownloadEngine.instance.retry(rec);
  Future<void> pause(String fileId) => DownloadEngine.instance.pause(fileId);
  Future<void> resume(String fileId) => DownloadEngine.instance.resume(fileId);
  Future<void> cancel(String fileId) => DownloadEngine.instance.cancel(fileId);
  Future<void> remove(String fileId) => DownloadEngine.instance.remove(fileId);
}

/// Download records grouped per media for the Downloads screen, newest first.
@riverpod
Future<List<(Media, List<DownloadRecord>)>> downloadsContent(Ref ref) async {
  final records = ref.watch(downloadsProvider);
  final list = await ref.watch(mediaProvider.future);
  final byId = {for (final m in list) m.id: m};
  final groups = <String, List<DownloadRecord>>{};
  for (final r in records.values) {
    groups.putIfAbsent(r.mediaId, () => []).add(r);
  }
  final result = <(Media, List<DownloadRecord>)>[];
  groups.forEach((mediaId, recs) {
    final media = byId[mediaId];
    if (media == null) return;
    recs.sort((a, b) => a.at.compareTo(b.at));
    result.add((media, recs));
  });
  // newest group first
  result.sort((a, b) => b.$2.last.at.compareTo(a.$2.last.at));
  return result;
}
