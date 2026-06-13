import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/discover_filter.dart';
import '../models/library_item.dart';
import '../models/media.dart';
import '../models/request.dart';
import '../utils/row_labels.dart';
import 'connectivity_notifier.dart';
import 'files_notifier.dart';
import 'media_notifier.dart';

export 'download_engine.dart' show DownloadEngine;
export 'downloads_notifier.dart' show downloadsProvider, downloadsContentProvider, Downloads;
export 'connectivity_notifier.dart' show connectionStatusProvider, ConnectionStatus;
export 'files_notifier.dart' show filesProvider, FilesNotifier;
export 'media_notifier.dart' show mediaProvider, MediaNotifier;

part 'providers.g.dart';

// ── Catalog ───────────────────────────────────────────────────────────────────

@riverpod
Future<Media?> mediaById(Ref ref, String id) async {
  final list = await ref.watch(mediaProvider.future);
  try {
    return list.firstWhere((m) => m.id == id);
  } catch (_) {
    return null;
  }
}

@riverpod
Future<List<HomeRow>> homeRows(Ref ref) async {
  final list = await ref.watch(mediaProvider.future);
  final Map<String, List<Media>> groups = {};
  for (final m in list) {
    final country = m.countryDisplay;
    if (country.isEmpty) continue;
    final key = '${country.toUpperCase()} ${m.isSeries ? 'SERIES' : 'MOVIES'}';
    groups.putIfAbsent(key, () => []).add(m);
  }
  int rowScore(List<Media> items) {
    final sorted = [...items]..sort((a, b) => b.viewCount.compareTo(a.viewCount));
    return sorted.take(20).fold(0, (sum, m) => sum + m.viewCount);
  }

  return (groups.entries.where((e) => e.value.length >= 2).map((e) {
    final lookupKey = e.key.toLowerCase();
    final title = (kRowLabels[lookupKey]?.isNotEmpty == true) ? kRowLabels[lookupKey]! : e.key;
    final sorted = [...e.value]..sort((a, b) => b.viewCount.compareTo(a.viewCount));
    return HomeRow(id: e.key.toLowerCase().replaceAll(' ', '-'), title: title, items: sorted);
  }).toList()
    ..sort((a, b) => rowScore(b.items).compareTo(rowScore(a.items))));
}

/// Files for a specific media — reads from Hive via FilesNotifier.
/// Triggers a background Supabase fetch on first access for this mediaId.
@riverpod
Future<List<MediaFile>> mediaFiles(Ref ref, String mediaId) async {
  // Re-run on connectivity changes so an offline-failed lazy fetch retries
  // automatically once internet is back.
  ref.watch(connectionStatusProvider);
  // Fire-and-forget: fetch from Supabase if this mediaId isn't cached yet
  Future.microtask(() => ref.read(filesProvider.notifier).ensureLoaded(mediaId));
  // Watch the full files box; re-runs automatically when new files are added
  final all = await ref.watch(filesProvider.future);
  return all
      .where((f) => f.mediaId == mediaId)
      .toList()
    ..sort((a, b) {
      final epA = a.episodeNumber ?? 999;
      final epB = b.episodeNumber ?? 999;
      if (epA != epB) return epA.compareTo(epB);
      return (a.label ?? '').compareTo(b.label ?? '');
    });
}

final trendingMediaProvider = FutureProvider<List<Media>>((ref) async {
  final list = await ref.watch(mediaProvider.future);
  final withViews = list.where((m) => m.viewCount > 0).toList()
    ..sort((a, b) => b.viewCount.compareTo(a.viewCount));
  return withViews.take(5).toList();
});

@riverpod
Future<List<Media>> relatedMedia(Ref ref, String mediaId) async {
  final list = await ref.watch(mediaProvider.future);
  try {
    final media = list.firstWhere((m) => m.id == mediaId);
    return list
        .where((m) =>
            m.id != mediaId &&
            (m.country == media.country ||
                (m.genres.isNotEmpty && media.genres.isNotEmpty && m.genres.first == media.genres.first)))
        .take(6)
        .toList();
  } catch (_) {
    return [];
  }
}

// ── Filter options ────────────────────────────────────────────────────────────

