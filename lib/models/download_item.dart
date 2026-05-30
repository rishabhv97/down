class DownloadItem {
  final String id;
  final String title;
  final String format;     // e.g., "MP4"
  final String resolution; // e.g., "1080p"
  final String fileSize;   // e.g., "84.3 MB"
  final String thumbnail;
  double progress;         // 0.0 to 1.0

  DownloadItem({
    required this.id,
    required this.title,
    required this.format,
    required this.resolution,
    required this.fileSize,
    required this.thumbnail,
    this.progress = 0.0,
  });
}