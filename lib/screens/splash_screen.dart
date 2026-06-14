// splash_screen.dart
//
// In-app splash: a solid #050D1A background with a native Flutter recreation
// of the animated "VS Code"-style SVG logo. The native (OS) splash uses the
// same flat background colour, so the hand-off from native splash -> this
// screen is seamless. Once the logo animation has played, we deep-link or
// navigate to /home.

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_drawing/path_drawing.dart';

import '../data/fcm_service.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  void _leaveSplash() {
    if (_navigated || !mounted) return;
    _navigated = true;
    context.go('/home');
    // If the app was launched by tapping a notification, deep link now that
    // the home stack exists.
    final pendingId = pendingNotificationMediaId;
    if (pendingId != null && pendingId.isNotEmpty) {
      pendingNotificationMediaId = null;
      context.push('/detail/$pendingId?autoplay=1');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SinemaxColors.bg,
      body: Center(
        child: AnimatedSvgLogo(
          size: 240,
          // Navigate when the logo animation actually finishes (plus a short
          // hold so the completed logo is visible), instead of guessing a delay.
          onCompleted: _leaveSplash,
          holdAfterComplete: const Duration(milliseconds: 700),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Native Flutter recreation of the animated "VS Code"-style SVG icon.
//
// Usage:
//   AnimatedSvgLogo()                 // default 240px wide
//   AnimatedSvgLogo(size: 120)        // any width; height keeps the SVG aspect
//   AnimatedSvgLogo(size: 64, autoplay: false)
//
// The widget sizes itself to `size` (width). Height is derived from the
// original viewBox aspect ratio (94 x 86) so the art never distorts. Wrap it
// in a SizedBox/FittedBox/Center if you need different layout behaviour.
// ---------------------------------------------------------------------------
class AnimatedSvgLogo extends StatefulWidget {
  /// Target width in logical pixels. Height is computed from the viewBox ratio.
  final double size;

  /// Play the draw-on animation automatically on mount.
  final bool autoplay;

  /// Replay the animation when tapped.
  final bool replayOnTap;

  /// Called once the draw-on animation finishes (after [holdAfterComplete]).
  final VoidCallback? onCompleted;

  /// How long to wait after the animation completes before firing
  /// [onCompleted], so the finished logo stays on screen briefly.
  final Duration holdAfterComplete;

  const AnimatedSvgLogo({
    super.key,
    this.size = 240,
    this.autoplay = true,
    this.replayOnTap = true,
    this.onCompleted,
    this.holdAfterComplete = Duration.zero,
  });

  @override
  State<AnimatedSvgLogo> createState() => _AnimatedSvgLogoState();
}

class _AnimatedSvgLogoState extends State<AnimatedSvgLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    if (widget.onCompleted != null) {
      _controller.addStatusListener(_onStatus);
    }
    if (widget.autoplay) {
      _controller.forward();
    } else {
      _controller.value = 1.0; // show the finished logo
    }
  }

  void _onStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    // Fire onCompleted once the draw-on finishes, after an optional hold so the
    // completed logo lingers before the parent navigates away.
    Future.delayed(widget.holdAfterComplete, () {
      if (mounted) widget.onCompleted?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Preserve the original viewBox aspect ratio (94 x 86) so scaleX == scaleY
    // inside the painter and nothing stretches.
    final double width = widget.size;
    final double height = width * (_LogoPainter.vbH / _LogoPainter.vbW);

    final child = SizedBox(
      width: width,
      height: height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(painter: _LogoPainter(progress: _controller.value));
        },
      ),
    );

    if (!widget.replayOnTap) return child;
    return GestureDetector(
      onTap: () => _controller.forward(from: 0),
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Cached, lazily-built drawing assets.
//
// FIX (Bug 1): parsing happens on first paint() via _LogoAssets.instance, NOT
// at class-load time, so parseSvgPathData()/Path metrics are only built once
// the Flutter engine is ready.
// FIX (Perf 6 & 7): shaders and PathMetrics are computed exactly once here and
// reused every frame instead of being rebuilt on each paint().
// ---------------------------------------------------------------------------
class _ShapeAsset {
  final Path path;
  final List<ui.PathMetric> metrics; // precomputed once
  final Rect bounds; // SVG-space bounds, used for saveLayer
  final Shader? shader; // gradient fill (null for solid fills)
  final Color? solidColor; // solid fill (null for gradient fills)
  final Color strokeColor;
  final double strokeWidth;

  _ShapeAsset._({
    required this.path,
    required this.shader,
    required this.solidColor,
    required this.strokeColor,
    required this.strokeWidth,
  })  : metrics = path.computeMetrics().toList(growable: false),
        bounds = path.getBounds();

  factory _ShapeAsset.gradient(
    String d,
    Shader shader,
    Color stroke,
    double strokeWidth,
  ) {
    return _ShapeAsset._(
      path: parseSvgPathData(d.trim()),
      shader: shader,
      solidColor: null,
      strokeColor: stroke,
      strokeWidth: strokeWidth,
    );
  }

  factory _ShapeAsset.solid(
    String d,
    Color fill,
    Color stroke,
    double strokeWidth,
  ) {
    return _ShapeAsset._(
      path: parseSvgPathData(d.trim()),
      shader: null,
      solidColor: fill,
      strokeColor: stroke,
      strokeWidth: strokeWidth,
    );
  }
}

class _LogoAssets {
  final _ShapeAsset top;
  final _ShapeAsset bottom;
  final _ShapeAsset play;
  final List<_ShapeAsset> word;

  _LogoAssets._({
    required this.top,
    required this.bottom,
    required this.play,
    required this.word,
  });

  static _LogoAssets? _i;
  static _LogoAssets get instance => _i ??= _build();

  static _LogoAssets _build() {
    // FIX (Gap 8): gradient directions use the SVG's exact userSpaceOnUse
    // coordinates. gTop2/gBot2 are vertical; gWord2 is left->right.
    final topShader = ui.Gradient.linear(
      const Offset(55, 19),
      const Offset(55, 52),
      const [Color(0xFFBBDAFF), Color(0xFF6FA4F2)],
    );
    final bottomShader = ui.Gradient.linear(
      const Offset(55, 38),
      const Offset(55, 72),
      const [Color(0xFF6FA4F2), Color(0xFF3B74DC)],
    );
    final wordShader = ui.Gradient.linear(
      const Offset(20, 80),
      const Offset(92, 80),
      const [Color(0xFF4DA9FF), Color(0xFF2A6FDB)],
    );

    return _LogoAssets._(
      top: _ShapeAsset.gradient(_pTop, topShader, const Color(0xFFBBDAFF), 0.55),
      bottom:
          _ShapeAsset.gradient(_pBottom, bottomShader, const Color(0xFF5E97EE), 0.55),
      play: _ShapeAsset.solid(
        _pPlay,
        const Color(0xFF3D85EC),
        const Color(0xFF8FCBFF),
        0.55,
      ),
      word: _pWord
          .map((d) => _ShapeAsset.gradient(d, wordShader, const Color(0xFF4DA9FF), 0.3))
          .toList(growable: false),
    );
  }

  // ---- Raw path "d" strings (relative SVG paths; the leading lowercase `m`
  // is treated as an absolute moveTo per the SVG spec, so each path lands at
  // its correct position — see note on Bug 4 below). ----

  static const _pTop =
      'm45.7 49.8c-4.7-1.7-8.5-3.8-8.5-7.3 0.3-4.4 7-9.1 20.5-10.6 4.8-0.6 14.8-1.2 18.1 1l3.6-10.2c0.4-1.2-1.7-2.4-5.3-2.8-4.7-0.5-9.8-0.3-15.7 0.5-4.1 0.6-9.3 1.8-14 4-3.9 1.9-11.1 6.2-11 13.2 0.1 6.6 7.2 10.3 12.3 12.2zm30.4-28.1c0.5 0.1 1.1 0.3 1.6 0.6l-0.7 2c-0.6-0.2-1.1-0.3-1.6-0.5l0.7-2.1zm-4.4-0.8c0.7 0 1.5 0.1 2.1 0.2l-0.6 2.2c-0.7-0.1-1.5-0.2-2.2-0.2l0.7-2.2zm-5.6 0.1h2.5l-0.4 2.1h-2.5l0.4-2.1zm-5.6 0.6c0.9-0.1 1.7-0.2 2.6-0.2l-0.4 2.1c-0.9 0.1-1.8 0.2-2.5 0.3l0.3-2.2zm-5.7 1.2c0.8-0.2 1.7-0.4 2.7-0.5l-0.3 2.1c-0.7 0.2-1.6 0.3-2.5 0.6l0.1-2.2zm-5.3 1.5 2.8-0.9-0.2 2.4-2.7 0.9 0.1-2.4z';

  static const _pBottom =
      'm59.7 40.6c4.3 1.6 9.7 4.8 9.9 7.6 0 1.9-1.6 6.7-11 9.4-3.5 1.1-9.1 2.2-15.2 2.2-3.7 0-7-0.6-8.2-1.7l-3.3 9.4c-0.1 1.5 2.3 3.7 10.9 3.7 5.6 0.1 14.5-1.1 19.3-2.8 3.4-1.1 11.8-4.1 12.4-11.9 0.2-4.2-2.3-7.1-4.6-9.5-2.7-2.9-6.9-5-10.2-6.4zm-25.3 28c-0.5-0.2-0.9-0.5-1.2-0.8l0.6-1.9 1.2 0.7-0.6 2zm4 1c-0.7-0.1-1.5-0.2-2-0.4l0.5-2c0.7 0.1 1.4 0.3 2.2 0.4l-0.7 2zm5.4 0c-0.9 0.1-1.6 0.1-2.5 0l0.4-2h2.5l-0.4 2zm5.3-0.6c-0.8 0.1-1.7 0.2-2.6 0.3l0.4-2c0.8-0.1 1.7-0.2 2.6-0.3l-0.4 2zm5.3-0.8c-0.8 0.2-1.6 0.3-2.4 0.4l0.2-2c0.8-0.2 1.7-0.3 2.5-0.5l-0.3 2.1zm5.3-1.5-2.7 0.7 0.1-2.1 2.7-0.8-0.1 2.2z';

  static const _pPlay =
      'm51.4 37.9 9.6 6.3c1.1 0.7 1.1 1.9 0.1 2.5l-9.6 6.4c-1 0.7-2.1 0.2-2.1-0.8v-13.7c0-1 1-1.3 2-0.7z';

  // "VSCODE" wordmark sub-paths (S, i-dot, i-stem, N, E, M, A, X).
  static const _pWord = <String>[
    'm26 79.2h-4.1c-0.7 0-0.9-0.3-0.9-0.8 0-0.4 0.2-0.7 0.9-0.7h5.9c0.4 0.1 0.6-1.2 0.7-1.8l-0.1-0.1h-7c-1.7 0-2.9 0.7-2.9 2.3v0.3c0 1.6 1 2.3 2.7 2.3h4.2c0.7 0 0.9 0.3 0.9 0.7v0.3c-0.1 0.3-0.4 0.5-0.8 0.5h-6.4l-0.3 0.2c-0.2 0.5-0.4 1.3-0.4 1.5h0.1 7.3c1.9 0 2.7-0.8 2.7-2.3v-0.3c0-1.4-0.7-2.1-2.5-2.1z',
    'm31.3 75.1c-0.5 0-0.9 0.4-0.9 0.9s0.4 0.8 0.9 0.8 0.9-0.3 0.9-0.8-0.4-0.9-0.9-0.9z',
    'm31.6 78.1h-0.9c-0.4 0-0.4 0.3-0.4 0.5v4.8c0 0.4 0.2 0.4 0.4 0.4h0.9c0.3 0 0.5-0.1 0.5-0.4v-4.8c0-0.4-0.2-0.5-0.5-0.5z',
    'm42.6 76.8h-0.9c-0.3 0-0.5 0.1-0.5 0.5v4l-4.3-4c-0.5-0.4-0.8-0.6-1.2-0.6h-0.3c-0.7 0-1.2 0.1-1.2 0.9v5.8c0 0.4 0.2 0.4 0.4 0.4h0.9c0.4 0 0.5 0 0.6-0.4v-4.2l4.4 3.9c0.6 0.5 0.8 0.8 1.4 0.8h0.3c0.6 0 1-0.3 1-0.8v-5.9c0-0.3 0-0.4-0.4-0.4h-0.2z',
    'm45.1 77.1h8c0.3 0 0.5 0.2 0.5 0.5v3c0 0.3-0.2 0.5-0.5 0.5h-6.4l-0.1 0.2c-0.1 0.5 0 0.8 0.3 0.8h6.4l0.3 0.1c0.1 0.1 0.2 1.4 0.1 1.5l-0.3 0.1h-6.8c-1.3 0-2-0.8-2-2.2v-4c0-0.3 0.2-0.5 0.5-0.5zm1.2 1.5v1h5.6v-1z',
    'm66.3 75.6h-0.6c-0.6 0-1 0.2-1.3 0.7l-3 4.7-3.1-4.7c-0.3-0.4-0.6-0.7-1.3-0.7h-0.7c-0.4 0-0.6 0.3-0.6 0.5v7.4c0 0.3 0.3 0.3 0.4 0.3h1.1c0.4 0 0.4-0.2 0.4-0.5v-4.7l2.9 4.4c0.1 0.2 0.4 0.4 0.7 0.4s0.6-0.1 0.7-0.3l3.1-4.5 0.1 4.7c0 0.5 0.3 0.5 0.5 0.5h0.9c0.2 0 0.4 0 0.4-0.3v-7.4c0-0.2 0-0.5-0.6-0.5z',
    'm74.5 77.1h-5.6c-0.3 0-0.3 0.2-0.3 0.3v1.1c0.1 0.3 0.2 0.3 0.4 0.3h5c0.9 0 1.2 0.3 1.2 1h-5.3c-0.9 0.1-1.6 0.6-1.6 2 0 1.2 0.7 1.9 1.8 2h4l1.1-0.2 0.2 0.2h1.6l0.1-0.1v-4.5c0-1.4-0.7-2.1-2.3-2.1h-0.3zm0.7 4.7c-0.1 0.4-0.3 0.4-0.6 0.4h-3.5c-0.5 0-0.6-0.3-0.6-0.5l0.1-0.4 0.3-0.1h4.3v0.6z',
    'm86.3 79.8 4.7-4.9h-2.7l-0.4 0.2-2.9 3.1-3.1-3.2-0.2-0.1h-3.1l4.5 4.9-4.5 4.8h2.9l0.3-0.1 3.1-3.2 2.8 3 0.3 0.3h3.1l-4.8-4.8z',
  ];
}

class _LogoPainter extends CustomPainter {
  final double progress; // 0.0 -> 1.0

  _LogoPainter({required this.progress});

  // Original SVG viewBox: 8 9 94 86 -> (minX, minY, width, height)
  static const double vbMinX = 8;
  static const double vbMinY = 9;
  static const double vbW = 94;
  static const double vbH = 86;

  static const _bg = Color(0xFF050D1A);

  @override
  void paint(Canvas canvas, Size size) {
    final assets = _LogoAssets.instance; // built once, lazily (Bug 1 fix)

    // Background
    canvas.drawRect(Offset.zero & size, Paint()..color = _bg);

    // Map SVG viewBox coordinates -> canvas size. The widget keeps the aspect
    // ratio, so scaleX == scaleY and nothing distorts; the formula still works
    // if a non-proportional box is forced.
    final scaleX = size.width / vbW;
    final scaleY = size.height / vbH;
    canvas.save();
    canvas.scale(scaleX, scaleY);
    canvas.translate(-vbMinX, -vbMinY);

    // --- Animation timeline (fractions of overall progress) ---
    // 1. Top + bottom "C" shapes draw in as strokes        (0.00 -> 0.45)
    // 2. They fill with gradient while play triangle draws  (0.30 -> 0.65)
    // 3. Wordmark "VSCODE" draws + fills letter by letter   (0.55 -> 1.00)
    final shapeDraw = _ease(_segment(progress, 0.0, 0.45));
    final shapeFill = _ease(_segment(progress, 0.30, 0.65));
    final playDraw = _ease(_segment(progress, 0.40, 0.65));
    final playFill = _ease(_segment(progress, 0.55, 0.75));
    final wordProgress = _ease(_segment(progress, 0.55, 1.0));

    _drawShape(canvas, assets.top, drawT: shapeDraw, fillT: shapeFill);
    _drawShape(canvas, assets.bottom, drawT: shapeDraw, fillT: shapeFill);
    _drawShape(canvas, assets.play, drawT: playDraw, fillT: playFill);

    // Wordmark: stagger each letter with overlapping windows.
    // FIX (Bug 3): both span bounds are clamped to [0,1] and the slot math
    // keeps start < end for every letter (last letter ends exactly at 1.0),
    // so _segment() never gets an inverted range.
    final n = assets.word.length;
    const overlap = 1.4; // window width in slots -> letters fade into each other
    final slot = 1.0 / n;
    for (var i = 0; i < n; i++) {
      final spanStart = (i * slot).clamp(0.0, 1.0);
      final spanEnd = ((i + overlap) * slot).clamp(0.0, 1.0);
      final letterT = _ease(_segment(wordProgress, spanStart, spanEnd));
      _drawShape(
        canvas,
        assets.word[i],
        drawT: letterT,
        fillT: _ease(_segment(letterT, 0.4, 1.0)),
      );
    }

    canvas.restore();
  }

  /// Reveals a path's outline (stroke draw-on), then fades a fill in beneath it.
  /// FIX (Gap 9): the stroke stays fully opaque once drawn — it is not faded out
  /// as the fill arrives, matching the original SVG where stroke and fill are
  /// independent.
  void _drawShape(
    Canvas canvas,
    _ShapeAsset a, {
    required double drawT, // 0 -> 1 : stroke reveal
    required double fillT, // 0 -> 1 : fill opacity
  }) {
    if (drawT <= 0) return;

    // 1. FILL (drawn first, sits beneath the stroke).
    if (fillT > 0) {
      if (a.shader != null) {
        final fillPaint = Paint()
          ..style = PaintingStyle.fill
          ..shader = a.shader; // cached shader (Perf 6 fix)

        if (fillT >= 1.0) {
          // FIX (Perf 5): no offscreen layer at full opacity — the common case.
          canvas.drawPath(a.path, fillPaint);
        } else {
          // Uniformly fade a gradient-filled shape via a temporary layer.
          // FIX (Bug 2): withValues(alpha:) replaces deprecated withOpacity().
          canvas.saveLayer(
            a.bounds.inflate(2),
            Paint()..color = const Color(0xFFFFFFFF).withValues(alpha: fillT),
          );
          canvas.drawPath(a.path, fillPaint);
          canvas.restore();
        }
      } else {
        // Solid fill: bake opacity straight into the color, no layer needed.
        canvas.drawPath(
          a.path,
          Paint()
            ..style = PaintingStyle.fill
            ..color = a.solidColor!.withValues(alpha: fillT),
        );
      }
    }

    // 2. STROKE (drawn on top, always fully visible).
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = a.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = a.strokeColor;

    if (drawT >= 1.0) {
      canvas.drawPath(a.path, strokePaint);
    } else {
      // FIX (Perf 7): iterate the precomputed PathMetrics; only extractPath()
      // runs per frame, metrics themselves are never recomputed.
      for (final metric in a.metrics) {
        canvas.drawPath(metric.extractPath(0, metric.length * drawT), strokePaint);
      }
    }
  }

  /// Maps [progress] within [start, end] to 0..1, clamped. Guards start >= end.
  double _segment(double progress, double start, double end) {
    if (end <= start) return progress >= end ? 1 : 0;
    return ((progress - start) / (end - start)).clamp(0.0, 1.0);
  }

  double _ease(double t) => Curves.easeInOut.transform(t);

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
