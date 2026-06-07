import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/local_data.dart';
import '../data/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/movie_card.dart';
import '../widgets/sinemax_icon.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SinemaxColors.bg,
      appBar: AppBar(
        backgroundColor: SinemaxColors.bg,
        title: Text('Library', style: SinemaxTextStyles.display(22, weight: FontWeight.w700)),
        bottom: TabBar(
          controller: _tabs,
          labelColor: SinemaxColors.blue,
          unselectedLabelColor: SinemaxColors.muted2,
          indicatorColor: SinemaxColors.blue,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: SinemaxTextStyles.body(13, weight: FontWeight.w600),
          unselectedLabelStyle: SinemaxTextStyles.body(13),
          tabs: const [
            Tab(text: 'Recent'),
            Tab(text: 'Saved'),
            Tab(text: 'Downloads'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _RecentTab(),
          _SavedTab(),
          _DownloadsTab(),
        ],
      ),
    );
  }
}

// ── Recent ────────────────────────────────────────────────────────────────────

class _RecentTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recent = ref.watch(recentProvider);
    if (recent.isEmpty) return _Empty(icon: 'clock', message: 'Nothing watched yet');

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: recent.length,
      itemBuilder: (context, i) {
        final item = recent[i];
        final content = contentById(item.contentId);
        if (content == null) return const SizedBox.shrink();
        return MovieCard(
          content: content,
          meta: '${item.watchedAt} · ${item.context}',
          progress: item.progress < 1.0 ? item.progress : null,
          onTap: () => context.push('/detail/${content.id}'),
        );
      },
    );
  }
}

// ── Saved ─────────────────────────────────────────────────────────────────────

class _SavedTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedContentProvider);
    if (saved.isEmpty) return _Empty(icon: 'bookmark', message: 'No saved titles yet');

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: saved.length,
      itemBuilder: (context, i) {
        final content = saved[i];
        return MovieCard(
          content: content,
          trailing: GestureDetector(
            onTap: () => ref.read(savedProvider.notifier).toggle(content.id),
            child: const SinemaxIcon('x', size: 18, color: SinemaxColors.muted2),
          ),
          onTap: () => context.push('/detail/${content.id}'),
        );
      },
    );
  }
}

// ── Downloads ─────────────────────────────────────────────────────────────────

class _DownloadsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dlItems = ref.watch(downloadsProvider);
    if (dlItems.isEmpty) return _Empty(icon: 'download', message: 'No downloads yet');

    final totalUsed = storagePercent;

    return CustomScrollView(
      slivers: [
        // Storage bar
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: SinemaxColors.panel,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: SinemaxColors.line, width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SinemaxIcon('download', size: 16, color: SinemaxColors.muted),
                    const SizedBox(width: 8),
                    Text('Storage', style: SinemaxTextStyles.body(13, weight: FontWeight.w600)),
                    const Spacer(),
                    Text(
                      '$storageUsed / $storageTotal',
                      style: SinemaxTextStyles.body(12, color: SinemaxColors.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: totalUsed,
                    backgroundColor: SinemaxColors.line2,
                    color: SinemaxColors.blue,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              final dl = dlItems[i];
              final content = contentById(dl.contentId);
              if (content == null) return const SizedBox.shrink();
              return MovieCard(
                content: content,
                meta: '${dl.quality} · ${dl.size} · ${dl.at}',
                trailing: GestureDetector(
                  onTap: () => ref.read(downloadsProvider.notifier).remove(dl.contentId),
                  child: const SinemaxIcon('trash', size: 18, color: SinemaxColors.muted2),
                ),
                onTap: () => context.push('/detail/${content.id}'),
              );
            },
            childCount: dlItems.length,
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _Empty extends StatelessWidget {
  final String icon;
  final String message;
  const _Empty({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SinemaxIcon(icon, size: 44, color: SinemaxColors.muted2),
          const SizedBox(height: 14),
          Text(message, style: SinemaxTextStyles.body(15, color: SinemaxColors.muted)),
        ],
      ),
    );
  }
}
