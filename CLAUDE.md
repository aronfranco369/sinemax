# SINEMAX — Project Context for Claude Code

> Read this before touching any file. This is the single source of truth for the project state.

## STANDING INSTRUCTION — End-of-Session Wrap-up

When the user explicitly passes an update prompt (e.g. "update the md"), **directly edit this file** — update `## Current State` and append a row to `## Session Log`. Do not print a paste block.

---

## What This App Is

**Sinemax** — a streaming app for translated (dubbed) movies & series by Tanzanian DJs.
Flutter app, dark theme, Supabase backend, Hive for local persistence.
Flutter package name is `sinemax`; display name is `SINEMAX`.

---

## Stack

| Concern | Choice |
|---|---|
| State management | `flutter_riverpod ^3.3.1` + `riverpod_annotation ^4.0.2` — `@riverpod` code generation via `build_runner` |
| Navigation | `go_router ^17.2.3` — `StatefulShellRoute.indexedStack` for 5 tabs |
| Backend | `supabase_flutter ^2.12.4` — tables: `media`, `files`; Supabase Realtime subscriptions active |
| Local persistence | `hive_ce ^2.16.0` + `hive_ce_flutter ^2.2.0` — Hive used as an offline cache for media + files, plus library boxes |
| Models | `freezed_annotation ^3.1.0` + `json_annotation ^4.9.0` — `@freezed` on `Media`, `MediaFile`, `DiscoverFilter` |
| Skeletons | `skeletonizer ^2.1.3` — shimmer placeholders for home + detail screens |
| Fonts | Barlow Condensed (display/headings) + DM Sans (body) via `google_fonts` |
| Icons | Custom SVG via `flutter_svg` — see `lib/widgets/sinemax_icon.dart` |
| Images | `cached_network_image_ce ^4.1.0` — `CachedNetworkImage` throughout |
| Video player | `chewie ^1.8.5` + `video_player ^2.9.2`; loads URL from `files` table; fallback = BigBuckBunny MP4 |
| Animations | `flutter_animate ^4.5.2` |
| Config | `flutter_dotenv ^5.2.1` — `.env` file with `SUPABASE_URL` + `SUPABASE_ANON_KEY` |

**Code generation is active and required.** After any model/provider/Hive changes run:
```
dart run build_runner build --delete-conflicting-outputs
```

Generated files (do not edit manually):
- `lib/data/providers.g.dart`
- `lib/data/media_notifier.g.dart`
- `lib/data/files_notifier.g.dart`
- `lib/models/media.freezed.dart` + `media.g.dart`
- `lib/models/discover_filter.freezed.dart`
- `lib/models/library_item.g.dart`
- `lib/hive_registrar.g.dart`

---

## Folder Structure

```
lib/
├── main.dart               # Entry: dotenv + Supabase.initialize + Hive init + manual adapter registration + ProviderScope
├── app.dart                # GoRouter + SinemaxApp + _AppShell (PopScope + back-nav logic)
├── theme/
│   └── app_theme.dart      # SinemaxColors, SinemaxTextStyles, buildSinemaxTheme()
├── models/
│   ├── media.dart          # Media (@freezed @HiveType typeId:2), MediaFile (@freezed @HiveType typeId:3), HomeRow (plain class)
│   ├── discover_filter.dart # DiscoverFilter (@freezed) + DiscoverFilterX extension
│   ├── library_item.dart   # WatchedItem (@HiveType typeId:0), DownloadItem (@HiveType typeId:1)
│   └── request.dart        # ContentRequest (plain), RequestStatus enum + extension
├── data/
│   ├── media_notifier.dart # MediaNotifier (@riverpod AsyncNotifier) — Hive cache + Supabase fetch + Realtime
│   ├── files_notifier.dart # FilesNotifier (@riverpod AsyncNotifier) — lazy per-media fetch + Realtime
│   └── providers.dart      # All other @riverpod providers; exports mediaProvider + filesProvider
├── utils/
│   └── row_labels.dart     # kRowLabels — Swahili display names for home section rows (keyed by "country type")
└── widgets/
    ├── sinemax_icon.dart    # SinemaxIcon widget (inline SVG string icons)
    ├── bottom_nav_bar.dart  # SinemaxBottomNav — UNDERLINE variant
    ├── poster_card.dart     # PosterCard — notch-clipped image, DJ badge top-right, type badge top-left, title+meta below
    ├── movie_card.dart      # MovieCard — horizontal list row with mini poster + progress bar
    ├── section_header.dart  # SectionHeader — title + "See All >" link
    ├── sinemax_search_bar.dart # SinemaxSearchBar — tappable bar that pushes /search
    ├── action_btn.dart      # ActionBtn — icon + label button used in detail screen (Download/Save/Share)
    ├── info_chip.dart       # InfoChip — small pill chip for metadata display
    ├── player_loading_view.dart # PlayerLoadingView — blurred poster + spinner shown while video initializes
    ├── detail_skeleton.dart # DetailSkeleton (full page), EpisodesSkeleton, RelatedSkeleton — skeletonizer-based
    └── home_skeleton.dart   # HomeTrendingSkeleton, HomeRowsSkeleton — skeletonizer-based
screens/
    ├── splash_screen.dart   # Pulse + shimmer animation (flutter_animate), auto-nav to /home after 2.8s
    ├── home_screen.dart     # SX badge + search bar app bar; trending carousel (trendingMediaProvider) + category rows (homeRowsProvider)
    ├── discover_screen.dart # Filter chips (year/type/country/DJ) via bottom-sheet picker + 3-col grid
    ├── search_screen.dart   # Auto-focus search, async results grid
    ├── detail_screen.dart   # Fixed zone: player + Download/Save/Share; scrollable: info chips + sticky episodes + expand/collapse + RELATED
    ├── requests_screen.dart # Request form (title + notes) + in-memory history list
    ├── library_screen.dart  # Pill tab bar: Recent / Saved / Downloads (all Hive-backed)
    └── profile_screen.dart  # Avatar card + live stats + subscription card + settings tiles + logout
```

