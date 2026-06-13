// animated_logo.dart
//
// Native Flutter recreation of the animated "VS Code"-style SVG icon.
// Add the package to pubspec.yaml:
//
//   dependencies:
//     path_drawing: ^1.0.1
//
// Usage:
//   AnimatedSvgLogo(size: 200)

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class AnimatedSvgLogo extends StatefulWidget {
  final double size;
  const AnimatedSvgLogo({super.key, this.size = 240});

  @override
  State<AnimatedSvgLogo> createState() => _AnimatedSvgLogoState();
}

class _AnimatedSvgLogoState extends State<AnimatedSvgLogo> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2600))..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _controller.forward(from: 0),
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(painter: _LogoPainter(progress: _controller.value));
          },
        ),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final double progress; // 0.0 -> 1.0

  _LogoPainter({required this.progress});

  // Original SVG viewBox: 8 9 94 86  -> (minX, minY, width, height)
  static const double _vbMinX = 8;
  static const double _vbMinY = 9;
  static const double _vbW = 94;
  static const double _vbH = 86;

  // ---- Raw path "d" strings copied from the SVG ----

  static const _pTop = '''
m45.7 49.8c-4.7-1.7-8.5-3.8-8.5-7.3 0.3-4.4 7-9.1 20.5-10.6 4.8-0.6 14.8-1.2 18.1 1l3.6-10.2c0.4-1.2-1.7-2.4-5.3-2.8-4.7-0.5-9.8-0.3-15.7 0.5-4.1 0.6-9.3 1.8-14 4-3.9 1.9-11.1 6.2-11 13.2 0.1 6.6 7.2 10.3 12.3 12.2zm30.4-28.1c0.5 0.1 1.1 0.3 1.6 0.6l-0.7 2c-0.6-0.2-1.1-0.3-1.6-0.5l0.7-2.1zm-4.4-0.8c0.7 0 1.5 0.1 2.1 0.2l-0.6 2.2c-0.7-0.1-1.5-0.2-2.2-0.2l0.7-2.2zm-5.6 0.1h2.5l-0.4 2.1h-2.5l0.4-2.1zm-5.6 0.6c0.9-0.1 1.7-0.2 2.6-0.2l-0.4 2.1c-0.9 0.1-1.8 0.2-2.5 0.3l0.3-2.2zm-5.7 1.2c0.8-0.2 1.7-0.4 2.7-0.5l-0.3 2.1c-0.7 0.2-1.6 0.3-2.5 0.6l0.1-2.2zm-5.3 1.5 2.8-0.9-0.2 2.4-2.7 0.9 0.1-2.4z
''';

  static const _pBottom = '''
m59.7 40.6c4.3 1.6 9.7 4.8 9.9 7.6 0 1.9-1.6 6.7-11 9.4-3.5 1.1-9.1 2.2-15.2 2.2-3.7 0-7-0.6-8.2-1.7l-3.3 9.4c-0.1 1.5 2.3 3.7 10.9 3.7 5.6 0.1 14.5-1.1 19.3-2.8 3.4-1.1 11.8-4.1 12.4-11.9 0.2-4.2-2.3-7.1-4.6-9.5-2.7-2.9-6.9-5-10.2-6.4zm-25.3 28c-0.5-0.2-0.9-0.5-1.2-0.8l0.6-1.9 1.2 0.7-0.6 2zm4 1c-0.7-0.1-1.5-0.2-2-0.4l0.5-2c0.7 0.1 1.4 0.3 2.2 0.4l-0.7 2zm5.4 0c-0.9 0.1-1.6 0.1-2.5 0l0.4-2h2.5l-0.4 2zm5.3-0.6c-0.8 0.1-1.7 0.2-2.6 0.3l0.4-2c0.8-0.1 1.7-0.2 2.6-0.3l-0.4 2zm5.3-0.8c-0.8 0.2-1.6 0.3-2.4 0.4l0.2-2c0.8-0.2 1.7-0.3 2.5-0.5l-0.3 2.1zm5.3-1.5-2.7 0.7 0.1-2.1 2.7-0.8-0.1 2.2z
''';

  static const _pPlay = '''
m51.4 37.9 9.6 6.3c1.1 0.7 1.1 1.9 0.1 2.5l-9.6 6.4c-1 0.7-2.1 0.2-2.1-0.8v-13.7c0-1 1-1.3 2-0.7z
''';

  // "VSCODE" wordmark sub-paths
  static const _pWord = [
    // S
    'm26 79.2h-4.1c-0.7 0-0.9-0.3-0.9-0.8 0-0.4 0.2-0.7 0.9-0.7h5.9c0.4 0.1 0.6-1.2 0.7-1.8l-0.1-0.1h-7c-1.7 0-2.9 0.7-2.9 2.3v0.3c0 1.6 1 2.3 2.7 2.3h4.2c0.7 0 0.9 0.3 0.9 0.7v0.3c-0.1 0.3-0.4 0.5-0.8 0.5h-6.4l-0.3 0.2c-0.2 0.5-0.4 1.3-0.4 1.5h0.1 7.3c1.9 0 2.7-0.8 2.7-2.3v-0.3c0-1.4-0.7-2.1-2.5-2.1z',
    // dot (i)
    'm31.3 75.1c-0.5 0-0.9 0.4-0.9 0.9s0.4 0.8 0.9 0.8 0.9-0.3 0.9-0.8-0.4-0.9-0.9-0.9z',
    // i stem
    'm31.6 78.1h-0.9c-0.4 0-0.4 0.3-0.4 0.5v4.8c0 0.4 0.2 0.4 0.4 0.4h0.9c0.3 0 0.5-0.1 0.5-0.4v-4.8c0-0.4-0.2-0.5-0.5-0.5z',
    // N
    'm42.6 76.8h-0.9c-0.3 0-0.5 0.1-0.5 0.5v4l-4.3-4c-0.5-0.4-0.8-0.6-1.2-0.6h-0.3c-0.7 0-1.2 0.1-1.2 0.9v5.8c0 0.4 0.2 0.4 0.4 0.4h0.9c0.4 0 0.5 0 0.6-0.4v-4.2l4.4 3.9c0.6 0.5 0.8 0.8 1.4 0.8h0.3c0.6 0 1-0.3 1-0.8v-5.9c0-0.3 0-0.4-0.4-0.4h-0.2z',
    // E
    'm45.1 77.1h8c0.3 0 0.5 0.2 0.5 0.5v3c0 0.3-0.2 0.5-0.5 0.5h-6.4l-0.1 0.2c-0.1 0.5 0 0.8 0.3 0.8h6.4l0.3 0.1c0.1 0.1 0.2 1.4 0.1 1.5l-0.3 0.1h-6.8c-1.3 0-2-0.8-2-2.2v-4c0-0.3 0.2-0.5 0.5-0.5zm1.2 1.5v1h5.6v-1z',
    // M
    'm66.3 75.6h-0.6c-0.6 0-1 0.2-1.3 0.7l-3 4.7-3.1-4.7c-0.3-0.4-0.6-0.7-1.3-0.7h-0.7c-0.4 0-0.6 0.3-0.6 0.5v7.4c0 0.3 0.3 0.3 0.4 0.3h1.1c0.4 0 0.4-0.2 0.4-0.5v-4.7l2.9 4.4c0.1 0.2 0.4 0.4 0.7 0.4s0.6-0.1 0.7-0.3l3.1-4.5 0.1 4.7c0 0.5 0.3 0.5 0.5 0.5h0.9c0.2 0 0.4 0 0.4-0.3v-7.4c0-0.2 0-0.5-0.6-0.5z',
    // A
    'm74.5 77.1h-5.6c-0.3 0-0.3 0.2-0.3 0.3v1.1c0.1 0.3 0.2 0.3 0.4 0.3h5c0.9 0 1.2 0.3 1.2 1h-5.3c-0.9 0.1-1.6 0.6-1.6 2 0 1.2 0.7 1.9 1.8 2h4l1.1-0.2 0.2 0.2h1.6l0.1-0.1v-4.5c0-1.4-0.7-2.1-2.3-2.1h-0.3zm0.7 4.7c-0.1 0.4-0.3 0.4-0.6 0.4h-3.5c-0.5 0-0.6-0.3-0.6-0.5l0.1-0.4 0.3-0.1h4.3v0.6z',
    // X
    'm86.3 79.8 4.7-4.9h-2.7l-0.4 0.2-2.9 3.1-3.1-3.2-0.2-0.1h-3.1l4.5 4.9-4.5 4.8h2.9l0.3-0.1 3.1-3.2 2.8 3 0.3 0.3h3.1l-4.8-4.8z',
  ];

  // Cache parsed paths so we don't re-parse every frame.
  static final Path _topPath = parseSvgPathData(_pTop.trim());
  static final Path _bottomPath = parseSvgPathData(_pBottom.trim());
  static final Path _playPath = parseSvgPathData(_pPlay.trim());
  static final List<Path> _wordPaths = _pWord.map((d) => parseSvgPathData(d.trim())).toList();

  // ---- Colors ----
  static const _topGradient = [Color(0xFFBBDAFF), Color(0xFF6FA4F2)];
  static const _bottomGradient = [Color(0xFF6FA4F2), Color(0xFF3B74DC)];
  static const _wordGradient = [Color(0xFF4DA9FF), Color(0xFF2A6FDB)];
  static const _playFill = Color(0xFF3D85EC);
  static const _playStroke = Color(0xFF8FCBFF);
  static const _topStroke = Color(0xFFBBDAFF);
  static const _bottomStroke = Color(0xFF5E97EE);
  static const _wordStroke = Color(0xFF4DA9FF);
  static const _bg = Color(0xFF050D1A);

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(Offset.zero & size, Paint()..color = _bg);

    // Map SVG viewBox coordinates -> canvas size.
    final scaleX = size.width / _vbW;
    final scaleY = size.height / _vbH;
    canvas.save();
    canvas.scale(scaleX, scaleY);
    canvas.translate(-_vbMinX, -_vbMinY);

    // --- Animation timeline (fractions of overall progress) ---
    // 1. Top + bottom "C" shapes draw in as strokes (0.0 -> 0.45)
    // 2. They fill with gradient while play triangle draws (0.35 -> 0.65)
    // 3. Wordmark "VSCODE" draws+fills in sequence (0.55 -> 1.0)

    final shapeDraw = _ease(_segment(progress, 0.0, 0.45));
    final shapeFill = _ease(_segment(progress, 0.30, 0.65));
    final playDraw = _ease(_segment(progress, 0.40, 0.65));
    final playFill = _ease(_segment(progress, 0.55, 0.75));
    final wordProgress = _ease(_segment(progress, 0.55, 1.0));

    _drawShape(canvas, path: _topPath, drawT: shapeDraw, fillT: shapeFill, gradientColors: _topGradient, strokeColor: _topStroke, strokeWidth: 0.55, bounds: const Rect.fromLTWH(20, 19, 70, 33));

    _drawShape(
      canvas,
      path: _bottomPath,
      drawT: shapeDraw,
      fillT: shapeFill,
      gradientColors: _bottomGradient,
      strokeColor: _bottomStroke,
      strokeWidth: 0.55,
      bounds: const Rect.fromLTWH(20, 38, 70, 34),
    );

    // Play triangle (solid fill + outline)
    _drawShape(
      canvas,
      path: _playPath,
      drawT: playDraw,
      fillT: playFill,
      gradientColors: const [_playFill, _playFill],
      strokeColor: _playStroke,
      strokeWidth: 0.55,
      bounds: const Rect.fromLTWH(49, 37, 12, 16),
    );

    // Wordmark: stagger each letter
    final letterCount = _wordPaths.length;
    for (var i = 0; i < letterCount; i++) {
      final start = i / letterCount;
      final end = (i + 1.4) / letterCount;
      final t = _ease(_segment(wordProgress, start.clamp(0, 1), end.clamp(0, 1)));
      _drawShape(
        canvas,
        path: _wordPaths[i],
        drawT: t,
        fillT: _ease(_segment(t, 0.4, 1.0)),
        gradientColors: _wordGradient,
        strokeColor: _wordStroke,
        strokeWidth: 0.3,
        bounds: const Rect.fromLTWH(20, 75, 72, 9),
      );
    }

    canvas.restore();
  }

  /// Draws a path that first reveals its outline (stroke, like
  /// stroke-dasharray="1" / stroke-dashoffset animating 1 -> 0),
  /// then crossfades into a filled gradient/solid shape.
  void _drawShape(
    Canvas canvas, {
    required Path path,
    required double drawT, // 0 -> 1 : stroke reveal
    required double fillT, // 0 -> 1 : fill opacity
    required List<Color> gradientColors,
    required Color strokeColor,
    required double strokeWidth,
    required Rect bounds,
  }) {
    if (drawT <= 0) return;

    // 1. Fill (fades in after stroke mostly drawn)
    if (fillT > 0) {
      final isSolid = gradientColors[0] == gradientColors[1];

      if (isSolid) {
        final fillPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = gradientColors[0].withOpacity(fillT);
        canvas.drawPath(path, fillPaint);
      } else {
        // Fade the whole gradient-filled shape in via saveLayer opacity.
        canvas.saveLayer(bounds.inflate(2), Paint()..color = Colors.white.withOpacity(fillT));
        final gradientPaint = Paint()
          ..style = PaintingStyle.fill
          ..shader = LinearGradient(colors: gradientColors, begin: Alignment.topCenter, end: Alignment.bottomCenter).createShader(bounds);
        canvas.drawPath(path, gradientPaint);
        canvas.restore();
      }
    }

    // 2. Stroke reveal using PathMetrics (dash-draw effect)
    if (drawT < 1.0) {
      final strokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = strokeColor;

      for (final metric in path.computeMetrics()) {
        final extractLength = metric.length * drawT;
        final extracted = metric.extractPath(0, extractLength);
        canvas.drawPath(extracted, strokePaint);
      }
    } else {
      // Fully drawn: draw a thin full outline for crispness.
      final strokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = strokeColor.withOpacity(1 - fillT * 0.5);
      canvas.drawPath(path, strokePaint);
    }
  }

  /// Maps [progress] within [start, end] to 0..1, clamped.
  double _segment(double progress, double start, double end) {
    if (end <= start) return progress >= end ? 1 : 0;
    final t = (progress - start) / (end - start);
    return t.clamp(0.0, 1.0);
  }

  double _ease(double t) => Curves.easeInOut.transform(t);

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) => oldDelegate.progress != progress;
}
