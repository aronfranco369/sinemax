import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/providers.dart';
import '../data/local_data.dart';
import '../models/content.dart';
import '../theme/app_theme.dart';
import '../widgets/poster_card.dart';
import '../widgets/section_header.dart';
import '../widgets/sinemax_icon.dart';
import '../widgets/sinemax_search_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featured = ref.watch(featuredProvider);
    final rows = ref.watch(homeRowsProvider);

    return Scaffold(
      backgroundColor: SinemaxColors.bg,
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            backgroundColor: SinemaxColors.bg,
            pinned: true,
            expandedHeight: 0,
            toolbarHeight: 62,
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // SX badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(color: SinemaxColors.blue, borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      'SX',
                      style: SinemaxTextStyles.display(15, weight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(child: SinemaxSearchBar()),
                ],
              ),
            ),
          ),

          // Featured hero
          if (featured != null) SliverToBoxAdapter(child: _FeaturedHero(content: featured)),

          // Home rows
          ...rows.map((row) => SliverToBoxAdapter(child: _HomeRow(row: row))),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _FeaturedHero extends StatelessWidget {
  final Content content;
  const _FeaturedHero({required this.content});

  @override
  Widget build(BuildContext context) {
    final p = content.poster;
    final dj = djById(content.djId);

    return GestureDetector(
      onTap: () => context.push('/detail/${content.id}'),
      child: Container(
        height: 280,
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [p.from, p.to]),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Big glyph watermark
            Positioned(
              right: -10,
              top: -10,
              child: Text(p.glyph, style: TextStyle(fontSize: 160, color: p.accent.withAlpha(25), height: 1)),
            ),

            // Accent bar at top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  color: p.accent,
                ),
              ),
            ),

            // Content
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // "Most watched" badge
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded, size: 12, color: p.accent),
                      const SizedBox(width: 5),
                      Text(
                        'MOST WATCHED THIS WEEK',
                        style: SinemaxTextStyles.body(10, weight: FontWeight.w700, color: p.accent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Title
                  Text(content.title, style: SinemaxTextStyles.display(34, weight: FontWeight.w900)),
                  const SizedBox(height: 4),

                  // Year · genre · DJ name
                  RichText(
                    text: TextSpan(
                      style: SinemaxTextStyles.body(12, color: SinemaxColors.muted),
                      children: [
                        TextSpan(text: '${content.year} · ${content.genre}'),
                        if (dj != null) ...[
                          const TextSpan(text: ' · '),
                          TextSpan(
                            text: dj.name,
                            style: SinemaxTextStyles.body(12, weight: FontWeight.w600, color: p.accent),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Buttons
                  Row(
                    children: [
                      // Watch button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                        decoration: BoxDecoration(color: SinemaxColors.blue, borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SinemaxIcon('play', size: 13, color: Colors.white),
                            const SizedBox(width: 6),
                            Text(
                              'Watch',
                              style: SinemaxTextStyles.body(14, weight: FontWeight.w600, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // + button
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          shape: BoxShape.circle,
                          border: Border.all(color: SinemaxColors.line2, width: 1),
                        ),
                        child: const Center(child: SinemaxIcon('plus', size: 16)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeRow extends ConsumerWidget {
  final dynamic row;
  const _HomeRow({required this.row});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = (row.itemIds as List<String>).map((id) => contentById(id)).whereType<Content>().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: row.title, onSeeAll: () => context.go('/discover')),
        SizedBox(
          height: 202,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, i) => PosterCard(content: items[i], onTap: () => context.push('/detail/${items[i].id}')),
          ),
        ),
      ],
    );
  }
}
