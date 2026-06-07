class Episode {
  final int ep;
  final String title;
  final String duration;
  final double progress;

  const Episode({
    required this.ep,
    required this.title,
    required this.duration,
    this.progress = 0.0,
  });
}
