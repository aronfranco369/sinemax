import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:background_downloader/background_downloader.dart';
import 'package:disk_space_plus/disk_space_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pointycastle/export.dart';

import '../models/library_item.dart';
import '../models/media.dart';

/// Thrown by [DownloadEngine.enqueue] / [DownloadEngine.retry] when the device
/// doesn't have enough free space to safely download *and* encrypt a file.
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
///  * AES-256-CTR encryption of completed downloads into `.enc` files inside
///    the app-private storage (`filesDir`) — invisible to file managers,
///    Xender, Bluetooth etc. The key lives in Keystore-backed secure storage,
///    so copied files are unreadable on any other device.
///  * a loopback HTTP server that decrypts on the fly with Range support, so
///    video_player/ExoPlayer streams the encrypted file like a network URL.
///
/// Must be initialized once from main() AFTER Hive boxes are open.
class DownloadEngine {
  DownloadEngine._();
  static final DownloadEngine instance = DownloadEngine._();

  /// Free space we require before starting, as a multiple of the file size.
  /// A download transiently needs the temp `.part` (1×) plus the encrypted
  /// `.enc` written alongside it before the `.part` is deleted (1×), so 3×
  /// leaves a full file's worth of headroom on top of that double-write.
  static const kStorageSafetyFactor = 3;

  static const _keyName = 'sinemax_media_key';
  static const _secure = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  late final Uint8List _key;
  late final Directory _encDir;
  late final String _serverToken;
  HttpServer? _server;

  final _changes = StreamController<void>.broadcast();

  /// Fires whenever any download record changes (status or progress).
  Stream<void> get changes => _changes.stream;

  Box<DownloadRecord> get _box => Hive.box<DownloadRecord>('download_records');

  // ── Init ────────────────────────────────────────────────────────────────────

