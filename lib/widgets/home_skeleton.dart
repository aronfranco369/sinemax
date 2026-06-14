import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../theme/app_theme.dart';
import 'section_header.dart';

const _kEffect = ShimmerEffect(
  baseColor: Color(0xFF0E1D33),
  highlightColor: Color(0xFF1A2D4A),
  duration: Duration(milliseconds: 1200),
);

/// Skeleton for the trending carousel while [trendingMediaProvider] loads.
/// Matches the real carousel's height and internal layout exactly.
class HomeTrendingSkeleton extends StatelessWidget {
  const HomeTrendingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: _kEffect,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card — matches _TrendingCard dimensions
            Container(
              height: 210,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: SinemaxColors.panel,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Star badge row
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.solidStar, size: 13, color: SinemaxColors.gold),
                        const SizedBox(width: 5),
                        Text(
                          'MOST WATCHED THIS WEEK',
                          style: SinemaxTextStyles.body(10, weight: FontWeight.w700, color: SinemaxColors.gold),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Big title
                    Text(
                      'MOVIE TITLE LOADING',
                      style: SinemaxTextStyles.display(28, weight: FontWeight.w800),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 5),
                    // Meta line
                    Text(
                      '2024 · Genre · DJ Name',
                      style: SinemaxTextStyles.body(12, color: SinemaxColors.muted),
                    ),
                    const SizedBox(height: 14),
                    // Action buttons
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                          decoration: BoxDecoration(
                            color: SinemaxColors.panel2,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const FaIcon(FontAwesomeIcons.play, size: 17),
                              const SizedBox(width: 5),
                              Text('Watch', style: SinemaxTextStyles.body(13, weight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: SinemaxColors.panel2,
                          ),
                          child: const FaIcon(FontAwesomeIcons.bookmark, size: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Dots indicator row
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20),
              child: Row(
                children: List.generate(3, (i) {
                  return Container(
                    margin: const EdgeInsets.only(right: 5),
                    width: i == 0 ? 18 : 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: i == 0 ? SinemaxColors.blue : SinemaxColors.muted2,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for the category rows section while [homeRowsProvider] loads.
/// Shows 3 fake rows so the screen feels populated immediately.
class HomeRowsSkeleton extends StatelessWidget {
  const HomeRowsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: _kEffect,
      child: const Column(
        children: [
          _RowSkeleton(title: 'Tanzania Films XXXXXX'),
          _RowSkeleton(title: 'Kenya Collection XX'),
          _RowSkeleton(title: 'Top Series XXXXXXXX'),
        ],
      ),
    );
  }
}

// ─────────────────────────── Private helpers ──────────────────────────────────

class _RowSkeleton extends StatelessWidget {
  final String title;
  const _RowSkeleton({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title, onSeeAll: () {}),
        SizedBox(
          height: 202,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, _) => const _PosterCard(),
          ),
        ),
      ],
    );
  }
}

class _PosterCard extends StatelessWidget {
  const _PosterCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area — matches PosterCard cardHeight (height - 50)
          Container(
            width: 120,
            height: 150,
            decoration: BoxDecoration(
              color: SinemaxColors.panel2,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 11,
            width: 110,
            decoration: BoxDecoration(
              color: SinemaxColors.panel2,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 3),
          Container(
            height: 10,
            width: 70,
            decoration: BoxDecoration(
              color: SinemaxColors.panel2,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