---

## Routes

| Path | Screen | Notes |
|---|---|---|
| `/splash` | SplashScreen | Initial route, redirects to `/home` |
| `/home` | HomeScreen | Tab 0 |
| `/discover` | DiscoverScreen | Tab 1 |
| `/requests` | RequestsScreen | Tab 2 |
| `/library` | LibraryScreen | Tab 3 |
| `/profile` | ProfileScreen | Tab 4 |
| `/detail/:id` | DetailScreen | Full route push (NOT modal) |
| `/search` | SearchScreen | Full route push |

---

## Data Architecture

### Caching strategy
- `MediaNotifier` owns all `Media` objects. On first launch it blocks on a full Supabase fetch and stores every row in Hive box `media_cache` (Box<Media>). Subsequent cold starts use the Hive cache immediately and refresh in the background if older than 24 h.
- `FilesNotifier` starts empty. Files are fetched lazily per media via `ensureLoaded(mediaId)`, stored in `files_cache` (Box<MediaFile>), and a `files_fetched` box (Box<bool>) tracks which media IDs have been cached.
- Both notifiers subscribe to Supabase Realtime (`PostgresChangeEvent.all`) and apply incremental updates to Hive, which triggers a Hive `watch()` listener that refreshes provider state.

### Hive boxes opened at startup (main.dart)
| Box name | Type | Purpose |
|---|---|---|
| `saved` | `Box<bool>` | Saved media IDs |
| `recent` | `Box<WatchedItem>` | Watch history |
| `downloads` | `Box<DownloadItem>` | Downloaded items |
| `media_cache` | `Box<Media>` | Supabase media cache |
| `files_cache` | `Box<MediaFile>` | Supabase files cache |
| `files_fetched` | `Box<bool>` | Per-mediaId fetch flag |
| `metadata` | `Box<String>` | Sync timestamps (key: `media_last_synced`) |

---

## Key Providers (lib/data/)

```dart
// ── Core notifiers (media_notifier.dart / files_notifier.dart) ──────────────
mediaProvider              // AsyncNotifierProvider — all Media; Hive-cached, Realtime-updated
filesProvider              // AsyncNotifierProvider — all MediaFile; lazy loaded, Realtime-updated

// ── Catalog (providers.dart) ────────────────────────────────────────────────
mediaByIdProvider(id)      // FutureProvider<Media?> — lookup from mediaProvider
homeRowsProvider           // FutureProvider<List<HomeRow>> — groups by country, sorted by view_count
trendingMediaProvider      // FutureProvider<List<Media>> — top 5 by view_count (plain FutureProvider)
mediaFilesProvider(id)     // FutureProvider<List<MediaFile>> — triggers ensureLoaded, watches filesProvider
relatedMediaProvider(id)   // FutureProvider<List<Media>> — same country or genre, max 6

// ── Filter options (derived from catalog) ───────────────────────────────────
filterYearsProvider        // FutureProvider<List<String>>
filterDjsProvider          // FutureProvider<List<String>>
filterCountriesProvider    // FutureProvider<List<String>>

// ── Discover ────────────────────────────────────────────────────────────────
discoverFiltersProvider    // NotifierProvider<DiscoverFilters, DiscoverFilter>
discoverResultsProvider    // FutureProvider<List<Media>>

// ── Search ──────────────────────────────────────────────────────────────────
searchQueryProvider        // NotifierProvider<SearchQuery, String>
searchResultsProvider      // FutureProvider<List<Media>>

// ── Library (Hive-backed, synchronous state) ────────────────────────────────
savedProvider              // NotifierProvider<Saved, Set<String>>    — box: 'saved'
savedContentProvider       // FutureProvider<List<Media>>
recentProvider             // NotifierProvider<Recent, List<WatchedItem>> — box: 'recent'
recentContentProvider      // FutureProvider<List<(WatchedItem, Media)>>
downloadsProvider          // NotifierProvider<Downloads, List<DownloadItem>> — box: 'downloads'
downloadsContentProvider   // FutureProvider<List<(DownloadItem, Media)>>

// ── Requests (in-memory, not persisted) ─────────────────────────────────────
requestsProvider           // NotifierProvider<Requests, List<ContentRequest>>
```

