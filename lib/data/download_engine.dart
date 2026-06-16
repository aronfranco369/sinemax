import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:disk_space_plus/disk_space_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:path_provider/path_provider.dart';

import '../models/library_item.dart';
import '../models/media.dart';

/// Thrown by [DownloadEngine.enqueue] / [DownloadEngine.retry] when the device
/// doesn't have enough free space to download a file.
/// The UI catches this to show the user a message instead of silently failing.
class InsufficientStorageException implements Exception {
  /// Bytes we needed free (file size × [DownloadEngine.kStorageSafetyFactor]).
  final int requiredBytes;

  /// Bytes actually free on the download volume.
  final int freeBytes;

  const InsufficientStorageException({required this.requiredBytes, required this.freeBytes});

  @override
  String toString() => 'InsufficientStorageException(required: $requiredBytes, free: $freeBytes)';
}

/// Everything around offline downloads:
///
///  * native background downloads (parallel / pause / resume / cancel, survive
///    app kill, progress notifications) via `background_downloader`
///  * the file downloads straight into the app-private media dir
///    (`applicationSupport/media/<fileId>`). That location lives in Android
///    internal storage, so it's invisible to the gallery and unreadable by
///    other apps (Xender, Bluetooth, file managers) without root.
///  * the downloaded bytes are kept as-is (any container/codec) — media_kit
///    opens the plain file path directly, so no decrypt proxy is needed.
///
/// Must be initialized once from main() AFTER Hive boxes are open.
class DownloadEngine {
  DownloadEngine._();
  static final DownloadEngine instance = DownloadEngine._();

  /// Free space we require before starting, as a multiple of the file size.
  /// The file downloads straight into the media dir, so we only need one
  /// file's worth of space; 2× just leaves comfortable headroom.
  static const kStorageSafetyFactor = 2;

  late final Directory _mediaDir;

  final _changes = StreamController<void>.broadcast();

  /// Fires whenever any download record changes (status or progress).
  Stream<void> get changes => _changes.stream;

  Box<DownloadRecord> get _box => Hive.box<DownloadRecord>('download_records');

  // ── Init ────────────────────────────────────────────────────────────────────

  Future<void> init() async {
    final support = await getApplicationSupportDirectory();
    _mediaDir = Directory('${support.path}/media')..createSync(recursive: true);

    final fd = FileDownloader();
    fd.configureNotification(
      running: const TaskNotification('Downloading', '{displayName}'),
      paused: const TaskNotification('Download paused', '{displayName}'),
      complete: const TaskNotification('Download complete', '{displayName}'),
      error: const TaskNotification('Download failed', '{displayName}'),
      progressBar: true,
    );
    if (await fd.permissions.status(PermissionType.notifications) !=
        PermissionStatus.granted) {
      await fd.permissions.request(PermissionType.notifications);
    }
    await fd.trackTasks();
    fd.updates.listen(_onUpdate);
    // Pick up status/progress that happened while the app was killed.
    await fd.resumeFromBackground();
    await _reconcile();
  }

  /// Repair records left in a transient state by a previous app death.
  Future<void> _reconcile() async {
    for (final rec in _box.values.toList()) {
      switch (rec.statusEnum) {
        case DownloadStatus.completed:
        case DownloadStatus.failed:
        case DownloadStatus.paused:
          break;
        // `encrypting` is a legacy state from older installs — treat any record
        // still in a transient state the same way: reconcile against the native
        // downloader's record.
        case DownloadStatus.encrypting:
        case DownloadStatus.queued:
        case DownloadStatus.running:
          final tr = await FileDownloader().database.recordForId(rec.fileId);
          if (tr == null) {
            rec.status = DownloadStatus.failed.index;
            _put(rec);
          } else if (tr.status == TaskStatus.complete) {
            await _finalize(rec, tr.task);
          } else if (tr.status == TaskStatus.failed || tr.status == TaskStatus.notFound) {
            rec.status = DownloadStatus.failed.index;
            _put(rec);
          } else if (tr.status == TaskStatus.paused) {
            rec.status = DownloadStatus.paused.index;
            _put(rec);
          }
      }
    }
  }

  // ── Public API ──────────────────────────────────────────────────────────────

  Future<void> enqueue(Media media, MediaFile file) async {
    final url = file.downloadUrl;
    if (url == null || url.isEmpty) return;
    return _enqueue(
      fileId: file.id,
      mediaId: media.id,
      url: url,
      label: file.label ?? (file.episodeNumber != null ? 'Episode ${file.episodeNumber}' : 'Movie'),
      title: media.title,
      expectedBytes: file.fileSize ?? 0,
    );
  }

  Future<void> retry(DownloadRecord rec) => _enqueue(
        fileId: rec.fileId,
        mediaId: rec.mediaId,
        url: rec.url,
        label: rec.label,
        title: rec.title,
        expectedBytes: rec.totalBytes,
      );

