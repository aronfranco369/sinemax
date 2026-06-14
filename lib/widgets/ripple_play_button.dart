import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/app_theme.dart';

/// A play button wrapped in continuously expanding concentric rings — the
/// "tap to play" affordance shown over the poster while the player is idle,
/// and (compactly) on the episode row that is currently playing.
class RipplePlayButton extends StatefulWidget {
  /// Diameter of the solid central button.
  final double size;

  /// How far the rings expand relative to [size] (2.2 → rings reach 220%).
  final double maxRingScale;

  /// Number of concurrent rippling rings.
  final int ringCount;

  /// Stroke width of each ring.
  final double ringWidth;

  /// Optional tap handler. When null the widget is purely decorative
  /// (e.g. the now-playing indicator on an active episode row).
  final VoidCallback? onTap;

  /// Icon shown in the centre — defaults to a play glyph.
  final FaIconData icon;

  const RipplePlayButton({super.key, this.size = 64, this.maxRingScale = 2.2, this.ringCount = 3, this.ringWidth = 1.4, this.onTap, this.icon = FontAwesomeIcons.play});

  @override
  State<RipplePlayButton> createState() => _RipplePlayButtonState();
}

class _RipplePlayButtonState extends State<RipplePlayButton> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = widget.size * widget.maxRingScale;
    // Layout reserves only the central circle; the rings overflow it via the
    // OverflowBox and are clipped by the surrounding player Stack. This keeps
    // the circle/triangle at full size regardless of how wide the rings reach.
    final button = SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Staggered rings rippling outward beyond the central circle.
          OverflowBox(
            maxWidth: box,
            maxHeight: box,
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, _) => Stack(alignment: Alignment.center, children: [for (var i = 0; i < widget.ringCount; i++) _ring(i / widget.ringCount)]),
            ),
          ),
          // Central button.
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: SinemaxColors.blue.withValues(alpha: 0.92),
              boxShadow: [BoxShadow(color: SinemaxColors.blue.withValues(alpha: 0.45), blurRadius: 18, spreadRadius: 1)],
            ),
            child: Center(
              child: FaIcon(widget.icon, size: widget.size * 0.42, color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (widget.onTap == null) return button;
    return GestureDetector(onTap: widget.onTap, behavior: HitTestBehavior.opaque, child: button);
  }

  Widget _ring(double phase) {
    final t = (_ctrl.value + phase) % 1.0;
    final scale = 1.0 + (widget.maxRingScale - 1.0) * t;
    final opacity = (1.0 - t) * 0.45;
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Container(
        width: widget.size * scale,
        height: widget.size * scale,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: SinemaxColors.blue.withValues(alpha: 0.12),
          border: Border.all(color: SinemaxColors.blue.withValues(alpha: 0.55), width: widget.ringWidth),
        ),
      ),
    );
  }
}

/// Idle player slot: the blurred poster behind a [RipplePlayButton]. Tapping
/// anywhere starts playback. Shown instead of autoplaying when the user
/// arrives from a browse surface (home, discover, search, related).
class PlayerIdleView extends StatelessWidget {
  final String? posterUrl;
  final VoidCallback onPlay;
  const PlayerIdleView({super.key, this.posterUrl, required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPlay,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (posterUrl != null && posterUrl!.isNotEmpty)
            CachedNetworkImage(
              imageUrl: posterUrl!,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(color: SinemaxColors.bg2),
              errorBuilder: (_, _, _) => Container(color: SinemaxColors.bg2),
            )
          else
            Container(color: SinemaxColors.bg2),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x55000000), Color(0xAA000000)]),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RipplePlayButton(size: 88, maxRingScale: 2.4, ringCount: 4, ringWidth: 3.0, onTap: onPlay),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(99)),
                  child: Text(
                    'Play now',
                    style: SinemaxTextStyles.body(15, weight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
