import 'dart:math' as math;

import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:disk_space_plus/disk_space_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers.dart';
import '../models/library_item.dart';
import '../models/media.dart';
import '../theme/app_theme.dart';
import '../widgets/download_controls.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Offline downloads, styled after a mobile "My Files" manager:
/// an underline tab bar (All / Movies / Series), then rich rows whose
/// thumbnail is filled with the title poster.
///
/// • **All**    — every movie and every episode as a standalone row (no grouping).
/// • **Movies** — movies only, one row each.
/// • **Series** — episodes grouped under an expandable series card.
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  int _section = 0; // 0 = Downloads, 1 = History, 2 = Saved

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SinemaxColors.bg,
      appBar: AppBar(
        backgroundColor: SinemaxColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Library', style: SinemaxTextStyles.display(22, weight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          _SectionSelector(index: _section, onChanged: (i) => setState(() => _section = i)),
          Expanded(
            child: IndexedStack(
              index: _section,
              children: const [
                _DownloadsView(),
                _HistoryView(),
                _SavedView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Top-level section selector: Downloads · History · Saved ───────────────────

class _SectionSelector extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const _SectionSelector({required this.index, required this.onChanged});

  static const _labels = ['Downloads', 'History', 'Saved'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 2, 16, 10),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: SinemaxColors.panel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SinemaxColors.line, width: 0.5),
      ),
      child: Row(
        children: [
          for (var i = 0; i < _labels.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: i == index ? SinemaxColors.blue : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Center(
                    child: Text(
                      _labels[i],
                      style: SinemaxTextStyles.body(
                        13.5,
                        weight: i == index ? FontWeight.w700 : FontWeight.w600,
                        color: i == index ? Colors.white : SinemaxColors.muted,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Downloads section (unchanged UI, just extracted) ──────────────────────────

class _DownloadsView extends ConsumerStatefulWidget {
  const _DownloadsView();

  @override
  ConsumerState<_DownloadsView> createState() => _DownloadsViewState();
}

class _DownloadsViewState extends ConsumerState<_DownloadsView> {
  int _tab = 0; // 0 = All, 1 = Movies, 2 = Series

  bool _isSeries(Media media, List<DownloadRecord> recs) => media.isSeries || recs.length > 1;

  @override
  Widget build(BuildContext context) {
    final dlAsync = ref.watch(downloadsContentProvider);

    return dlAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const _Empty(message: 'Couldn\'t load downloads'),
      data: (groups) {
        // ── Derive the three views from the grouped records ──
        final all = <(Media, DownloadRecord)>[];
        final movies = <(Media, DownloadRecord)>[];
        final series = <(Media, List<DownloadRecord>)>[];
        for (final (media, recs) in groups) {
          for (final r in recs) {
            all.add((media, r));
          }
          if (_isSeries(media, recs)) {
            series.add((media, recs));
          } else {
            movies.add((media, recs.first));
          }
        }
        all.sort((a, b) => b.$2.at.compareTo(a.$2.at)); // newest first

        return Column(
          children: [
            _Tabs(
              index: _tab,
              onChanged: (i) => setState(() => _tab = i),
              counts: [all.length, movies.length, series.length],
            ),
            Expanded(
              child: IndexedStack(
                index: _tab,
                children: [
                  _AllTab(groups: groups, items: all),
                  _MoviesTab(items: movies),
                  _SeriesTab(groups: series),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── History section ───────────────────────────────────────────────────────────

class _HistoryView extends ConsumerWidget {
  const _HistoryView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(recentContentProvider);
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const _Empty(icon: FontAwesomeIcons.clock, message: 'Couldn\'t load history'),
      data: (items) {
        if (items.isEmpty) {
          return const _Empty(
            icon: FontAwesomeIcons.clock,
            message: 'No watch history yet',
            subtitle: 'Movies and series you watch show up here, so you can pick up where you left off.',
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          children: [for (final (watched, media) in items) _HistoryCard(media: media, watched: watched)],
        );
      },
    );
  }
}

/// History row — mirrors the Downloads `_FileCard` layout: poster thumb,
/// title + meta, trailing action. Here the meta is when it was watched and the
/// trailing action is a play affordance.
class _HistoryCard extends StatelessWidget {
  final Media media;
  final WatchedItem watched;
  const _HistoryCard({required this.media, required this.watched});

  @override
  Widget build(BuildContext context) {
    final progress = watched.progress.clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: SinemaxColors.panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SinemaxColors.line, width: 0.5),
      ),
      child: GestureDetector(
        onTap: () => context.push('/detail/${media.id}?autoplay=1'),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Thumb(media: media, badge: media.isSeries ? 'SERIES' : 'MOVIE', completed: true),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      media.title,
                      style: SinemaxTextStyles.display(15.5, weight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      progress > 0.02 ? 'Watched ${(progress * 100).round()}% · ${fmtDate(watched.watchedAt)}' : 'Watched · ${fmtDate(watched.watchedAt)}',
                      style: SinemaxTextStyles.body(11.5, color: SinemaxColors.muted2),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (progress > 0.02) ...[
                      const SizedBox(height: 7),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: SinemaxColors.line2,
                          color: SinemaxColors.blue,
                          minHeight: 3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _PlayCircle(onTap: () => context.push('/detail/${media.id}?autoplay=1')),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Saved section ─────────────────────────────────────────────────────────────

class _SavedView extends ConsumerWidget {
  const _SavedView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(savedContentProvider);
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const _Empty(icon: FontAwesomeIcons.bookmark, message: 'Couldn\'t load saved'),
      data: (items) {
        if (items.isEmpty) {
          return const _Empty(
            icon: FontAwesomeIcons.bookmark,
            message: 'Nothing saved yet',
            subtitle: 'Tap Save on any movie or series and it will be waiting for you here.',
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          children: [for (final media in items) _SavedCard(media: media)],
        );
      },
    );
  }
}

/// Saved row — mirrors the Downloads `_FileCard` layout: poster thumb,
/// title + meta, trailing action. The trailing action un-saves the title.
class _SavedCard extends ConsumerWidget {
  final Media media;
  const _SavedCard({required this.media});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meta = [
      if (media.year != null) '${media.year}',
      if (media.countryDisplay.isNotEmpty) media.countryDisplay,
      if (media.genres.isNotEmpty) media.genres.first,
    ].join('  ·  ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: SinemaxColors.panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SinemaxColors.line, width: 0.5),
      ),
      child: GestureDetector(
        onTap: () => context.push('/detail/${media.id}?autoplay=1'),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Thumb(media: media, badge: media.isSeries ? 'SERIES' : 'MOVIE'),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      media.title,
                      style: SinemaxTextStyles.display(15.5, weight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (meta.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        meta,
                        style: SinemaxTextStyles.body(11.5, color: SinemaxColors.muted2),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (media.djDisplay.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        media.djDisplay,
                        style: SinemaxTextStyles.body(11.5, weight: FontWeight.w500, color: SinemaxColors.muted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => ref.read(savedProvider.notifier).toggle(media.id),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: SinemaxColors.panel2,
                    shape: BoxShape.circle,
                    border: Border.all(color: SinemaxColors.line, width: 0.5),
                  ),
                  child: const Center(child: FaIcon(FontAwesomeIcons.solidBookmark, size: 15, color: SinemaxColors.blue)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Round play button used as the trailing affordance on History rows.
class _PlayCircle extends StatelessWidget {
  final VoidCallback onTap;
  const _PlayCircle({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 34,
        height: 34,
        decoration: const BoxDecoration(color: SinemaxColors.blue, shape: BoxShape.circle),
        child: const Center(child: FaIcon(FontAwesomeIcons.play, size: 14, color: Colors.white)),
      ),
    );
  }
}

// ── Tab bar ───────────────────────────────────────────────────────────────────

class _Tabs extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  final List<int> counts;
  const _Tabs({required this.index, required this.onChanged, required this.counts});

  static const _labels = ['All', 'Movies', 'Series'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: SinemaxColors.line, width: 0.5)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < _labels.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _labels[i],
                            style: SinemaxTextStyles.display(
                              16,
                              weight: i == index ? FontWeight.w700 : FontWeight.w600,
                              color: i == index ? SinemaxColors.ink : SinemaxColors.muted,
                            ),
                          ),
                          if (counts[i] > 0) ...[
                            const SizedBox(width: 6),
                            Text(
                              '${counts[i]}',
                              style: SinemaxTextStyles.body(
                                11,
                                weight: FontWeight.w700,
                                color: i == index ? SinemaxColors.blue : SinemaxColors.muted2,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 9),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 2.5,
                        width: i == index ? 26 : 0,
                        decoration: BoxDecoration(
                          color: SinemaxColors.blue,
                          borderRadius: BorderRadius.circular(2),
                        ),
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

// ── All tab: flat list, every movie + episode standalone ──────────────────────

class _AllTab extends StatelessWidget {
  final List<(Media, List<DownloadRecord>)> groups;
  final List<(Media, DownloadRecord)> items;
  const _AllTab({required this.groups, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const _Empty(message: 'No downloads yet');
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
      children: [
        const _StorageHeader(),
        const SizedBox(height: 18),
        for (final (media, rec) in items) _FileCard(media: media, record: rec),
      ],
    );
  }
}

// ── Movies tab ────────────────────────────────────────────────────────────────

class _MoviesTab extends StatelessWidget {
  final List<(Media, DownloadRecord)> items;
  const _MoviesTab({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const _Empty(message: 'No downloaded movies');
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
      children: [for (final (media, rec) in items) _FileCard(media: media, record: rec)],
    );
  }
}

// ── Series tab ────────────────────────────────────────────────────────────────

class _SeriesTab extends StatelessWidget {
  final List<(Media, List<DownloadRecord>)> groups;
  const _SeriesTab({required this.groups});

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) return const _Empty(message: 'No downloaded series');
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
      children: [for (final (media, recs) in groups) _SeriesGroup(media: media, records: recs)],
    );
  }
}

// ── Standalone file card (movie or single episode) ────────────────────────────

class _FileCard extends StatelessWidget {
  final Media media;
  final DownloadRecord record;
  const _FileCard({required this.media, required this.record});

  @override
  Widget build(BuildContext context) {
    final isEpisode = media.isSeries;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: SinemaxColors.panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SinemaxColors.line, width: 0.5),
      ),
      child: GestureDetector(
        // Deep-link straight onto this exact file (e.g. episode 2), not the first.
        onTap: () => context.push('/detail/${media.id}?autoplay=1&file=${record.fileId}'),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Thumb(
                media: media,
                badge: isEpisode ? _episodeBadge(record.label) : 'MOVIE',
                completed: record.isCompleted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      media.title,
                      style: SinemaxTextStyles.display(15.5, weight: FontWeight.w700),
                      maxLines: isEpisode ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isEpisode) ...[
                      const SizedBox(height: 2),
                      Text(
                        record.label,
                        style: SinemaxTextStyles.body(12, weight: FontWeight.w500, color: SinemaxColors.muted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),
                    _MetaLine(record: record),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              DownloadActionControls(record: record),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Redesigned series group: header card + expandable episode list ────────────

class _SeriesGroup extends StatefulWidget {
  final Media media;
  final List<DownloadRecord> records;
  const _SeriesGroup({required this.media, required this.records});

  @override
  State<_SeriesGroup> createState() => _SeriesGroupState();
}

class _SeriesGroupState extends State<_SeriesGroup> {
  bool _expanded = false;

  Media get media => widget.media;
  List<DownloadRecord> get records => widget.records;

  @override
  Widget build(BuildContext context) {
    final done = records.where((r) => r.isCompleted).length;
    final active = records.where((r) => r.isActive).length;
    final bytes = records.where((r) => r.isCompleted).fold<int>(0, (s, r) => s + r.totalBytes);

    final summary = active > 0
        ? '$active downloading · $done of ${records.length} ready'
        : '$done of ${records.length} episodes${bytes > 0 ? ' · ${fmtBytes(bytes)}' : ''}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: SinemaxColors.panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _expanded ? SinemaxColors.line2 : SinemaxColors.line, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.push('/detail/${media.id}?autoplay=1'),
                    child: _Thumb(media: media, badge: 'SERIES'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          media.title,
                          style: SinemaxTextStyles.display(15.5, weight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          summary,
                          style: SinemaxTextStyles.body(12, weight: FontWeight.w500, color: active > 0 ? SinemaxColors.blue : SinemaxColors.muted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 7),
                        // mini ratio bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: records.isEmpty ? 0 : done / records.length,
                            backgroundColor: SinemaxColors.line2,
                            color: active > 0 ? SinemaxColors.blue : SinemaxColors.teal,
                            minHeight: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const FaIcon(FontAwesomeIcons.chevronDown, size: 18, color: SinemaxColors.muted2),
                  ),
                ],
              ),
            ),
          ),
          // Episodes
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Column(
              children: [
                const Divider(height: 1, thickness: 0.5, color: SinemaxColors.line, indent: 10, endIndent: 10),
                for (var i = 0; i < records.length; i++)
                  _EpisodeRow(index: i + 1, record: records[i]),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact per-episode row inside an expanded series card: a number badge,
/// label + live meta, and the state-aware controls.
class _EpisodeRow extends StatelessWidget {
  final int index;
  final DownloadRecord record;
  const _EpisodeRow({required this.index, required this.record});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 10, 8),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: record.isCompleted ? SinemaxColors.blue.withValues(alpha: 0.16) : SinemaxColors.panel2,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: SinemaxColors.line, width: 0.5),
            ),
            child: Center(
              child: Text(
                '$index',
                style: SinemaxTextStyles.display(14, weight: FontWeight.w700, color: record.isCompleted ? SinemaxColors.blue : SinemaxColors.muted),
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.label,
                  style: SinemaxTextStyles.body(13, weight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                _MetaLine(record: record, compact: true),
              ],
            ),
          ),
          const SizedBox(width: 8),
          DownloadActionControls(record: record),
        ],
      ),
    );
  }
}

// ── Poster thumbnail with overlay badge / progress / play ─────────────────────

class _Thumb extends StatelessWidget {
  final Media media;
  final String? badge;
  final bool completed;
  const _Thumb({required this.media, this.badge, this.completed = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 116,
        height: 76,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (media.posterUrl != null)
              CachedNetworkImage(
                imageUrl: media.posterUrl!,
                fit: BoxFit.cover,
                placeholder: (_, _) => const ColoredBox(color: SinemaxColors.panel2),
                errorBuilder: (_, _, _) => const _ThumbFallback(),
              )
            else
              const _ThumbFallback(),
            // bottom gradient for legibility
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0x99000000)],
                ),
              ),
            ),
            if (completed)
              Center(
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.85), width: 1.2),
                  ),
                  child: const Center(child: FaIcon(FontAwesomeIcons.play, size: 12, color: Colors.white)),
                ),
              ),
            if (badge != null)
              Positioned(
                left: 6,
                bottom: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    badge!,
                    style: SinemaxTextStyles.body(9.5, weight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ThumbFallback extends StatelessWidget {
  const _ThumbFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: SinemaxColors.panel2,
      child: Center(child: FaIcon(FontAwesomeIcons.play, size: 20, color: SinemaxColors.muted2)),
    );
  }
}

// ── Live status / meta line + inline progress bar ─────────────────────────────

class _MetaLine extends StatelessWidget {
  final DownloadRecord record;
  final bool compact;
  const _MetaLine({required this.record, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final status = record.statusEnum;
    final pct = (record.progress * 100).round();
    final size = compact ? 11.0 : 11.5;

    final (text, color) = switch (status) {
      DownloadStatus.queued => ('Waiting…', SinemaxColors.muted),
      DownloadStatus.running => (
          '$pct%${record.totalBytes > 0 ? ' · ${fmtBytes((record.progress * record.totalBytes).round())} of ${fmtBytes(record.totalBytes)}' : ''}',
          SinemaxColors.blue,
        ),
      DownloadStatus.paused => ('Paused · $pct%', SinemaxColors.muted),
      DownloadStatus.encrypting => ('Saving file…', SinemaxColors.blue),
      DownloadStatus.completed => (
          '${record.totalBytes > 0 ? '${fmtBytes(record.totalBytes)} · ' : ''}MP4 · ${fmtDate(record.at)}',
          SinemaxColors.muted2,
        ),
      DownloadStatus.failed => ('Download failed', SinemaxColors.red),
    };

    final showBar = status == DownloadStatus.running || status == DownloadStatus.paused || status == DownloadStatus.queued;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: SinemaxTextStyles.body(size, color: color), maxLines: 1, overflow: TextOverflow.ellipsis),
        if (showBar) ...[
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: status == DownloadStatus.queued ? null : record.progress.clamp(0.0, 1.0),
              backgroundColor: SinemaxColors.line2,
              color: status == DownloadStatus.paused ? SinemaxColors.muted : SinemaxColors.blue,
              minHeight: 3,
            ),
          ),
        ],
      ],
    );
  }
}

// ── Storage summary (All tab header) ──────────────────────────────────────────

/// Device storage summary — total used vs. free on the volume that holds the
/// app's downloads. Reads live figures from the platform via disk_space_plus.
class _StorageHeader extends StatefulWidget {
  const _StorageHeader();

  @override
  State<_StorageHeader> createState() => _StorageHeaderState();
}

class _StorageHeaderState extends State<_StorageHeader> {
  int? _totalBytes;
  int? _freeBytes;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final disk = DiskSpacePlus();
      final totalMb = await disk.getTotalDiskSpace;
      final freeMb = await disk.getFreeDiskSpace;
      if (!mounted) return;
      setState(() {
        _totalBytes = totalMb == null ? null : (totalMb * 1024 * 1024).round();
        _freeBytes = freeMb == null ? null : (freeMb * 1024 * 1024).round();
      });
    } catch (_) {
      // Leave figures null — the header renders a neutral "Storage" state.
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _totalBytes;
    final free = _freeBytes;
    final hasData = total != null && total > 0 && free != null;
    final used = hasData ? math.max(0, total - free) : null;
    final usedFraction = hasData ? (used! / total).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SinemaxColors.panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SinemaxColors.line, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [SinemaxColors.blue, SinemaxColors.blueBright]),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Center(child: FaIcon(FontAwesomeIcons.download, size: 22, color: Colors.white)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      used != null ? '${fmtBytes(used)} used' : 'Storage',
                      style: SinemaxTextStyles.display(24, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasData ? '${fmtBytes(free)} free of ${fmtBytes(total)}' : 'Calculating device storage…',
                      style: SinemaxTextStyles.body(12, color: SinemaxColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Used (blue) vs. free (track) on this device.
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: SizedBox(
              height: 5,
              child: Stack(
                children: [
                  const Positioned.fill(child: ColoredBox(color: SinemaxColors.line2)),
                  FractionallySizedBox(
                    widthFactor: usedFraction,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [SinemaxColors.blue, SinemaxColors.blueBright]),
                      ),
                    ),
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

class _Empty extends StatelessWidget {
  final String message;
  final FaIconData icon;
  final String subtitle;
  const _Empty({
    required this.message,
    this.icon = FontAwesomeIcons.download,
    this.subtitle = 'Movies and series you download appear here — ready to watch offline, anywhere.',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: SinemaxColors.panel,
                shape: BoxShape.circle,
                border: Border.all(color: SinemaxColors.line, width: 0.5),
              ),
              child: Center(child: FaIcon(icon, size: 32, color: SinemaxColors.muted2)),
            ),
            const SizedBox(height: 18),
            Text(message, style: SinemaxTextStyles.display(18, weight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: SinemaxTextStyles.body(12.5, color: SinemaxColors.muted2),
            ),
          ],
        ),
      ),
    );
  }
}

/// Short thumbnail badge from an episode label, e.g. "Episode 3" → "EP 3".
String _episodeBadge(String label) {
  final m = RegExp(r'\d+').firstMatch(label);
  return m != null ? 'EP ${m.group(0)}' : label.toUpperCase();
}