@riverpod
Future<List<String>> filterYears(Ref ref) async {
  final list = await ref.watch(mediaProvider.future);
  final years = list.map((m) => m.year?.toString() ?? '').where((y) => y.isNotEmpty).toSet().toList()
    ..sort((a, b) => b.compareTo(a));
  return ['All', ...years];
}

@riverpod
Future<List<String>> filterDjs(Ref ref) async {
  final list = await ref.watch(mediaProvider.future);
  final djs = list.map((m) => m.dj ?? '').where((d) => d.isNotEmpty).toSet().toList()..sort();
  return ['All', ...djs];
}

@riverpod
Future<List<String>> filterCountries(Ref ref) async {
  final list = await ref.watch(mediaProvider.future);
  final countries = list.map((m) => m.countryDisplay).where((c) => c.isNotEmpty).toSet().toList()..sort();
  return ['All', ...countries];
}

// ── Discover ──────────────────────────────────────────────────────────────────

@riverpod
class DiscoverFilters extends _$DiscoverFilters {
  @override
  DiscoverFilter build() => const DiscoverFilter();

  void setYear(String v) => state = state.copyWith(year: v);
  void setDj(String v) => state = state.copyWith(dj: v);
  void setCountry(String v) => state = state.copyWith(country: v);
  void setType(String v) => state = state.copyWith(type: v);
  void reset() => state = const DiscoverFilter();
  void preset(DiscoverFilter f) => state = f;
}

@riverpod
Future<List<Media>> discoverResults(Ref ref) async {
  final list = await ref.watch(mediaProvider.future);
  final filters = ref.watch(discoverFiltersProvider);
  final base = filters.isDefault ? list : list.where((m) {
    if (filters.year != 'All' && m.year?.toString() != filters.year) return false;
    if (filters.dj != 'All' && m.dj != filters.dj) return false;
    if (filters.country != 'All' && m.countryDisplay != filters.country) return false;
    if (filters.type != 'All') {
      if (filters.type == 'Series' && !m.isSeries) return false;
      if (filters.type == 'Movie' && m.isSeries) return false;
    }
    return true;
  }).toList();
  return base..sort((a, b) => b.viewCount.compareTo(a.viewCount));
}

// ── Search ────────────────────────────────────────────────────────────────────

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';
  void set(String q) => state = q;
  void clear() => state = '';
}

/// Title to pre-fill the request form with, set when a user is forwarded from a
/// no-result search. Consumed (and cleared) by [RequestsScreen].
@riverpod
class PendingRequestTitle extends _$PendingRequestTitle {
  @override
  String? build() => null;
  void set(String title) => state = title;
  void clear() => state = null;
}

@riverpod
Future<List<Media>> searchResults(Ref ref) async {
  final q = ref.watch(searchQueryProvider).trim().toLowerCase();
  if (q.isEmpty) return [];
  final list = await ref.watch(mediaProvider.future);
  return list.where((m) {
    return m.title.toLowerCase().contains(q) ||
        m.genres.any((g) => g.toLowerCase().contains(q)) ||
        m.countryDisplay.toLowerCase().contains(q) ||
        (m.dj?.toLowerCase().contains(q) ?? false);
  }).toList();
}

// ── Search history (chips + tapped media catalog) ──────────────────────────────

const _kRecentTermsKey = 'terms';
const _kRecentMediaKey = 'media';
const _kMaxRecentTerms = 10;
const _kMaxRecentMedia = 12;

List<String> _decodeList(String? raw) {
  if (raw == null || raw.isEmpty) return const [];
  return (jsonDecode(raw) as List).cast<String>();
}

/// Recently searched query strings, most-recent first. Backed by Hive box
/// `recent_searches` under key `terms`. Powers the chip row on the search screen.
@riverpod
class RecentSearchTerms extends _$RecentSearchTerms {
  Box<String> get _box => Hive.box<String>('recent_searches');

  @override
  List<String> build() => _decodeList(_box.get(_kRecentTermsKey));

  void add(String term) {
    final t = term.trim();
    if (t.isEmpty) return;
    final next = [t, ...state.where((e) => e.toLowerCase() != t.toLowerCase())].take(_kMaxRecentTerms).toList();
    _box.put(_kRecentTermsKey, jsonEncode(next));
    state = next;
  }

  void remove(String term) {
    final next = state.where((e) => e != term).toList();
    _box.put(_kRecentTermsKey, jsonEncode(next));
    state = next;
  }

