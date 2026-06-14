import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/media.dart';
import '../theme/app_theme.dart';

const double _notchW = 64.0;
const double _notchH = 22.0;
const double _cardRadius = 10.0;

class PosterCard extends StatelessWidget {
  final Media media;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const PosterCard({super.key, required this.media, this.onTap, this.width = 120, this.height = 200});

  @override
  Widget build(BuildContext context) {
    final cardHeight = height - 50;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card image area — clipped with a notch on the top-right for DJ badge
            SizedBox(
              width: width,
              height: cardHeight,
              child: Stack(
                children: [
                  // Poster image (clipped to notch shape)
                  ClipPath(
                    clipper: const _NotchClipper(),
                    child: SizedBox.expand(
                      child: media.posterUrl != null
                          ? CachedNetworkImage(
                              imageUrl: media.posterUrl!,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(color: SinemaxColors.panel2),
                              errorWidget: (_, __, ___) => _PosterFallback(isSeries: media.isSeries),
                            )
                          : _PosterFallback(isSeries: media.isSeries),
                    ),
                  ),

                  // DJ badge — notch slot at top-right
                  if (media.djDisplay.isNotEmpty)
                    Positioned(
                      top: 0,
                      right: 0,
                      width: _notchW,
                      height: _notchH,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(_cardRadius), bottomLeft: Radius.circular(6)),
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          media.djDisplay,
                          // style: SinemaxTextStyles.display(12, weight: FontWeight.w300),
                          style: SinemaxTextStyles.body(7.5, weight: FontWeight.w900),
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
              media.title,
              style: SinemaxTextStyles.display(12, weight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 3),

            // Meta row
            Row(
              children: [
                if (media.year != null) ...[
                  Text('${media.year}', style: SinemaxTextStyles.display(12, weight: FontWeight.w300)),
                  if (media.countryDisplay.isNotEmpty) Text(' · ', style: SinemaxTextStyles.display(12, weight: FontWeight.w700)),
                ],
                if (media.countryDisplay.isNotEmpty)
                  Flexible(
                    child: Text(
                      media.countryDisplay,
                      style: SinemaxTextStyles.display(12, weight: FontWeight.w300),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PosterFallback extends StatelessWidget {
  final bool isSeries;
  const _PosterFallback({required this.isSeries});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SinemaxColors.panel2,
      child: Center(child: FaIcon(isSeries ? FontAwesomeIcons.tv : FontAwesomeIcons.film, size: 32, color: SinemaxColors.muted2)),
    );
  }
}

// Clips a rectangle with rounded corners everywhere except the top-right,
// which is replaced by a rectangular notch (_notchW × _notchH) for the DJ badge.
class _NotchClipper extends CustomClipper<Path> {
  const _NotchClipper();

  @override
  Path getClip(Size size) {
    const r = _cardRadius;
    final w = size.width;
    final h = size.height;

    return Path()
      ..moveTo(r, 0)
      ..lineTo(w - _notchW, 0)
      ..lineTo(w - _notchW, _notchH)
      ..lineTo(w, _notchH)
      ..lineTo(w, h - r)
      ..quadraticBezierTo(w, h, w - r, h)
      ..lineTo(r, h)
      ..quadraticBezierTo(0, h, 0, h - r)
      ..lineTo(0, r)
      ..quadraticBezierTo(0, 0, r, 0)
      ..close();
  }

  @override
  bool shouldReclip(_NotchClipper old) => false;
}
