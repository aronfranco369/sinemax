import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/download_engine.dart';
import '../data/providers.dart';
import '../models/library_item.dart';
import '../models/media.dart';
import '../theme/app_theme.dart';
import 'sinemax_icon.dart';

// ── Detail screen: main "Download" action button ─────────────────────────────

/// Drop-in replacement for the Download ActionBtn — reflects the live state of
/// the given file (idle / queued / progress % / paused / securing / done).
class DownloadActionBtn extends ConsumerWidget {
  final Media media;
  final MediaFile? file;
  const DownloadActionBtn({super.key, required this.media, this.file});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rec = file == null ? null : ref.watch(downloadsProvider)[file!.id];
    final notifier = ref.read(downloadsProvider.notifier);

    String icon = 'download';
    String label = 'Download';
    bool active = false;
    VoidCallback? onTap = file == null ? null : () => startDownload(context, ref, media, file!);

    switch (rec?.statusEnum) {
      case null:
        break;
      case DownloadStatus.queued:
        label = 'Waiting…';
        icon = 'clock';
        active = true;
        onTap = () => notifier.cancel(rec!.fileId);
      case DownloadStatus.running:
        label = '${(rec!.progress * 100).round()}%';
        icon = 'pause';
        active = true;
        onTap = () => notifier.pause(rec.fileId);
      case DownloadStatus.paused:
        label = 'Resume ${(rec!.progress * 100).round()}%';
        icon = 'play';
        active = true;
        onTap = () => notifier.resume(rec.fileId);
      case DownloadStatus.encrypting:
        label = 'Saving…';
        icon = 'gear';
        active = true;
        onTap = null;
      case DownloadStatus.completed:
        label = 'Downloaded';
        icon = 'check';
        active = true;
        onTap = () => confirmRemoveDownload(context, ref, rec!);
      case DownloadStatus.failed:
        label = 'Retry';
        icon = 'download';
        onTap = () => retryDownload(context, ref, rec!);
    }

    final color = active ? SinemaxColors.blue : SinemaxColors.muted;
    final progress = rec != null && (rec.statusEnum == DownloadStatus.running || rec.statusEnum == DownloadStatus.paused) ? rec.progress : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: SinemaxColors.panel,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: active ? SinemaxColors.blue.withAlpha(90) : SinemaxColors.line, width: 0.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              // progress fill behind the label while downloading / paused
              if (progress != null)
                Positioned.fill(
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: const ColoredBox(color: Color(0x1F2D8EFF)),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SinemaxIcon(icon, size: 16, color: color),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: SinemaxTextStyles.body(12, weight: FontWeight.w500, color: color),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Detail screen: per-episode compact icon ───────────────────────────────────

/// Small state-aware download control used in episode rows.
class FileDownloadIcon extends ConsumerWidget {
  final Media media;
  final MediaFile file;
  const FileDownloadIcon({super.key, required this.media, required this.file});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rec = ref.watch(downloadsProvider)[file.id];
    final notifier = ref.read(downloadsProvider.notifier);

    switch (rec?.statusEnum) {
      case null:
      case DownloadStatus.failed:
        return _tap(() => rec == null ? startDownload(context, ref, media, file) : retryDownload(context, ref, rec), SinemaxIcon('download', size: 15, color: rec == null ? SinemaxColors.muted2 : SinemaxColors.red));
      case DownloadStatus.queued:
        return _tap(() => notifier.cancel(rec!.fileId), _ring(null, 'x'));
      case DownloadStatus.running:
        return _tap(() => notifier.pause(rec!.fileId), _ring(rec!.progress, 'pause'));
      case DownloadStatus.paused:
        return _tap(() => notifier.resume(rec!.fileId), _ring(rec!.progress, 'play', dim: true));
      case DownloadStatus.encrypting:
        return _ring(null, 'gear');
      case DownloadStatus.completed:
        return _tap(() => confirmRemoveDownload(context, ref, rec!), const SinemaxIcon('check', size: 16, color: SinemaxColors.teal));
    }
  }

  Widget _tap(VoidCallback onTap, Widget child) => GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Padding(padding: const EdgeInsets.all(4), child: child),
  );

  Widget _ring(double? progress, String icon, {bool dim = false}) {
    final color = dim ? SinemaxColors.muted : SinemaxColors.blue;
    return SizedBox(
      width: 26,
      height: 26,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(value: progress, strokeWidth: 2, color: color, backgroundColor: SinemaxColors.line2),
          SinemaxIcon(icon, size: 10, color: color),
        ],
      ),
    );
  }
}

// ── Downloads screen: per-file row inside a media group ───────────────────────

