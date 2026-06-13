import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers.dart';
import '../models/media.dart';
import '../theme/app_theme.dart';
import '../widgets/poster_card.dart';
import '../widgets/sinemax_icon.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  SearchQuery? _searchNotifier;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _searchNotifier = ref.read(searchQueryProvider.notifier);
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    Future(() => _searchNotifier?.clear());
    super.dispose();
  }

  /// Run a query coming from a tapped chip / submitted field.
  void _runQuery(String term) {
    final t = term.trim();
    if (t.isEmpty) return;
    _controller.value = TextEditingValue(text: t, selection: TextSelection.collapsed(offset: t.length));
    ref.read(searchQueryProvider.notifier).set(t);
    ref.read(recentSearchTermsProvider.notifier).add(t);
    _focusNode.unfocus();
  }

  /// Forward an unmatched query to the request form, pre-filling the title.
  void _requestMissing(String query) {
    final t = query.trim();
    if (t.isEmpty) return;
    ref.read(pendingRequestTitleProvider.notifier).set(t);
    context.go('/requests');
  }

  /// Open a media item, recording it (and the active query) into search history.
  void _openMedia(Media media) {
    final q = ref.read(searchQueryProvider).trim();
    if (q.isNotEmpty) ref.read(recentSearchTermsProvider.notifier).add(q);
    ref.read(recentSearchMediaProvider.notifier).add(media.id);
    context.push('/detail/${media.id}');
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(searchResultsProvider);
    final query = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: SinemaxColors.bg,
      appBar: AppBar(
        backgroundColor: SinemaxColors.bg,
        leading: IconButton(icon: const SinemaxIcon('arrowL', size: 22), onPressed: () => context.pop()),
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          style: SinemaxTextStyles.body(16),
          cursorColor: SinemaxColors.blue,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search movies, series...',
            hintStyle: SinemaxTextStyles.body(16, color: SinemaxColors.muted2),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          onChanged: (v) => ref.read(searchQueryProvider.notifier).set(v),
          onSubmitted: (v) {
            final t = v.trim();
            if (t.isNotEmpty) ref.read(recentSearchTermsProvider.notifier).add(t);
          },
        ),
        actions: [
          if (query.isNotEmpty)
            IconButton(
              icon: const SinemaxIcon('x', size: 20),
              onPressed: () {
                _controller.clear();
                ref.read(searchQueryProvider.notifier).clear();
              },
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: query.isEmpty
          ? _RecentView(onTapTerm: _runQuery, onTapMedia: _openMedia)
          : resultsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('Search failed', style: SinemaxTextStyles.body(15, color: SinemaxColors.muted)),
              ),
              data: (results) => results.isEmpty
                  ? _NoResults(query: query, onRequest: () => _requestMissing(query))
                  : _Results(results: results, onTap: _openMedia),
            ),
    );
  }
}

/// Shown when the query is empty: recent search chips + a catalog of media the
/// user has recently opened from search. Falls back to a hint when both empty.
class _RecentView extends ConsumerWidget {
  final void Function(String term) onTapTerm;
  final void Function(Media media) onTapMedia;
  const _RecentView({required this.onTapTerm, required this.onTapMedia});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final terms = ref.watch(recentSearchTermsProvider);
    final mediaAsync = ref.watch(recentSearchContentProvider);
    final media = mediaAsync.value ?? const <Media>[];

    if (terms.isEmpty && media.isEmpty) return const _EmptyState();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        if (terms.isNotEmpty) ...[
          _SectionHeading(
            title: 'Recent searches',
            onClear: () => ref.read(recentSearchTermsProvider.notifier).clear(),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in terms)
                _SearchChip(
                  label: t,
                  onTap: () => onTapTerm(t),
                  onRemove: () => ref.read(recentSearchTermsProvider.notifier).remove(t),
                ),
            ],
          ),
          const SizedBox(height: 24),
        ],
        if (media.isNotEmpty) ...[
          _SectionHeading(
            title: 'Recently viewed',
            onClear: () => ref.read(recentSearchMediaProvider.notifier).clear(),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 130 / 190,
            ),
            itemCount: media.length,
            itemBuilder: (context, i) => LayoutBuilder(
              builder: (context, constraints) => PosterCard(
                media: media[i],
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                onTap: () => onTapMedia(media[i]),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final VoidCallback onClear;
  const _SectionHeading({required this.title, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: SinemaxTextStyles.display(18, weight: FontWeight.w600)),
        GestureDetector(
          onTap: onClear,
          behavior: HitTestBehavior.opaque,
          child: Text('Clear', style: SinemaxTextStyles.body(13, color: SinemaxColors.blue)),
        ),
      ],
    );
  }
}

class _SearchChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  const _SearchChip({required this.label, required this.onTap, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        decoration: BoxDecoration(
          color: SinemaxColors.panel2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: SinemaxColors.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SinemaxIcon('search', size: 13, color: SinemaxColors.muted),
            const SizedBox(width: 7),
            Text(label, style: SinemaxTextStyles.body(13.5, color: SinemaxColors.ink)),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onRemove,
              behavior: HitTestBehavior.opaque,
              child: const SinemaxIcon('x', size: 13, color: SinemaxColors.muted2),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SinemaxIcon('search', size: 48, color: SinemaxColors.muted2),
          const SizedBox(height: 16),
          Text('Search for movies & series', style: SinemaxTextStyles.body(16, color: SinemaxColors.muted)),
          const SizedBox(height: 6),
          Text('Type a title, genre, DJ or country', style: SinemaxTextStyles.body(13, color: SinemaxColors.muted2)),
        ],
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  final String query;
  final VoidCallback onRequest;
  const _NoResults({required this.query, required this.onRequest});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SinemaxIcon('search', size: 40, color: SinemaxColors.muted2),
            const SizedBox(height: 16),
            Text(
              'Hatukupata "$query"',
              textAlign: TextAlign.center,
              style: SinemaxTextStyles.body(16, weight: FontWeight.w600, color: SinemaxColors.ink),
            ),
            const SizedBox(height: 8),
            Text(
              'Filamu au series hii haipo kwenye orodha yetu bado. Tuombe tuikuwekee!',
              textAlign: TextAlign.center,
              style: SinemaxTextStyles.body(13, color: SinemaxColors.muted),
            ),
            const SizedBox(height: 24),

            // ── Request CTA card ──────────────────────────────────────────
            GestureDetector(
              onTap: onRequest,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [SinemaxColors.blue, SinemaxColors.blueBright],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: SinemaxColors.blue.withAlpha(70),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(40),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(child: SinemaxIcon('send', size: 18, color: Colors.white)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Agiza "$query"',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: SinemaxTextStyles.body(15, weight: FontWeight.w700, color: Colors.white),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Tutakuwekea haraka iwezekanavyo',
                            style: SinemaxTextStyles.body(12, color: Colors.white.withAlpha(220)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const SinemaxIcon('chevR', size: 18, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Results extends StatelessWidget {
  final List<Media> results;
  final void Function(Media media) onTap;
  const _Results({required this.results, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 130 / 190),
      itemCount: results.length,
      itemBuilder: (context, i) => LayoutBuilder(
        builder: (context, constraints) => PosterCard(media: results[i], width: constraints.maxWidth, height: constraints.maxHeight, onTap: () => onTap(results[i])),
      ),
    );
  }
}
