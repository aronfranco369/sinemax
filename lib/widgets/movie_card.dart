import 'package:flutter/material.dart';
import '../models/content.dart';
import '../theme/app_theme.dart';

/// Horizontal list-style card (used in library recent / downloads).
class MovieCard extends StatelessWidget {
  final Content content;
  final String? meta;
  final double? progress;
  final Widget? trailing;
  final VoidCallback? onTap;

  const MovieCard({
    super.key,
    required this.content,
    this.meta,
    this.progress,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = content.poster;

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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [p.from, p.to],
                        ),
                      ),
                    ),
                    Center(
                      child: Text(p.glyph, style: TextStyle(fontSize: 28, color: p.accent.withAlpha(180))),
                    ),
                    Positioned(
                      top: 0, left: 0, right: 0,
                      child: Container(height: 2, color: p.accent),
                    ),
                  ],
                ),
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
                      content.title,
                      style: SinemaxTextStyles.display(14, weight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      content.genre,
                      style: SinemaxTextStyles.body(12, color: SinemaxColors.muted),
                      maxLines: 1,
                    ),
                    if (meta != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        meta!,
                        style: SinemaxTextStyles.body(11, color: SinemaxColors.muted2),
                      ),
                    ],
                    if (progress != null && progress! > 0 && progress! < 1) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: SinemaxColors.line2,
                          color: p.accent,
                          minHeight: 3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            if (trailing != null) ...[
              trailing!,
              const SizedBox(width: 12),
            ],
          ],
        ),
      ),
    );
  }
}