  void clear() {
    _box.delete(_kRecentTermsKey);
    state = const [];
  }
}

/// Media IDs the user opened from search results, most-recent first. Backed by
/// Hive box `recent_searches` under key `media`.
@riverpod
class RecentSearchMedia extends _$RecentSearchMedia {
  Box<String> get _box => Hive.box<String>('recent_searches');

  @override
  List<String> build() => _decodeList(_box.get(_kRecentMediaKey));

  void add(String id) {
    final next = [id, ...state.where((e) => e != id)].take(_kMaxRecentMedia).toList();
    _box.put(_kRecentMediaKey, jsonEncode(next));
    state = next;
  }

  void clear() {
    _box.delete(_kRecentMediaKey);
    state = const [];
  }
}

@riverpod
Future<List<Media>> recentSearchContent(Ref ref) async {
  final ids = ref.watch(recentSearchMediaProvider);
  final list = await ref.watch(mediaProvider.future);
  final byId = {for (final m in list) m.id: m};
  return [for (final id in ids) if (byId[id] != null) byId[id]!];
}

// ── Library — saved ───────────────────────────────────────────────────────────

@riverpod
class Saved extends _$Saved {
  Box<bool> get _box => Hive.box<bool>('saved');

  @override
  Set<String> build() => _box.keys.cast<String>().toSet();

  void toggle(String id) {
    if (state.contains(id)) {
      _box.delete(id);
      state = Set.from(state)..remove(id);
    } else {
      _box.put(id, true);
      state = {...state, id};
    }
  }

  bool isSaved(String id) => state.contains(id);
}

@riverpod
Future<List<Media>> savedContent(Ref ref) async {
  final ids = ref.watch(savedProvider);
  final list = await ref.watch(mediaProvider.future);
  return list.where((m) => ids.contains(m.id)).toList();
}

// ── Library — recent ──────────────────────────────────────────────────────────

@riverpod
class Recent extends _$Recent {
  Box<WatchedItem> get _box => Hive.box<WatchedItem>('recent');

  @override
  List<WatchedItem> build() => _box.values.toList()..sort((a, b) => b.watchedAt.compareTo(a.watchedAt));

  void markWatched(String mediaId, {double progress = 0.0, String context = ''}) {
    final item = WatchedItem(
        contentId: mediaId,
        watchedAt: DateTime.now().toIso8601String(),
        progress: progress,
        context: context);
    _box.put(mediaId, item);
    state = [item, ...state.where((w) => w.contentId != mediaId)];
  }
}

@riverpod
Future<List<(WatchedItem, Media)>> recentContent(Ref ref) async {
  final recent = ref.watch(recentProvider);
  final list = await ref.watch(mediaProvider.future);
  final byId = {for (final m in list) m.id: m};
  final result = <(WatchedItem, Media)>[];
  for (final item in recent) {
    final media = byId[item.contentId];
    if (media != null) result.add((item, media));
  }
  return result;
}

// ── Library — downloads: see downloads_notifier.dart (re-exported above) ─────

// ── Requests ──────────────────────────────────────────────────────────────────

/// Distinct DJ names pulled from the cached media catalog (Hive). Used to power
/// the DJ autocomplete in the Agiza (requests) screen.
@riverpod
Future<List<String>> djNames(Ref ref) async {
  final list = await ref.watch(mediaProvider.future);
  final djs = list.map((m) => m.dj ?? '').where((d) => d.isNotEmpty).toSet().toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  return djs;
}

@riverpod
class Requests extends _$Requests {
  SupabaseClient get _db => Supabase.instance.client;

  @override
  Future<List<ContentRequest>> build() async {
    final rows = await _db.from('requests').select().order('created_at', ascending: false);
    return (rows as List)
        .map((e) => ContentRequest.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Inserts a new request into Supabase and prepends it to the local list.
  Future<void> submit({
    required String title,
    String note = '',
    String? type,
    String? dj,
  }) async {
    final draft = ContentRequest(id: '', title: title, note: note, type: type, dj: dj);
    final inserted = await _db.from('requests').insert(draft.toInsert()).select().single();
    final req = ContentRequest.fromJson(inserted);
    state = AsyncData([req, ...?state.value]);
  }
}