  Future<void> init() async {
    // AES key — generated once per install, kept in Android Keystore-backed
    // secure storage. Never written to regular app storage.
    var stored = await _secure.read(key: _keyName);
    if (stored == null) {
      final rnd = Random.secure();
      stored = base64Encode(List<int>.generate(32, (_) => rnd.nextInt(256)));
      await _secure.write(key: _keyName, value: stored);
    }
    _key = base64Decode(stored);

    final support = await getApplicationSupportDirectory();
    _encDir = Directory('${support.path}/media_enc')..createSync(recursive: true);
    _serverToken = List<int>.generate(16, (_) => Random.secure().nextInt(256))
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();

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
        case DownloadStatus.encrypting:
          // Died mid-encryption — redo from the temp file if it survived.
          final tr = await FileDownloader().database.recordForId(rec.fileId);
          if (tr != null) {
            await _encrypt(rec, tr.task);
          } else {
            rec.status = DownloadStatus.failed.index;
            _put(rec);
          }
        case DownloadStatus.queued:
        case DownloadStatus.running:
          final tr = await FileDownloader().database.recordForId(rec.fileId);
          if (tr == null) {
            rec.status = DownloadStatus.failed.index;
            _put(rec);
          } else if (tr.status == TaskStatus.complete) {
            await _encrypt(rec, tr.task);
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

  /// Free bytes on the volume that holds our temp + encrypted downloads.
  /// Returns -1 if the platform couldn't report it (so we skip the gate
  /// rather than block a download on a bad reading).
  Future<int> _freeBytes() async {
    try {
      final mb = await DiskSpacePlus().getFreeDiskSpaceForPath(_encDir.path);
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
    // Storage gate — need room for the download + its encrypted copy + headroom.
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
      filename: '$fileId.part',
      directory: 'dl_tmp',
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

  /// Delete a download (encrypted file + record).
  Future<void> remove(String fileId) async {
    try {
      final enc = File(_encPath(fileId));
      if (enc.existsSync()) enc.deleteSync();
    } catch (_) {}
    await _box.delete(fileId);
    _changes.add(null);
  }

  /// Loopback URL the video player can stream a completed download from,
  /// or null if this file isn't downloaded.
  Future<String?> playbackUrl(String fileId) async {
    final rec = _box.get(fileId);
    if (rec == null || !rec.isCompleted) return null;
    if (!File(_encPath(fileId)).existsSync()) return null;
    await _ensureServer();
    return 'http://127.0.0.1:${_server!.port}/$fileId?t=$_serverToken';
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
          _encrypt(rec, update.task);
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

  Future<void> _encrypt(DownloadRecord rec, Task task) async {
    rec.status = DownloadStatus.encrypting.index;
    rec.progress = 1.0;
    _put(rec);
    try {
      final partPath = await task.filePath();
      if (!File(partPath).existsSync()) throw const FileSystemException('temp file missing');
      final encPath = _encPath(rec.fileId);
      final key = _key;
      // Pure-Dart AES over a whole movie is heavy — run off the main isolate.
      final size = await Isolate.run(() => _encryptFileSync(partPath, encPath, key));
      try {
        File(partPath).deleteSync();
      } catch (_) {}
      rec.status = DownloadStatus.completed.index;
      rec.totalBytes = size;
    } catch (e) {
      debugPrint('[Sinemax] encryption failed for ${rec.fileId}: $e');
      rec.status = DownloadStatus.failed.index;
    }
    _put(rec);
  }

  void _put(DownloadRecord rec) {
    _box.put(rec.fileId, rec);
    _changes.add(null);
  }

  String _encPath(String fileId) => '${_encDir.path}${Platform.pathSeparator}$fileId.enc';

  // ── Loopback decrypting server ──────────────────────────────────────────────

  Future<void> _ensureServer() async {
    if (_server != null) return;
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server!.listen(_handleRequest, onError: (_) {});
  }

  Future<void> _handleRequest(HttpRequest req) async {
    RandomAccessFile? raf;
    try {
      if (req.uri.queryParameters['t'] != _serverToken) {
        req.response.statusCode = HttpStatus.forbidden;
        await req.response.close();
        return;
      }
      final fileId = req.uri.pathSegments.isNotEmpty ? req.uri.pathSegments.first : '';
      final file = File(_encPath(fileId));
      if (fileId.isEmpty || !file.existsSync()) {
        req.response.statusCode = HttpStatus.notFound;
        await req.response.close();
        return;
      }

      raf = file.openSync();
      final iv = Uint8List.fromList(raf.readSync(16)); // 16-byte IV header
      final total = file.lengthSync() - 16; // plaintext length

      var start = 0;
      var end = total - 1;
      var partial = false;
      final range = req.headers.value(HttpHeaders.rangeHeader);
      if (range != null && range.startsWith('bytes=')) {
        final spec = range.substring(6).split(',').first.trim();
        final dash = spec.indexOf('-');
        final fromStr = spec.substring(0, dash);
        final toStr = spec.substring(dash + 1);
        if (fromStr.isEmpty) {
          // suffix range: last N bytes
          start = max(0, total - int.parse(toStr));
        } else {
          start = int.parse(fromStr);
          if (toStr.isNotEmpty) end = min(end, int.parse(toStr));
        }
        partial = true;
      }
      if (start > end || start >= total) {
        req.response.statusCode = HttpStatus.requestedRangeNotSatisfiable;
        req.response.headers.set(HttpHeaders.contentRangeHeader, 'bytes */$total');
        await req.response.close();
        return;
      }

      final resp = req.response;
      resp.statusCode = partial ? HttpStatus.partialContent : HttpStatus.ok;
      resp.headers
        ..contentType = ContentType('video', 'mp4')
        ..set(HttpHeaders.acceptRangesHeader, 'bytes');
      if (partial) {
        resp.headers.set(HttpHeaders.contentRangeHeader, 'bytes $start-$end/$total');
      }
      resp.contentLength = end - start + 1;

      final ctr = AesCtr(_key, iv);
      raf.setPositionSync(16 + start);
      var pos = start;
      const chunk = 256 * 1024;
      while (pos <= end) {
        final data = raf.readSync(min(chunk, end - pos + 1));
        if (data.isEmpty) break;
        resp.add(ctr.transform(data, pos));
        await resp.flush();
        pos += data.length;
      }
      await resp.close();
    } catch (_) {
      // Player closed the connection mid-stream — normal during seeks.
      try {
        await req.response.close();
      } catch (_) {}
    } finally {
      try {
        raf?.closeSync();
      } catch (_) {}
    }
  }
}

// ── AES-256-CTR with random access ───────────────────────────────────────────
// CTR keystream block i = AES(key, IV + i), so any byte offset can be
// decrypted independently — exactly what Range-based video seeking needs.

class AesCtr {
  final BlockCipher _aes;
  final Uint8List _iv;
  AesCtr(Uint8List key, this._iv) : _aes = AESEngine()..init(true, KeyParameter(key));

  /// En/decrypts [data] that lives at absolute plaintext [offset] (XOR is
  /// symmetric, so the same call does both).
  Uint8List transform(Uint8List data, int offset) {
    final out = Uint8List(data.length);
    final counter = Uint8List(16);
    final keystream = Uint8List(16);
    var block = offset ~/ 16;
    var posInBlock = offset % 16;
    var i = 0;
    while (i < data.length) {
      _counterFor(block, counter);
      _aes.processBlock(counter, 0, keystream, 0);
      while (posInBlock < 16 && i < data.length) {
        out[i] = data[i] ^ keystream[posInBlock];
        i++;
        posInBlock++;
      }
      posInBlock = 0;
      block++;
    }
    return out;
  }

  /// counter = IV (big-endian 128-bit) + blockIndex
  void _counterFor(int blockIndex, Uint8List out) {
    out.setAll(0, _iv);
    var carry = blockIndex;
    for (var i = 15; i >= 0 && carry > 0; i--) {
      final sum = out[i] + (carry & 0xff);
      out[i] = sum & 0xff;
      carry = (carry >> 8) + (sum >> 8);
    }
  }
}

/// Runs inside Isolate.run — streams [src] through AES-CTR into [dst] with a
/// random IV prepended. Returns the plaintext byte count.
int _encryptFileSync(String src, String dst, Uint8List key) {
  final rnd = Random.secure();
  final iv = Uint8List.fromList(List<int>.generate(16, (_) => rnd.nextInt(256)));
  final input = File(src).openSync();
  final output = File(dst).openSync(mode: FileMode.write);
  try {
    output.writeFromSync(iv);
    final ctr = AesCtr(key, iv);
    var offset = 0;
    const chunk = 1 << 20;
    while (true) {
      final data = input.readSync(chunk);
      if (data.isEmpty) break;
      output.writeFromSync(ctr.transform(Uint8List.fromList(data), offset));
      offset += data.length;
    }
    return offset;
  } finally {
    input.closeSync();
    output.closeSync();
  }
}
