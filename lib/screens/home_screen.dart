import 'dart:async';

import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers.dart';
import '../models/discover_filter.dart';
import '../models/media.dart';
import '../theme/app_theme.dart';
import '../widgets/home_skeleton.dart';
import '../widgets/poster_card.dart';
import '../widgets/section_header.dart';
import '../widgets/sinemax_search_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeRowsAsync = ref.watch(homeRowsProvider);

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

          // Trending carousel
          const SliverToBoxAdapter(child: _TrendingCarousel()),

          // Category rows
          ...homeRowsAsync.when(
            loading: () => [const SliverToBoxAdapter(child: HomeRowsSkeleton())],
            error: (e, _) => [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text('Failed to load content', style: SinemaxTextStyles.body(15, color: SinemaxColors.muted)),
                  ),
                ),
              ),
            ],
            data: (rows) => rows.map((row) => SliverToBoxAdapter(child: _HomeRow(row: row))).toList(),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _HomeRow extends ConsumerWidget {
  final HomeRow row;
  const _HomeRow({required this.row});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: row.title,
          onSeeAll: () {
            final (country, type) = _parseRowId(row.id);
            ref.read(discoverFiltersProvider.notifier).preset(DiscoverFilter(country: country, type: type));
            context.go('/discover');
          },
        ),
        SizedBox(
          height: 202,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: row.items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) => PosterCard(media: row.items[i], onTap: () => context.push('/detail/${row.items[i].id}')),
          ),
        ),
      ],
    );
  }
}

(String, String) _parseRowId(String id) {
  final parts = id.split('-');
  final type = parts.last == 'series' ? 'Series' : 'Movie';
  final country = parts.sublist(0, parts.length - 1).map((p) => p.isEmpty ? p : '${p[0].toUpperCase()}${p.substring(1)}').join(' ');
  return (country, type);
}

// ─── Trending Carousel ────────────────────────────────────────────────────────

class _TrendingCarousel extends ConsumerStatefulWidget {
  const _TrendingCarousel();

  @override
  ConsumerState<_TrendingCarousel> createState() => _TrendingCarouselState();
}

class _TrendingCarouselState extends ConsumerState<_TrendingCarousel> {
  late final PageController _controller;
  int _page = 0;
  List<Media> _items = const [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _timer = Timer.periodic(const Duration(milliseconds: 2000), (_) {
      if (!mounted || _items.isEmpty) return;
      final next = (_page + 1) % _items.length;
      _controller.animateToPage(next, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(trendingMediaProvider)
        .when(
          loading: () => const HomeTrendingSkeleton(),
          error: (_, _) => const SizedBox.shrink(),
          data: (items) {
            _items = items;
            if (items.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 210,
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: items.length,
                      onPageChanged: (i) => setState(() => _page = i),
                      itemBuilder: (_, i) => _TrendingCard(media: items[i]),
                    ),
                  ),
                  if (items.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 20),
                      child: Row(
                        children: List.generate(items.length, (i) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 5),
                            width: i == _page ? 18 : 5,
                            height: 5,
                            decoration: BoxDecoration(color: i == _page ? SinemaxColors.blue : SinemaxColors.muted2, borderRadius: BorderRadius.circular(3)),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            );
          },
        );
  }
}

class _TrendingCard extends ConsumerWidget {
  final Media media;
  const _TrendingCard({required this.media});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaved = ref.watch(savedProvider).contains(media.id);

    return GestureDetector(
      onTap: () => context.push('/detail/${media.id}'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: SinemaxColors.panel),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Poster as background
            if (media.posterUrl != null)
              CachedNetworkImage(
                imageUrl: media.posterUrl!,
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
                placeholder: (_, _) => Container(color: SinemaxColors.panel2),
                errorBuilder: (_, _, _) => Container(color: SinemaxColors.panel2),
              )
            else
              Container(color: SinemaxColors.panel2),

            // Left gradient so text stays readable
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, stops: [0.0, 0.55, 1.0], colors: [Color(0xF2050D1A), Color(0xD0050D1A), Colors.transparent]),
              ),
            ),

            // Bottom gradient
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: [0.0, 0.45], colors: [Color(0x99000000), Colors.transparent]),
              ),
            ),

            // Content overlay
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 13, color: SinemaxColors.gold),
                      const SizedBox(width: 5),
                      Text(
                        'MOST WATCHED THIS WEEK',
                        style: SinemaxTextStyles.body(10, weight: FontWeight.w700, color: SinemaxColors.gold),
                      ),
                    ],
                  ),
                  if (media.viewCount > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.remove_red_eye_outlined, size: 12, color: SinemaxColors.muted),
                        const SizedBox(width: 4),
                        Text(
                          _fmtCount(media.viewCount),
                          style: SinemaxTextStyles.body(10, weight: FontWeight.w600, color: SinemaxColors.muted),
                        ),
                      ],
                    ),
                  ],
                  const Spacer(),
                  // Title
                  Text(
                    media.title.toUpperCase(),
                    style: SinemaxTextStyles.display(28, weight: FontWeight.w800),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  // Meta
                  Text(
                    [if (media.year != null) '${media.year}', ...media.genres.take(2), if (media.djDisplay.isNotEmpty) media.djDisplay].join(' · '),
                    style: SinemaxTextStyles.body(12, color: SinemaxColors.muted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),
                  // Action buttons
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.push('/detail/${media.id}'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                          decoration: BoxDecoration(color: SinemaxColors.blue, borderRadius: BorderRadius.circular(22)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.play_arrow_rounded, size: 17, color: Colors.white),
                              const SizedBox(width: 5),
                              Text(
                                'Watch',
                                style: SinemaxTextStyles.body(13, weight: FontWeight.w700, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => ref.read(savedProvider.notifier).toggle(media.id),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: isSaved ? SinemaxColors.teal : SinemaxColors.line2, width: 1.5),
                            color: Colors.black26,
                          ),
                          child: Icon(isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded, size: 18, color: isSaved ? SinemaxColors.teal : Colors.white),
                        ),
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

  String _fmtCount(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(0)}K' : '$n';
}