---

## Supabase Schema

| Table | Key columns |
|---|---|
| `media` | `id`, `title`, `poster_url`, `description`, `country`, `year`, `type` ('movie'/'series'), `genres` (array), `tags` (array), `dj`, `view_count`, `download_count` |
| `files` | `id`, `media_id`, `season`, `label`, `download_url`, `episode_number`, `created_at` |

---

## Reserved TODOs in detail_screen.dart — DO NOT IMPLEMENT/REMOVE

These TODOs are intentionally left for a future session. Never implement or delete them unless the user explicitly asks:

1. Increment `view_count` on Supabase after player initializes (`_loadAndInitPlayer`).
2. Restore saved playback position from Hive box `watch_progress` after player initializes.

---

## Theme Quick Reference

```dart
SinemaxColors.bg         // #050D1A  — main background
SinemaxColors.bg2        // #0A1628  — nav bar background
SinemaxColors.panel      // #0E1D33  — cards
SinemaxColors.panel2     // #11233D  — chip backgrounds
SinemaxColors.line       // rgba(120,160,220, 0.14) — subtle borders
SinemaxColors.line2      // rgba(120,160,220, 0.26) — stronger borders
SinemaxColors.blue       // #2D8EFF  — primary accent
SinemaxColors.blueBright // #19C3FB  — gradient highlight
SinemaxColors.blueDeep   // #1A6FE8  — pressed state
SinemaxColors.ink        // #EAF2FF  — primary text (default color)
SinemaxColors.muted      // #8FA6C8  — secondary text
SinemaxColors.muted2     // #5E7298  — tertiary text
SinemaxColors.gold       // #F4C13B  — star ratings / premium crown
SinemaxColors.teal       // #22D3A6  — success / added status
SinemaxColors.red        // #FF5D7A  — danger / logout
SinemaxColors.orange     // #FF8A3D  — warning
SinemaxColors.purple     // #7C5CFF  — secondary accent

SinemaxTextStyles.display(size, weight, color)  // Barlow Condensed
SinemaxTextStyles.body(size, weight, color)     // DM Sans
```

---

## Design Source Files (READ-ONLY reference)

```
sinemax app ui/
├── data.js              # Full mock data (reference only — real data now in Supabase)
├── sinemax-parts.jsx    # Component designs — bottom nav variants (underline selected)
├── sinemax-icons.jsx    # SVG icon paths (already ported to sinemax_icon.dart)
└── tweaks-panel.jsx     # Design tweaks — inline nav, pulse splash
```

---

## Current State

**Last updated: 2026-06-09**

### Completed
- [x] `pubspec.yaml` — full dependency set including `skeletonizer`
- [x] All model files (`media.dart`, `discover_filter.dart`, `library_item.dart`, `request.dart`) — `@freezed` + `@HiveType` active
- [x] `lib/data/media_notifier.dart` — Hive-first caching, 24h background refresh, Supabase Realtime
- [x] `lib/data/files_notifier.dart` — lazy per-media fetch via `ensureLoaded`, Realtime
- [x] `lib/data/providers.dart` — all remaining @riverpod providers; exports both notifiers
- [x] `lib/utils/row_labels.dart` — Swahili display names for home rows
- [x] All 5 original widgets (`sinemax_icon`, `bottom_nav_bar`, `poster_card`, `movie_card`, `section_header`)
- [x] New widgets: `action_btn`, `info_chip`, `player_loading_view`, `detail_skeleton`, `home_skeleton`
- [x] All 8 screens
- [x] `lib/main.dart` — Hive boxes for media cache + files cache + library; manual adapter registration
- [x] `lib/app.dart` — GoRouter + _AppShell
- [x] Code generation fully active (`@riverpod`, `@freezed`, `@HiveType`); all `.g.dart` / `.freezed.dart` files committed

### Pending / Requested Modifications
- [ ] *(add user-requested changes here after each session)*

---

## Session Log

| Date | Summary |
|---|---|
| 2026-06-05 | Initial build — full app scaffolded: models, data, providers, 5 widgets, 8 screens, router, theme |
| 2026-06-06 | Set up CLAUDE.md auto-update system |
| 2026-06-06 | UI redesign: poster cards, home screen app bar + hero, detail screen fixed/scroll layout, sticky episodes header, expand/collapse episode list |
| 2026-06-08 | Major backend migration: replaced local mock data with Supabase; new Media/MediaFile freezed models; @riverpod code generation; Hive persistence for library; expanded theme colors |
| 2026-06-09 | Refactored data layer: split MediaNotifier + FilesNotifier into own files with Hive caching + Realtime; added skeletonizer; new widgets (action_btn, info_chip, player_loading_view, detail_skeleton, home_skeleton); utils/row_labels.dart for Swahili section names |
