import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/media.dart';
import '../theme/app_theme.dart';

class MovieCard extends StatelessWidget {
  final Media media;
  final String? meta;
  final double? progress;
  final Widget? trailing;
  final VoidCallback? onTap;

  const MovieCard({super.key, required this.media, this.meta, this.progress, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: SinemaxColors.panel,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: SinemaxColors.line, width: 0.5),
        ),
        child: Row(
          children: [
            // Mini poster
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
              child: SizedBox(
                width: 72,
                height: 96,
                child: media.posterUrl != null
                    ? CachedNetworkImage(
                        imageUrl: media.posterUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: SinemaxColors.panel2),
                        errorWidget: (_, __, ___) => _MiniPosterFallback(isSeries: media.isSeries),
                      )
                    : _MiniPosterFallback(isSeries: media.isSeries),
              ),
            ),

            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      media.title,
                      style: SinemaxTextStyles.display(14, weight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    if (media.genreDisplay.isNotEmpty) Text(media.genreDisplay, style: SinemaxTextStyles.body(12, color: SinemaxColors.muted), maxLines: 1),
                    if (meta != null) ...[const SizedBox(height: 4), Text(meta!, style: SinemaxTextStyles.body(11, color: SinemaxColors.muted2))],
                    if (progress != null && progress! > 0 && progress! < 1) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(value: progress, backgroundColor: SinemaxColors.line2, color: SinemaxColors.blue, minHeight: 3),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            if (trailing != null) ...[trailing!, const SizedBox(width: 12)],
          ],
        ),
      ),
    );
  }
}

class _MiniPosterFallback extends StatelessWidget {
  final bool isSeries;
  const _MiniPosterFallback({required this.isSeries});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SinemaxColors.panel2,
      child: Center(child: FaIcon(isSeries ? FontAwesomeIcons.tv : FontAwesomeIcons.film, size: 24, color: SinemaxColors.muted2)),
    );
  }
}
