import 'package:flutter/material.dart';
import '../models/content.dart';
import '../data/local_data.dart';
import '../theme/app_theme.dart';

// Dimensions of the DJ notch cut into the top-right corner of the card.
const double _notchW = 64.0;
const double _notchH = 22.0;
const double _cardRadius = 10.0;

class PosterCard extends StatelessWidget {
  final Content content;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const PosterCard({super.key, required this.content, this.onTap, this.width = 120, this.height = 200});

  @override
  Widget build(BuildContext context) {
    final p = content.poster;
    final dj = djById(content.djId);
    final cardHeight = height - 50;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card image area — clipped with a notch on the top-right
            SizedBox(
              width: width,
              height: cardHeight,
              child: Stack(
                children: [
                  // Card body (gradient bg + glyph + type badge), clipped to notch shape
                  ClipPath(
                    clipper: const _NotchClipper(),
                    child: SizedBox.expand(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Gradient background
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [p.from, p.to]),
                            ),
                          ),

                          // Centered glyph watermark
                          Center(
                            child: Text(p.glyph, style: TextStyle(fontSize: 58, color: p.accent.withAlpha(55), height: 1)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // DJ badge — sits in the notch cut-out at top-right
                  if (dj != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      width: _notchW,
                      height: _notchH,
                      child: Container(
                        decoration: BoxDecoration(
                          color: p.accent.withAlpha(55),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(_cardRadius),
                            bottomLeft: Radius.circular(6),
                          ),
                          border: Border.all(color: p.accent.withAlpha(140), width: 0.8),
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          dj.name,
                          style: SinemaxTextStyles.body(8.5, weight: FontWeight.w600, color: p.accent),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Title
            Text(
              content.title,
              style: SinemaxTextStyles.display(12, weight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 3),

            // Meta row
            Row(
              children: [
                Text('${content.year}', style: SinemaxTextStyles.body(10, color: SinemaxColors.muted2)),
                Text(' · ', style: SinemaxTextStyles.body(10, color: SinemaxColors.muted2)),
                Flexible(
                  child: Text(
                    content.countryLabel,
                    style: SinemaxTextStyles.body(10, color: SinemaxColors.muted2),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.star_rounded, size: 10, color: SinemaxColors.gold),
                const SizedBox(width: 2),
                Text(content.rating.toStringAsFixed(1), style: SinemaxTextStyles.body(10, color: SinemaxColors.muted2)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Clips a rectangle with rounded corners everywhere except the top-right,
// which is replaced by a rectangular notch (_notchW × _notchH) to host the DJ badge.
class _NotchClipper extends CustomClipper<Path> {
  const _NotchClipper();

  @override
  Path getClip(Size size) {
    const r = _cardRadius;
    final w = size.width;
    final h = size.height;

    return Path()
      // Start just after top-left arc
      ..moveTo(r, 0)
      // Top edge → notch start
      ..lineTo(w - _notchW, 0)
      // Notch: step down, then right to the card edge
      ..lineTo(w - _notchW, _notchH)
      ..lineTo(w, _notchH)
      // Right edge down to bottom-right arc start
      ..lineTo(w, h - r)
      ..quadraticBezierTo(w, h, w - r, h)
      // Bottom edge to bottom-left arc start
      ..lineTo(r, h)
      ..quadraticBezierTo(0, h, 0, h - r)
      // Left edge up to top-left arc start
      ..lineTo(0, r)
      ..quadraticBezierTo(0, 0, r, 0)
      ..close();
  }

  @override
  bool shouldReclip(_NotchClipper old) => false;
}
