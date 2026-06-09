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
          decoration: InputDecoration(
            hintText: 'Search movies, series...',
            hintStyle: SinemaxTextStyles.body(16, color: SinemaxColors.muted2),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          onChanged: (v) => ref.read(searchQueryProvider.notifier).set(v),
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
          ? _EmptyState()
          : resultsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('Search failed', style: SinemaxTextStyles.body(15, color: SinemaxColors.muted)),
              ),
              data: (results) => results.isEmpty ? _NoResults(query: query) : _Results(results: results),
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
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
  const _NoResults({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SinemaxIcon('x', size: 40, color: SinemaxColors.muted2),
          const SizedBox(height: 16),
          Text('No results for "$query"', style: SinemaxTextStyles.body(15, color: SinemaxColors.muted)),
          const SizedBox(height: 6),
          Text('Try a different title or genre', style: SinemaxTextStyles.body(13, color: SinemaxColors.muted2)),
        ],
      ),
    );
  }
}

class _Results extends StatelessWidget {
  final List<Media> results;
  const _Results({required this.results});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 130 / 190),
      itemCount: results.length,
      itemBuilder: (context, i) => LayoutBuilder(
        builder: (context, constraints) => PosterCard(media: results[i], width: constraints.maxWidth, height: constraints.maxHeight, onTap: () => context.push('/detail/${results[i].id}')),
      ),
    );
  }
}
