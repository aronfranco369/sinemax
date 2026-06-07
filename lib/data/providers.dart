import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/content.dart';
import '../models/library_item.dart';
import '../models/request.dart';
import 'local_data.dart';

// ── Catalog (read-only) ───────────────────────────────────────────────────────

final catalogProvider = Provider<List<Content>>((ref) => catalog);

final djsProvider = Provider((ref) => allDjs);

final homeRowsProvider = Provider((ref) => homeRows);

final featuredProvider = Provider<Content?>((ref) => contentById(featuredId));

// ── Discover ──────────────────────────────────────────────────────────────────

class DiscoverFilters {
  final String year;
  final String dj;
  final String country;
  final String type;

  const DiscoverFilters({
    this.year    = 'All',
    this.dj      = 'All',
    this.country = 'All',
    this.type    = 'All',
  });

  DiscoverFilters copyWith({String? year, String? dj, String? country, String? type}) {
    return DiscoverFilters(
      year:    year    ?? this.year,
      dj:      dj      ?? this.dj,
      country: country ?? this.country,
      type:    type    ?? this.type,
    );
  }

  bool get isDefault => year == 'All' && dj == 'All' && country == 'All' && type == 'All';
}

class DiscoverNotifier extends Notifier<DiscoverFilters> {
  @override
  DiscoverFilters build() => const DiscoverFilters();

  void setYear(String v)    => state = state.copyWith(year: v);
  void setDj(String v)      => state = state.copyWith(dj: v);
  void setCountry(String v) => state = state.copyWith(country: v);
  void setType(String v)    => state = state.copyWith(type: v);
  void reset()              => state = const DiscoverFilters();
}

final discoverFiltersProvider = NotifierProvider<DiscoverNotifier, DiscoverFilters>(
  DiscoverNotifier.new,
);

final discoverResultsProvider = Provider<List<Content>>((ref) {
  final filters = ref.watch(discoverFiltersProvider);
  if (filters.isDefault) {
    return discoverGrid.map((id) => contentById(id)).whereType<Content>().toList();
  }
  return catalog.where((c) {
    if (filters.year != 'All' && c.year.toString() != filters.year) return false;
    if (filters.dj != 'All') {
      final dj = djById(c.djId);
      if (dj == null || dj.name != filters.dj) return false;
    }
    if (filters.country != 'All' && c.countryLabel != filters.country) return false;
    if (filters.type != 'All') {
      if (filters.type == 'Series' && c.type != 'series') return false;
      if (filters.type == 'Movie'  && !(c.type == 'movie' && c.countryLabel != 'Tanzania')) return false;
      if (filters.type == 'Bongo'  && !(c.type == 'movie' && c.countryLabel == 'Tanzania')) return false;
    }
    return true;
  }).toList();
});

// ── Search ────────────────────────────────────────────────────────────────────

class SearchNotifier extends Notifier<String> {
  @override
  String build() => '';
  void set(String q) => state = q;
  void clear()       => state = '';
}

final searchQueryProvider = NotifierProvider<SearchNotifier, String>(SearchNotifier.new);

final searchResultsProvider = Provider<List<Content>>((ref) {
  final q = ref.watch(searchQueryProvider).trim().toLowerCase();
  if (q.isEmpty) return [];
  return catalog.where((c) {
    return c.title.toLowerCase().contains(q) ||
        c.genre.toLowerCase().contains(q) ||
        c.countryLabel.toLowerCase().contains(q);
  }).toList();
});

// ── Library — saved ───────────────────────────────────────────────────────────

class SavedNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => List<String>.from(savedIds);

  void toggle(String id) {
    if (state.contains(id)) {
      state = state.where((x) => x != id).toList();
    } else {
      state = [id, ...state];
    }
  }

  bool isSaved(String id) => state.contains(id);
}

final savedProvider = NotifierProvider<SavedNotifier, List<String>>(SavedNotifier.new);

final savedContentProvider = Provider<List<Content>>((ref) {
  final ids = ref.watch(savedProvider);
  return ids.map((id) => contentById(id)).whereType<Content>().toList();
});

// ── Library — recent ──────────────────────────────────────────────────────────

class RecentNotifier extends Notifier<List<WatchedItem>> {
  @override
  List<WatchedItem> build() => List<WatchedItem>.from(recentlyWatched);

  void markWatched(String contentId, {double progress = 0.0, String context = ''}) {
    final updated = WatchedItem(
      contentId: contentId,
      watchedAt: 'Just now',
      progress: progress,
      context: context,
    );
    state = [
      updated,
      ...state.where((w) => w.contentId != contentId),
    ];
  }
}

final recentProvider = NotifierProvider<RecentNotifier, List<WatchedItem>>(RecentNotifier.new);

// ── Library — downloads ───────────────────────────────────────────────────────

class DownloadsNotifier extends Notifier<List<DownloadItem>> {
  @override
  List<DownloadItem> build() => List<DownloadItem>.from(downloads);

  void remove(String contentId) {
    state = state.where((d) => d.contentId != contentId).toList();
  }
}

final downloadsProvider = NotifierProvider<DownloadsNotifier, List<DownloadItem>>(
  DownloadsNotifier.new,
);

// ── Requests ──────────────────────────────────────────────────────────────────

class RequestsNotifier extends Notifier<List<ContentRequest>> {
  @override
  List<ContentRequest> build() => List<ContentRequest>.from(requestHistory);

  void add(String title, String note) {
    final id = 'r${state.length + 1}-${DateTime.now().millisecondsSinceEpoch}';
    state = [
      ContentRequest(
        id: id,
        title: title,
        note: note,
        status: RequestStatus.pending,
        date: _today(),
      ),
      ...state,
    ];
  }

  String _today() {
    final now = DateTime.now();
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[now.month - 1]} ${now.day}';
  }
}

final requestsProvider = NotifierProvider<RequestsNotifier, List<ContentRequest>>(
  RequestsNotifier.new,
);