  /// Free bytes on the volume that holds our downloads.
  /// Returns -1 if the platform couldn't report it (so we skip the gate
  /// rather than block a download on a bad reading).
  Future<int> _freeBytes() async {
    try {
      final mb = await DiskSpacePlus().getFreeDiskSpaceForPath(_mediaDir.path);
      if (mb == null) return -1;
      return (mb * 1024 * 1024).round();
    } catch (_) {
      return -1;
    }
  }

  Future<void> _enqueue({
    required String fileId,
    required String mediaId,
    required String url,
    required String label,
    required String title,
    required int expectedBytes,
  }) async {
    final existing = _box.get(fileId);
    if (existing != null && existing.statusEnum != DownloadStatus.failed) {
      return; // already downloading, paused or completed
    }
    // Storage gate — need room for the file plus headroom.
    // Skipped when the size is unknown (0) or free space can't be read (-1).
    if (expectedBytes > 0) {
      final required = expectedBytes * kStorageSafetyFactor;
      final free = await _freeBytes();
      if (free >= 0 && free < required) {
        throw InsufficientStorageException(requiredBytes: required, freeBytes: free);
      }
    }
    _put(DownloadRecord(
      fileId: fileId,
      mediaId: mediaId,
      label: label,
      title: title,
      url: url,
      status: DownloadStatus.queued.index,
      at: DateTime.now().toIso8601String(),
    ));
    await FileDownloader().enqueue(DownloadTask(
      taskId: fileId,
      url: url,
      filename: fileId,
      directory: 'media',
      baseDirectory: BaseDirectory.applicationSupport,
      updates: Updates.statusAndProgress,
      allowPause: true,
      retries: 3,
      displayName: '$title · $label',
    ));
  }

  Future<void> pause(String fileId) async {
    final tr = await FileDownloader().database.recordForId(fileId);
    final task = tr?.task;
    if (task is DownloadTask) await FileDownloader().pause(task);
  }

  Future<void> resume(String fileId) async {
    final tr = await FileDownloader().database.recordForId(fileId);
    final task = tr?.task;
    if (task is DownloadTask && !await FileDownloader().resume(task)) {
      // Resume data lost — restart from scratch.
      await FileDownloader().enqueue(task);
    }
  }

  /// Stop an in-flight download and discard its record + partial data.
  Future<void> cancel(String fileId) async {
    await FileDownloader().cancelTaskWithId(fileId);
    await remove(fileId);
  }

  /// Delete a download (media file + record).
  Future<void> remove(String fileId) async {
    try {
      final f = File(_mediaPath(fileId));
      if (f.existsSync()) f.deleteSync();
    } catch (_) {}
    await _box.delete(fileId);
    _changes.add(null);
  }

  /// Local file path the player can open for a completed download, or null if
  /// this file isn't downloaded. media_kit opens a plain file path directly.
  Future<String?> playbackUrl(String fileId) async {
    final rec = _box.get(fileId);
    if (rec == null || !rec.isCompleted) return null;
    final f = File(_mediaPath(fileId));
    return f.existsSync() ? f.path : null;
  }

  // ── Downloader updates ──────────────────────────────────────────────────────

  void _onUpdate(TaskUpdate update) {
    final rec = _box.get(update.task.taskId);
    if (rec == null) return; // canceled and already removed
    if (update is TaskStatusUpdate) {
      switch (update.status) {
        case TaskStatus.enqueued:
        case TaskStatus.waitingToRetry:
          rec.status = DownloadStatus.queued.index;
          _put(rec);
        case TaskStatus.running:
          rec.status = DownloadStatus.running.index;
          _put(rec);
        case TaskStatus.paused:
          rec.status = DownloadStatus.paused.index;
          _put(rec);
        case TaskStatus.complete:
          _finalize(rec, update.task);
        case TaskStatus.failed:
        case TaskStatus.notFound:
          rec.status = DownloadStatus.failed.index;
          _put(rec);
        case TaskStatus.canceled:
          remove(rec.fileId);
      }
    } else if (update is TaskProgressUpdate) {
      if (update.progress >= 0 && update.progress <= 1) {
        rec.progress = update.progress;
        if (update.hasExpectedFileSize) rec.totalBytes = update.expectedFileSize;
        _put(rec);
      }
    }
  }

  /// Mark a finished download complete. The downloader wrote the file straight
  /// into the private media dir, so there's nothing to move — we just record
  /// its final size and flip the status. `playbackUrl` gates on this status,
  /// so a still-downloading file is never handed to the player.
  Future<void> _finalize(DownloadRecord rec, Task task) async {
    try {
      final f = File(await task.filePath());
      if (!f.existsSync()) throw const FileSystemException('downloaded file missing');
      rec.totalBytes = f.lengthSync();
      rec.status = DownloadStatus.completed.index;
    } catch (e) {
      debugPrint('[Sinemax] finalize failed for ${rec.fileId}: $e');
      rec.status = DownloadStatus.failed.index;
    }
    rec.progress = 1.0;
    _put(rec);
  }

  void _put(DownloadRecord rec) {
    _box.put(rec.fileId, rec);
    _changes.add(null);
  }

  String _mediaPath(String fileId) => '${_mediaDir.path}${Platform.pathSeparator}$fileId';
}
