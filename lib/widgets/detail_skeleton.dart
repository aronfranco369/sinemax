import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/app_theme.dart';
import 'action_btn.dart';
import 'player_loading_view.dart';

const _kEffect = ShimmerEffect(
  baseColor: Color(0xFF0E1D33),
  highlightColor: Color(0xFF1A2D4A),
  duration: Duration(milliseconds: 1200),
);

/// Full-page skeleton while [mediaByIdProvider] is loading.
/// The player zone reuses [PlayerLoadingView]; action buttons are shown as-is
/// since they are hardcoded UI, not data-dependent.
class DetailSkeleton extends StatelessWidget {
  const DetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: SinemaxColors.bg,
      body: Column(
        children: [
          // ── Player — has its own managed loading state ────────────────────
          Stack(
            children: [
              const AspectRatio(
                aspectRatio: 16 / 9,
                child: PlayerLoadingView(),
              ),
              Positioned(
                top: topPad + 8,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const FaIcon(FontAwesomeIcons.arrowLeft, size: 20),
                ),
              ),
            ],
          ),

          // ── Now-playing label ─────────────────────────────────────────────
          Skeletonizer(
            enabled: true,
            effect: _kEffect,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Loading title  ·  Episode name',
                  style: SinemaxTextStyles.body(13, weight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),

          // ── Action buttons — hardcoded, never skeletonized ────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(
              children: [
                Expanded(child: ActionBtn(icon: FontAwesomeIcons.download, label: 'Download')),
                const SizedBox(width: 8),
                Expanded(child: ActionBtn(icon: FontAwesomeIcons.bookmark, label: 'Save')),
                const SizedBox(width: 8),
                Expanded(child: ActionBtn(icon: FontAwesomeIcons.shareNodes, label: 'Share')),
              ],
            ),
          ),

          // ── Scrollable content ────────────────────────────────────────────
          Expanded(
            child: Skeletonizer(
              enabled: true,
              effect: _kEffect,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                  children: [
                    Text(
                      'Movie Title Placeholder',
                      style: SinemaxTextStyles.display(28, weight: FontWeight.w900),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: const [
                        _Chip('DJ XXXXX'),
                        _Chip('2024'),
                        _Chip('Tanzania'),
                        _Chip('Action · Drama'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Placeholder description for this content. A few more words to fill the space.',
                      style: SinemaxTextStyles.body(14, color: SinemaxColors.muted),
                    ),
                    const SizedBox(height: 20),
                    const _EpHeader(count: '4 episodes'),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 96,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (_, _) => const _EpCard(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('RELATED', style: SinemaxTextStyles.display(18, weight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.62,
                      ),
                      itemCount: 6,
                      itemBuilder: (_, _) => const _PosterCard(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Episodes-section skeleton. Used inline (in a [SliverToBoxAdapter]) while
/// [mediaFilesProvider] is still loading but the main [Media] is ready.
class EpisodesSkeleton extends StatelessWidget {
  const EpisodesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: _kEffect,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _EpHeader(count: '–– episodes'),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 96,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (_, _) => const _EpCard(),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

/// Related-grid skeleton. Dropped in [_RelatedGrid] while
/// [relatedMediaProvider] is loading.
class RelatedSkeleton extends StatelessWidget {
  const RelatedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: _kEffect,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Text('RELATED', style: SinemaxTextStyles.display(18, weight: FontWeight.w700)),
          ),
          GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.62,
            ),
            itemCount: 6,
            itemBuilder: (_, _) => const _PosterCard(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Private shape widgets ────────────────────────────

class _Chip extends StatelessWidget {
  final String text;
  const _Chip(this.text);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: SinemaxColors.panel2,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: SinemaxColors.line, width: 0.5),
        ),
        child: Text(text, style: SinemaxTextStyles.body(12, color: SinemaxColors.muted)),
      );
}

class _EpHeader extends StatelessWidget {
  final String count;
  const _EpHeader({required this.count});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text('EPISODES', style: SinemaxTextStyles.display(16, weight: FontWeight.w700)),
          const SizedBox(width: 8),
          Text(count, style: SinemaxTextStyles.body(13, color: SinemaxColors.muted)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: SinemaxColors.panel2,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: SinemaxColors.line, width: 0.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Expand', style: SinemaxTextStyles.body(12, color: SinemaxColors.muted)),
                const SizedBox(width: 4),
                const FaIcon(FontAwesomeIcons.chevronDown, size: 13, color: SinemaxColors.muted),
              ],
            ),
          ),
        ],
      );
}

class _EpCard extends StatelessWidget {
  const _EpCard();

  @override
  Widget build(BuildContext context) => Container(
        width: 118,
        height: 96,
        decoration: BoxDecoration(
          color: SinemaxColors.panel2,
          borderRadius: BorderRadius.circular(8),
        ),
      );
}

class _PosterCard extends StatelessWidget {
  const _PosterCard();

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: SinemaxColors.panel2,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 11,
            decoration: BoxDecoration(
              color: SinemaxColors.panel2,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 3),
          FractionallySizedBox(
            widthFactor: 0.6,
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: SinemaxColors.panel2,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      );
}
