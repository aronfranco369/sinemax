class WatchedItem {
  final String contentId;
  final String watchedAt;
  final double progress;
  final String context;

  const WatchedItem({
    required this.contentId,
    required this.watchedAt,
    required this.progress,
    required this.context,
  });
}

class DownloadItem {
  final String contentId;
  final String quality;
  final String size;
  final String at;
  final String context;

  const DownloadItem({
    required this.contentId,
    required this.quality,
    required this.size,
    required this.at,
    required this.context,
  });
}
