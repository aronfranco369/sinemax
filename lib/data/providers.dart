import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/discover_filter.dart';
import '../models/library_item.dart';
import '../models/media.dart';
import '../models/request.dart';
import '../utils/row_labels.dart';

part 'providers.g.dart';

SupabaseClient get _db => Supabase.instance.client;

// ── Catalog ───────────────────────────────────────────────────────────────────

@riverpod
Future<List<Media>> catalog(Ref ref) async {
  final data = await _db.from('media').select().order('title');
  return (data as List).map((row) => Media.fromJson(row as Map<String, dynamic>)).toList();
}

@riverpod
Future<Media?> mediaById(Ref ref, String id) async {
  final list = await ref.watch(catalogProvider.future);
  try {
    return list.firstWhere((m) => m.id == id);
  } catch (_) {
    return null;
  }
}

@riverpod
Future<List<HomeRow>> homeRows(Ref ref) async {
  final list = await ref.watch(catalogProvider.future);
  final Map<String, List<Media>> groups = {};
  for (final m in list) {
    final country = m.countryDisplay;
    if (country.isEmpty) continue;
    final key = '${country.toUpperCase()} ${m.isSeries ? 'SERIES' : 'MOVIES'}';
    groups.putIfAbsent(key, () => []).add(m);
  }
  return (groups.entries.where((e) => e.value.length >= 2).map((e) {
    final lookupKey = e.key.toLowerCase();
    final title = (kRowLabels[lookupKey]?.isNotEmpty == true) ? kRowLabels[lookupKey]! : e.key;
    return HomeRow(id: e.key.toLowerCase().replaceAll(' ', '-'), title: title, items: e.value);
  }).toList()
    ..sort((a, b) => b.items.length.compareTo(a.items.length)));
}

@riverpod
Future<List<MediaFile>> mediaFiles(Ref ref, String mediaId) async {
  final data = await _db.from('files').select().eq('media_id', mediaId).order('episode_number', ascending: true, nullsFirst: false).order('label', ascending: true, nullsFirst: false);
  return (data as List).map((row) => MediaFile.fromJson(row as Map<String, dynamic>)).toList();
}

final trendingMediaProvider = FutureProvider<List<Media>>((ref) async {
  final list = await ref.watch(catalogProvider.future);
  final withViews = list.where((m) => m.viewCount > 0).toList()
    ..sort((a, b) => b.viewCount.compareTo(a.viewCount));
  return withViews.take(5).toList();
});

@riverpod
Future<List<Media>> relatedMedia(Ref ref, String mediaId) async {
  final list = await ref.watch(catalogProvider.future);
  try {
    final media = list.firstWhere((m) => m.id == mediaId);
    return list.where((m) => m.id != mediaId && (m.country == media.country || (m.genres.isNotEmpty && media.genres.isNotEmpty && m.genres.first == media.genres.first))).take(6).toList();
  } catch (_) {
    return [];
  }
}

// ── Filter options ────────────────────────────────────────────────────────────

@riverpod
Future<List<String>> filterYears(Ref ref) async {
  final list = await ref.watch(catalogProvider.future);
  final years = list.map((m) => m.year?.toString() ?? '').where((y) => y.isNotEmpty).toSet().toList()..sort((a, b) => b.compareTo(a));
  return ['All', ...years];
}

@riverpod
Future<List<String>> filterDjs(Ref ref) async {
  final list = await ref.watch(catalogProvider.future);
  final djs = list.map((m) => m.dj ?? '').where((d) => d.isNotEmpty).toSet().toList()..sort();
  return ['All', ...djs];
}

