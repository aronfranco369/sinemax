import 'package:hive_ce/hive_ce.dart';

part 'library_item.g.dart';

@HiveType(typeId: 0)
class WatchedItem {
  @HiveField(0)
  final String contentId;

  @HiveField(1)
  final String watchedAt;

  @HiveField(2)
  final double progress;

  @HiveField(3)
  final String context;

  WatchedItem({required this.contentId, required this.watchedAt, this.progress = 0.0, this.context = ''});
}

/// Lifecycle of an offline download. Stored as [DownloadRecord.status] index —
/// do not reorder members.
enum DownloadStatus { queued, running, paused, encrypting, completed, failed }

@HiveType(typeId: 4)
class DownloadRecord {
  /// MediaFile id — also used as the background_downloader taskId.
  @HiveField(0)
  final String fileId;

  @HiveField(1)
  final String mediaId;

  /// Episode/part label shown in lists (e.g. "Episode 1").
  @HiveField(2)
  final String label;

  /// Media title, kept here so notifications/library rows work offline.
  @HiveField(3)
  final String title;

  /// Original Backblaze download URL — needed to retry failed downloads.
  @HiveField(4)
  final String url;

  /// DownloadStatus.index
  @HiveField(5)
  int status;

  /// 0.0 → 1.0 while downloading.
  @HiveField(6)
  double progress;

  /// Plaintext size in bytes (expected while downloading, exact once complete).
  @HiveField(7)
  int totalBytes;

  @HiveField(8)
  final String at;

  DownloadRecord({
    required this.fileId,
    required this.mediaId,
    required this.label,
    required this.title,
    required this.url,
    this.status = 0,
    this.progress = 0.0,
    this.totalBytes = 0,
    required this.at,
  });

  DownloadStatus get statusEnum => DownloadStatus.values[status];
  bool get isCompleted => statusEnum == DownloadStatus.completed;
  bool get isActive =>
      statusEnum == DownloadStatus.queued ||
      statusEnum == DownloadStatus.running ||
      statusEnum == DownloadStatus.encrypting;
}
