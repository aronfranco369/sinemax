import 'dart:math' show pi;
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../data/local_data.dart';
import '../data/providers.dart';
import '../models/content.dart';
import '../models/episode.dart';
import '../theme/app_theme.dart';
import '../widgets/poster_card.dart';
import '../widgets/sinemax_icon.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final String contentId;
  const DetailScreen({super.key, required this.contentId});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  VideoPlayerController? _vpc;
  ChewieController? _cc;
  bool _playerReady = false;
  bool _episodesExpanded = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    _vpc = VideoPlayerController.networkUrl(Uri.parse(sampleVideoUrl));
    await _vpc!.initialize();
    _cc = ChewieController(
      videoPlayerController: _vpc!,
      autoPlay: false,
      looping: false,
      aspectRatio: 16 / 9,
      placeholder: _PosterPlaceholder(contentId: widget.contentId),
      materialProgressColors: ChewieProgressColors(
        playedColor: SinemaxColors.blue,
        handleColor: SinemaxColors.blue,
        backgroundColor: SinemaxColors.line2,
        bufferedColor: SinemaxColors.line2,
      ),
    );
    if (mounted) setState(() => _playerReady = true);
  }

  @override
  void dispose() {
    _cc?.dispose();
    _vpc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = contentById(widget.contentId);
    if (content == null) {
      return Scaffold(
        backgroundColor: SinemaxColors.bg,
        body: Center(child: Text('Not found', style: SinemaxTextStyles.body(16, color: SinemaxColors.muted))),
      );
    }

    final saved = ref.watch(savedProvider).contains(content.id);
    final topPad = MediaQuery.of(context).padding.top;
    final hasEpisodes = content.isSeries && content.episodesList.isNotEmpty;

    return Scaffold(
      backgroundColor: SinemaxColors.bg,
      body: Column(
        children: [
          // ── FIXED zone: Player ─────────────────────────────────────────────
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: _playerReady && _cc != null
                    ? Chewie(controller: _cc!)
                    : _PosterPlaceholder(contentId: content.id),
              ),
              Positioned(
                top: topPad + 8, left: 12,
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const SinemaxIcon('arrowL', size: 20),
                  ),
                ),
              ),
            ],
          ),

          // ── FIXED zone: Action buttons ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Expanded(child: _ActionBtn(icon: 'download', label: 'Download')),
                const SizedBox(width: 8),
                Expanded(
                  child: _ActionBtn(
                    icon: saved ? 'bookmark-filled' : 'bookmark',
                    label: 'Save',
                    active: saved,
                    onTap: () => ref.read(savedProvider.notifier).toggle(content.id),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: _ActionBtn(icon: 'send', label: 'Share')),
              ],
            ),
          ),

          // ── SCROLLABLE zone ────────────────────────────────────────────────
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: CustomScrollView(
              slivers: [
                // Info: title, meta, description
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(content.title, style: SinemaxTextStyles.display(28, weight: FontWeight.w900)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8, runSpacing: 6,
                          children: [
                            _Chip(label: content.djId),
                            _Chip(label: '${content.year}'),
                            _Chip(label: '${content.countryFlag} ${content.countryLabel}'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(content.description, style: SinemaxTextStyles.body(14, color: SinemaxColors.muted)),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // Episodes header — SliverAppBar pins it below the fixed zone
                if (hasEpisodes)
                  SliverAppBar(
                    pinned: true,
                    automaticallyImplyLeading: false,
                    toolbarHeight: 46,
                    backgroundColor: SinemaxColors.bg,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    surfaceTintColor: Colors.transparent,
                    titleSpacing: 0,
                    actions: const [],
                    title: _EpisodesHeader(
                      count: '${content.totalEpisodes ?? content.episodesList.length} episodes',
                      expanded: _episodesExpanded,
                      onToggle: () => setState(() => _episodesExpanded = !_episodesExpanded),
                    ),
                  ),

                // Collapsed: horizontal card scroll + Related
                if (hasEpisodes && !_episodesExpanded) ...[
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 148,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: content.episodesList.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (context, i) =>
                            _EpisodeCard(ep: content.episodesList[i], content: content),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(child: _RelatedRow(content: content)),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],

                // Expanded: vertical episode list, Related hidden
                if (hasEpisodes && _episodesExpanded) ...[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _EpisodeRow(ep: content.episodesList[i], content: content),
                      childCount: content.episodesList.length,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],

                // No episodes (movie): always show Related
                if (!hasEpisodes) ...[
                  SliverToBoxAdapter(child: _RelatedRow(content: content)),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }
}

class _EpisodesHeader extends StatelessWidget {
  final String count;
  final bool expanded;
  final VoidCallback onToggle;

  const _EpisodesHeader({required this.count, required this.expanded, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text('EPISODES', style: SinemaxTextStyles.display(16, weight: FontWeight.w700)),
          const SizedBox(width: 8),
          Text(count, style: SinemaxTextStyles.body(13, color: SinemaxColors.muted)),
          const Spacer(),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: SinemaxColors.panel2,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: SinemaxColors.line, width: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    expanded ? 'Collapse' : 'Expand',
                    style: SinemaxTextStyles.body(12, color: SinemaxColors.muted),
                  ),
                  const SizedBox(width: 4),
                  Transform.rotate(
                    angle: expanded ? pi : 0,
                    child: const SinemaxIcon('chevD', size: 13, color: SinemaxColors.muted),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _ActionBtn extends StatelessWidget {
  final String icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _ActionBtn({required this.icon, required this.label, this.active = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = active ? SinemaxColors.blue : SinemaxColors.muted;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: SinemaxColors.panel,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? SinemaxColors.blue.withAlpha(90) : SinemaxColors.line,
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SinemaxIcon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(label, style: SinemaxTextStyles.body(12, weight: FontWeight.w500, color: color)),
          ],
        ),
      ),
    );
  }
}

// Horizontal card (collapsed view)
class _EpisodeCard extends StatelessWidget {
  final Episode ep;
  final Content content;
  const _EpisodeCard({required this.ep, required this.content});

  @override
  Widget build(BuildContext context) {
    final p = content.poster;
    return SizedBox(
      width: 118,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 118, height: 88,
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
                  Positioned(
                    top: 6, left: 8,
                    child: Text(
                      'EP ${ep.ep}',
                      style: SinemaxTextStyles.display(11, weight: FontWeight.w700, color: p.accent),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                      child: const SinemaxIcon('play', size: 16),
                    ),
                  ),
                  if (ep.progress > 0 && ep.progress < 1)
                    Positioned(
                      bottom: 0, left: 0, right: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                        child: LinearProgressIndicator(
                          value: ep.progress,
                          backgroundColor: SinemaxColors.line2,
                          color: p.accent,
                          minHeight: 3,
                        ),
                      ),
                    ),
                  if (ep.progress >= 1.0)
                    Positioned(
                      bottom: 6, right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: SinemaxColors.teal.withAlpha(40),
                          shape: BoxShape.circle,
                        ),
                        child: const SinemaxIcon('check', size: 10, color: SinemaxColors.teal),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(ep.title, style: SinemaxTextStyles.body(11, weight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(ep.duration, style: SinemaxTextStyles.body(10, color: SinemaxColors.muted2)),
        ],
      ),
    );
  }
}

// Vertical row (expanded view)
class _EpisodeRow extends StatelessWidget {
  final Episode ep;
  final Content content;
  const _EpisodeRow({required this.ep, required this.content});

  @override
  Widget build(BuildContext context) {
    final p = content.poster;

    final String statusText;
    if (ep.progress >= 1.0) {
      statusText = '${ep.duration} · Completed';
    } else if (ep.progress > 0) {
      statusText = '${ep.duration} · ${(ep.progress * 100).round()}% watched';
    } else {
      statusText = ep.duration;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: SinemaxColors.panel,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: SinemaxColors.line, width: 0.5),
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: 68, height: 52,
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
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                      child: const SinemaxIcon('play', size: 14),
                    ),
                  ),
                  if (ep.progress > 0 && ep.progress < 1)
                    Positioned(
                      bottom: 0, left: 0, right: 0,
                      child: LinearProgressIndicator(
                        value: ep.progress,
                        backgroundColor: SinemaxColors.line2,
                        color: p.accent,
                        minHeight: 3,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Episode info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      ep.ep.toString().padLeft(2, '0'),
                      style: SinemaxTextStyles.display(13, weight: FontWeight.w700, color: p.accent),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        ep.title,
                        style: SinemaxTextStyles.body(13, weight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(statusText, style: SinemaxTextStyles.body(11, color: SinemaxColors.muted2)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (ep.progress >= 1.0)
            const SinemaxIcon('check', size: 16, color: SinemaxColors.teal)
          else
            const SinemaxIcon('download', size: 16, color: SinemaxColors.muted2),
        ],
      ),
    );
  }
}

class _PosterPlaceholder extends StatelessWidget {
  final String contentId;
  const _PosterPlaceholder({required this.contentId});

  @override
  Widget build(BuildContext context) {
    final c = contentById(contentId);
    final p = c?.poster;
    return Container(
      color: p != null ? p.to : SinemaxColors.bg2,
      child: Center(
        child: p != null
            ? Text(p.glyph, style: TextStyle(fontSize: 64, color: p.accent.withAlpha(120)))
            : const SinemaxIcon('play', size: 48, color: SinemaxColors.muted2),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: SinemaxColors.panel2,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: SinemaxColors.line, width: 0.5),
      ),
      child: Text(label, style: SinemaxTextStyles.body(12, color: SinemaxColors.muted)),
    );
  }
}

class _RelatedRow extends ConsumerWidget {
  final Content content;
  const _RelatedRow({required this.content});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final related = contentWhere(
      (c) => c.id != content.id &&
          (c.countryLabel == content.countryLabel ||
              c.genre.split(' · ').first == content.genre.split(' · ').first),
    ).take(6).toList();

    if (related.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: Text('RELATED', style: SinemaxTextStyles.display(18, weight: FontWeight.w700)),
        ),
        SizedBox(
          height: 202,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: related.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, i) => PosterCard(
              content: related[i],
              onTap: () => context.pushReplacement('/detail/${related[i].id}'),
            ),
          ),
        ),
      ],
    );
  }
}