@riverpod
Future<List<String>> filterCountries(Ref ref) async {
  final list = await ref.watch(catalogProvider.future);
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
  final list = await ref.watch(catalogProvider.future);
  final filters = ref.watch(discoverFiltersProvider);
  if (filters.isDefault) return list;
  return list.where((m) {
    if (filters.year != 'All' && m.year?.toString() != filters.year) return false;
    if (filters.dj != 'All' && m.dj != filters.dj) return false;
    if (filters.country != 'All' && m.countryDisplay != filters.country) return false;
    if (filters.type != 'All') {
      if (filters.type == 'Series' && !m.isSeries) return false;
      if (filters.type == 'Movie' && m.isSeries) return false;
    }
    return true;
  }).toList();
}

// ── Search ────────────────────────────────────────────────────────────────────

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';
  void set(String q) => state = q;
  void clear() => state = '';
}

@riverpod
Future<List<Media>> searchResults(Ref ref) async {
  final q = ref.watch(searchQueryProvider).trim().toLowerCase();
  if (q.isEmpty) return [];
  final list = await ref.watch(catalogProvider.future);
  return list.where((m) {
    return m.title.toLowerCase().contains(q) || m.genres.any((g) => g.toLowerCase().contains(q)) || m.countryDisplay.toLowerCase().contains(q) || (m.dj?.toLowerCase().contains(q) ?? false);
  }).toList();
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
  final list = await ref.watch(catalogProvider.future);
  return list.where((m) => ids.contains(m.id)).toList();
}

// ── Library — recent ──────────────────────────────────────────────────────────

@riverpod
class Recent extends _$Recent {
  Box<WatchedItem> get _box => Hive.box<WatchedItem>('recent');

  @override
  List<WatchedItem> build() => _box.values.toList()..sort((a, b) => b.watchedAt.compareTo(a.watchedAt));

  void markWatched(String mediaId, {double progress = 0.0, String context = ''}) {
    final item = WatchedItem(contentId: mediaId, watchedAt: DateTime.now().toIso8601String(), progress: progress, context: context);
    _box.put(mediaId, item);
    state = [item, ...state.where((w) => w.contentId != mediaId)];
  }
}

@riverpod
Future<List<(WatchedItem, Media)>> recentContent(Ref ref) async {
  final recent = ref.watch(recentProvider);
  final list = await ref.watch(catalogProvider.future);
  final byId = {for (final m in list) m.id: m};
  final result = <(WatchedItem, Media)>[];
  for (final item in recent) {
    final media = byId[item.contentId];
    if (media != null) result.add((item, media));
  }
  return result;
}

// ── Library — downloads ───────────────────────────────────────────────────────

@riverpod
class Downloads extends _$Downloads {
  Box<DownloadItem> get _box => Hive.box<DownloadItem>('downloads');

  @override
  List<DownloadItem> build() => _box.values.toList();

  void add(String mediaId, {String quality = 'HD', String size = '—'}) {
    final item = DownloadItem(contentId: mediaId, quality: quality, size: size, at: DateTime.now().toIso8601String());
    _box.put(mediaId, item);
    state = [item, ...state.where((d) => d.contentId != mediaId)];
  }

  void remove(String mediaId) {
    _box.delete(mediaId);
    state = state.where((d) => d.contentId != mediaId).toList();
  }
}

@riverpod
Future<List<(DownloadItem, Media)>> downloadsContent(Ref ref) async {
  final dls = ref.watch(downloadsProvider);
  final list = await ref.watch(catalogProvider.future);
  final byId = {for (final m in list) m.id: m};
  final result = <(DownloadItem, Media)>[];
  for (final dl in dls) {
    final media = byId[dl.contentId];
    if (media != null) result.add((dl, media));
  }
  return result;
}

// ── Requests ──────────────────────────────────────────────────────────────────

@riverpod
class Requests extends _$Requests {
  @override
  List<ContentRequest> build() => [];

  void add(String title, String note) {
    final id = 'r${DateTime.now().millisecondsSinceEpoch}';
    state = [ContentRequest(id: id, title: title, note: note, status: RequestStatus.pending, date: _today()), ...state];
  }

  String _today() {
    final now = DateTime.now();
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[now.month - 1]} ${now.day}';
  }
}
