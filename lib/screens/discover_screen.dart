import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../data/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/poster_card.dart';
import '../widgets/sinemax_search_bar.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(discoverFiltersProvider);
    final yearsAsync = ref.watch(filterYearsProvider);
    final djsAsync = ref.watch(filterDjsProvider);
    final countriesAsync = ref.watch(filterCountriesProvider);
    final resultsAsync = ref.watch(discoverResultsProvider);

    return Scaffold(
      backgroundColor: SinemaxColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: SinemaxColors.bg,
            pinned: true,
            toolbarHeight: 62,
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            title: const Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: SinemaxSearchBar()),
          ),

          // Filter chips
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  _DropdownChip(label: 'Year', selected: filters.year, options: yearsAsync.value ?? ['All'], onSelect: (v) => ref.read(discoverFiltersProvider.notifier).setYear(v)),
                  const SizedBox(width: 8),
                  _DropdownChip(label: 'DJ', selected: filters.dj, options: djsAsync.value ?? ['All'], onSelect: (v) => ref.read(discoverFiltersProvider.notifier).setDj(v)),
                  const SizedBox(width: 8),
                  _DropdownChip(label: 'Country', selected: filters.country, options: countriesAsync.value ?? ['All'], onSelect: (v) => ref.read(discoverFiltersProvider.notifier).setCountry(v)),
                  const SizedBox(width: 8),
                  _DropdownChip(label: 'Type', selected: filters.type, options: const ['All', 'Series', 'Movie'], onSelect: (v) => ref.read(discoverFiltersProvider.notifier).setType(v)),
                ],
              ),
            ),
          ),

          // Clear all chip (only when filters are active)
          if (filters.year != 'All' || filters.dj != 'All' || filters.country != 'All' || filters.type != 'All')
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => ref.read(discoverFiltersProvider.notifier).reset(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: SinemaxColors.red.withAlpha(28),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: SinemaxColors.red.withAlpha(120), width: 0.8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const FaIcon(FontAwesomeIcons.xmark, size: 14, color: SinemaxColors.red),
                            const SizedBox(width: 4),
                            Text(
                              'Clear filters',
                              style: SinemaxTextStyles.body(13, color: SinemaxColors.red, weight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Results count + grid
          ...resultsAsync.when(
            loading: () => [const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))],
            error: (e, _) => [
              SliverFillRemaining(
                child: Center(
                  child: Text('Failed to load content', style: SinemaxTextStyles.body(15, color: SinemaxColors.muted)),
                ),
              ),
            ],
            data: (results) => [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Text('${results.length} title${results.length == 1 ? '' : 's'}', style: SinemaxTextStyles.body(13, color: SinemaxColors.muted)),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 130 / 190),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => LayoutBuilder(
                      builder: (context, constraints) =>
                          PosterCard(media: results[i], width: constraints.maxWidth, height: constraints.maxHeight, onTap: () => context.push('/detail/${results[i].id}')),
                    ),
                    childCount: results.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DropdownChip extends StatelessWidget {
  final String label;
  final String selected;
  final List<String> options;
  final ValueChanged<String> onSelect;

  const _DropdownChip({required this.label, required this.selected, required this.options, required this.onSelect});

  bool get _active => selected != 'All';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSheet(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: _active ? SinemaxColors.blue.withAlpha(40) : SinemaxColors.panel,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _active ? SinemaxColors.blue : SinemaxColors.line2, width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _active ? selected : label,
              style: SinemaxTextStyles.body(13, color: _active ? SinemaxColors.blue : SinemaxColors.muted, weight: _active ? FontWeight.w600 : FontWeight.w400),
            ),
            const SizedBox(width: 3),
            FaIcon(FontAwesomeIcons.chevronDown, size: 16, color: _active ? SinemaxColors.blue : SinemaxColors.muted),
          ],
        ),
      ),
    );
  }

  void _showSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _PickerSheet(
        title: 'SELECT ${label.toUpperCase()}',
        options: options,
        selected: selected,
        onSelect: (v) {
          onSelect(v);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class _PickerSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;

  const _PickerSheet({required this.title, required this.options, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.72),
      decoration: const BoxDecoration(
        color: SinemaxColors.panel,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: SinemaxColors.line2, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: SinemaxTextStyles.display(17, weight: FontWeight.w700)),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const FaIcon(FontAwesomeIcons.xmark, color: SinemaxColors.muted, size: 22),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: SinemaxColors.line),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 6),
              itemCount: options.length,
              itemBuilder: (context, i) {
                final opt = options[i];
                final isSelected = opt == selected;
                return InkWell(
                  onTap: () => onSelect(opt),
                  splashColor: SinemaxColors.blue.withAlpha(20),
                  highlightColor: SinemaxColors.blue.withAlpha(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    color: isSelected ? SinemaxColors.blue.withAlpha(28) : Colors.transparent,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            opt,
                            style: SinemaxTextStyles.body(15, color: isSelected ? SinemaxColors.ink : SinemaxColors.muted, weight: isSelected ? FontWeight.w600 : FontWeight.w400),
                          ),
                        ),
                        if (isSelected) const FaIcon(FontAwesomeIcons.check, color: SinemaxColors.blue, size: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}