class DownloadTile extends ConsumerWidget {
  final DownloadRecord record;
  const DownloadTile({super.key, required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = record.statusEnum;
    final pct = (record.progress * 100).round();

    final String meta = switch (status) {
      DownloadStatus.queued => 'Waiting…',
      DownloadStatus.running => '$pct%${record.totalBytes > 0 ? ' · ${fmtBytes((record.progress * record.totalBytes).round())} of ${fmtBytes(record.totalBytes)}' : ''}',
      DownloadStatus.paused => 'Paused · $pct%',
      DownloadStatus.encrypting => 'Saving file…',
      DownloadStatus.completed => '${record.totalBytes > 0 ? '${fmtBytes(record.totalBytes)} · ' : ''}${fmtDate(record.at)}',
      DownloadStatus.failed => 'Download failed',
    };

    final showBar = status == DownloadStatus.running || status == DownloadStatus.paused || status == DownloadStatus.queued;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.label,
                  style: SinemaxTextStyles.body(13, weight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(meta, style: SinemaxTextStyles.body(11, color: status == DownloadStatus.failed ? SinemaxColors.red : SinemaxColors.muted2)),
                if (showBar) ...[
                  const SizedBox(height: 7),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: status == DownloadStatus.queued ? null : record.progress.clamp(0.0, 1.0),
                      backgroundColor: SinemaxColors.line2,
                      color: status == DownloadStatus.paused ? SinemaxColors.muted : SinemaxColors.blue,
                      minHeight: 3,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          DownloadActionControls(record: record),
        ],
      ),
    );
  }
}

/// Trailing button cluster for a single download record — state-aware
/// (cancel / pause / resume / securing / delete / retry). Shared by the
/// compact episode rows and the rich movie rows on the Downloads screen.
class DownloadActionControls extends ConsumerWidget {
  final DownloadRecord record;
  const DownloadActionControls({super.key, required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(downloadsProvider.notifier);

    Widget btn(String icon, Color color, VoidCallback onTap) => GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 34,
        height: 34,
        margin: const EdgeInsets.only(left: 6),
        decoration: BoxDecoration(
          color: SinemaxColors.panel2,
          shape: BoxShape.circle,
          border: Border.all(color: SinemaxColors.line, width: 0.5),
        ),
        child: Center(child: SinemaxIcon(icon, size: 14, color: color)),
      ),
    );

    final List<Widget> children = switch (record.statusEnum) {
      DownloadStatus.queued => [btn('x', SinemaxColors.muted, () => notifier.cancel(record.fileId))],
      DownloadStatus.running => [btn('pause', SinemaxColors.blue, () => notifier.pause(record.fileId)), btn('x', SinemaxColors.muted, () => notifier.cancel(record.fileId))],
      DownloadStatus.paused => [btn('play', SinemaxColors.blue, () => notifier.resume(record.fileId)), btn('x', SinemaxColors.muted, () => notifier.cancel(record.fileId))],
      DownloadStatus.encrypting => [
          const Padding(
            padding: EdgeInsets.only(left: 6),
            child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: SinemaxColors.blue)),
          ),
        ],
      DownloadStatus.completed => [btn('trash', SinemaxColors.muted2, () => confirmRemoveDownload(context, ref, record))],
      DownloadStatus.failed => [btn('download', SinemaxColors.blue, () => notifier.retry(record)), btn('trash', SinemaxColors.muted2, () => notifier.remove(record.fileId))],
    };

    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

/// Kick off a download, surfacing an out-of-storage error as a SnackBar.
Future<void> startDownload(BuildContext context, WidgetRef ref, Media media, MediaFile file) =>
    _guardStorage(context, () => ref.read(downloadsProvider.notifier).start(media, file));

/// Retry a failed download, surfacing an out-of-storage error as a SnackBar.
Future<void> retryDownload(BuildContext context, WidgetRef ref, DownloadRecord rec) =>
    _guardStorage(context, () => ref.read(downloadsProvider.notifier).retry(rec));

Future<void> _guardStorage(BuildContext context, Future<void> Function() action) async {
  try {
    await action();
  } on InsufficientStorageException catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: SinemaxColors.panel,
        content: Text(
          'Not enough storage — free up at least ${fmtBytes(e.requiredBytes)} to download this.',
          style: SinemaxTextStyles.body(13),
        ),
      ),
    );
  }
}

Future<void> confirmRemoveDownload(BuildContext context, WidgetRef ref, DownloadRecord rec) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: SinemaxColors.panel,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text('Delete download?', style: SinemaxTextStyles.display(18, weight: FontWeight.w700)),
      content: Text('${rec.title} · ${rec.label} will be removed from this device.', style: SinemaxTextStyles.body(13, color: SinemaxColors.muted)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text('Cancel', style: SinemaxTextStyles.body(13, color: SinemaxColors.muted)),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(
            'Delete',
            style: SinemaxTextStyles.body(13, weight: FontWeight.w600, color: SinemaxColors.red),
          ),
        ),
      ],
    ),
  );
  if (confirmed == true) {
    await ref.read(downloadsProvider.notifier).remove(rec.fileId);
  }
}

String fmtBytes(int bytes) {
  if (bytes <= 0) return '0 B';
  const units = ['B', 'KB', 'MB', 'GB'];
  var v = bytes.toDouble();
  var u = 0;
  while (v >= 1024 && u < units.length - 1) {
    v /= 1024;
    u++;
  }
  return '${v >= 100 || u == 0 ? v.round() : v.toStringAsFixed(1)} ${units[u]}';
}

String fmtDate(String isoStr) {
  try {
    final dt = DateTime.parse(isoStr);
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day}';
  } catch (_) {
    return isoStr;
  }
}
