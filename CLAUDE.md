# SINEMAX — Project Context for Claude Code

> Read this before touching any file. This is the single source of truth for the project state.

## STANDING INSTRUCTION — End-of-Session Wrap-up

When the conversation is clearly wrapping up (user says done, thanks, goodbye, or stops giving new tasks), output a ready-to-paste CLAUDE.md update block like this — **do not edit the file yourself, just print the block**:

```
CLAUDE.md UPDATE — paste into ## Current State and ## Session Log:

### Completed (add these)
- [x] ...

### Pending (add/remove these)
- [ ] ...

Session Log row:
| 2026-XX-XX | brief summary of what changed |
```

This costs zero extra tokens during the session. The user pastes it manually at the end.

---

## What This App Is

**Sinemax** — a streaming app for translated (dubbed) movies & series by Tanzanian/Kenyan DJs.
Flutter app, dark theme, fully local mock data (no backend yet).
Flutter package name is `kitabu`; display name is `SINEMAX`.

---

## Stack & Hard Rules

| Concern | Choice |
|---|---|
| State management | `flutter_riverpod ^3.3.1` — **manual only**, no code generation |
| Navigation | `go_router` — `StatefulShellRoute.indexedStack` for 5 tabs |
| Fonts | Barlow Condensed (display/headings) + DM Sans (body) via `google_fonts` |
| Icons | Custom SVG via `flutter_svg` `SvgPicture.string()` — see `lib/widgets/sinemax_icon.dart` |
| Video player | `chewie` + `video_player`, placeholder URL = BigBuckBunny MP4 |
| Animations | `flutter_animate` |
| Data | 100% local mock — `lib/data/local_data.dart` |

**NEVER use:** `@riverpod`, `@freezed`, `part` directives, `build_runner`, `json_serializable`, Supabase, `.env`.
Those packages stay in `pubspec.yaml` for future use but generate nothing now.

---

## Folder Structure

```
lib/
├── main.dart               # Entry: ProviderScope + system UI
├── app.dart                # GoRouter + SinemaxApp + _AppShell
├── theme/
│   └── app_theme.dart      # SinemaxColors, SinemaxTextStyles, buildSinemaxTheme()
├── models/
│   ├── content.dart        # Content, PosterPalette, HomeRow
│   ├── episode.dart        # Episode
│   ├── dj.dart             # Dj (with .initials getter)
│   ├── library_item.dart   # WatchedItem, DownloadItem
│   └── request.dart        # ContentRequest, RequestStatus enum + extension
├── data/
│   ├── local_data.dart     # All mock data: 28 titles, 12 DJs, 8 home rows, library, requests, profile
│   └── providers.dart      # All Riverpod providers
└── widgets/
    ├── sinemax_icon.dart    # SinemaxIcon widget (SVG string, 35 icons + filled nav variants)
    ├── bottom_nav_bar.dart  # SinemaxBottomNav — UNDERLINE variant, inline in Scaffold
    ├── poster_card.dart     # PosterCard — type badge top-left, centered glyph, DJ chip bottom, title+meta BELOW card
    ├── movie_card.dart      # MovieCard — horizontal list card
    └── section_header.dart  # SectionHeader — title + subtitle + "See All >" link
screens/
    ├── splash_screen.dart   # Pulse animation (flutter_animate), auto-nav to /home after 2.8s
    ├── home_screen.dart     # SX badge + search bar app bar; hero: MOST WATCHED badge + Watch/+ buttons; 8 home rows
    ├── discover_screen.dart # Filter chips (year/type/country/DJ) + 3-col grid
    ├── search_screen.dart   # Auto-focus search, results grid
    ├── detail_screen.dart   # Fixed zone: player + Download/Save/Share buttons; scrollable: info + sticky episodes header (SliverAppBar pinned) + expand/collapse (horizontal cards ↔ vertical list) + RELATED
    ├── requests_screen.dart # Request form + history list
    ├── library_screen.dart  # 3 tabs: Recent / Saved / Downloads
    └── profile_screen.dart  # Avatar + stats + subscription + settings
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

## Key Providers (lib/data/providers.dart)

```dart
catalogProvider           // Provider<List<Content>>  — read-only
djsProvider               // Provider<List<Dj>>
homeRowsProvider          // Provider<List<HomeRow>>
featuredProvider          // Provider<Content?> — featured = 'ks2' (Throne of Shadows)
discoverFiltersProvider   // NotifierProvider<DiscoverNotifier, DiscoverFilters>
discoverResultsProvider   // Provider<List<Content>> — derived from filters
searchQueryProvider       // NotifierProvider<SearchNotifier, String>
searchResultsProvider     // Provider<List<Content>>
savedProvider             // NotifierProvider<SavedNotifier, List<String>>
savedContentProvider      // Provider<List<Content>>
recentProvider            // NotifierProvider<RecentNotifier, List<WatchedItem>>
downloadsProvider         // NotifierProvider<DownloadsNotifier, List<DownloadItem>>
requestsProvider          // NotifierProvider<RequestsNotifier, List<ContentRequest>>
```

---

## Mock Data Summary (lib/data/local_data.dart)

- **12 DJs**: dj-afande, dj-kibinda, dj-mzee, dj-salama, dj-honest, dj-pamoja, dj-rocky, dj-nash, dj-tamaa, dj-boss, dj-cartoon, dj-malkia
- **28 content items**: ks1–ks6 (Korean series), is1–is4 (Indian series), ts1–ts2 (Turkish series), km1–km4 (Korean movies), im1–im2 (Indian movies), bm1–bm6 (Bongo movies), hw1–hw4 (Hollywood)
- Featured: `featuredId = 'ks2'`
- Library: 6 recent watches, 9 saved IDs, 5 downloads
- 3 request history items
- Profile: Amani Mushi, Premium plan

Lookup helpers: `contentById(id)`, `djById(id)`, `contentWhere(fn)`

---

## Design Source Files (READ-ONLY reference)

```
sinemax app ui/
├── data.js              # Full mock data (already ported to local_data.dart)
├── sinemax-parts.jsx    # Component designs — bottom nav variants (underline selected)
├── sinemax-icons.jsx    # SVG icon paths (already ported to sinemax_icon.dart)
└── tweaks-panel.jsx     # Design tweaks — inline nav, pulse splash
```

---

## Theme Quick Reference

```dart
SinemaxColors.bg        // #050D1A  — main background
SinemaxColors.bg2       // #0A1628  — nav bar background
SinemaxColors.panel     // #0E1D33  — cards
SinemaxColors.panel2    // #11233D  — chip backgrounds
SinemaxColors.blue      // #2D8EFF  — primary accent
SinemaxColors.muted     // #8FA6C8  — secondary text
SinemaxColors.muted2    // #5E7298  — tertiary text
SinemaxColors.gold      // #F4C13B  — star ratings
SinemaxColors.teal      // #22D3A6  — success/added status
SinemaxColors.red       // #FF5D7A  — danger/logout
SinemaxColors.purple    // #7C5CFF  — secondary accent

SinemaxTextStyles.display(size, weight, color)  // Barlow Condensed
SinemaxTextStyles.body(size, weight, color)     // DM Sans
```

---

## Current State

**Last updated: 2026-06-06**

### Completed
- [x] `pubspec.yaml` — all dependencies added (video_player, chewie, flutter_riverpod ^3.3.1, go_router, flutter_animate, flutter_svg, google_fonts, skeletonizer, etc.)
- [x] All model files
- [x] `lib/data/local_data.dart` — full mock data
- [x] `lib/data/providers.dart` — all Riverpod providers
- [x] All 5 widgets
- [x] All 8 screens (splash, home, discover, search, detail, requests, library, profile)
- [x] `lib/main.dart` + `lib/app.dart`
- [x] `flutter analyze` — **0 issues**
- [x] **UI redesign pass** — `poster_card`, `section_header`, `home_screen`, `detail_screen` updated to match design photos
- [x] `lib/widgets/poster_card.dart` — redesigned: SERIES/MOVIE type badge, centered glyph, DJ name chip inside card; title + year · country · rating rendered below card
- [x] `lib/widgets/section_header.dart` — "See All >" label (was "See all")
- [x] `lib/screens/home_screen.dart` — new app bar (SX badge + tappable search bar + blue search button); featured hero shows "MOST WATCHED THIS WEEK" star badge, year·genre·DJname meta line, pill Watch button + circular "+" button; rows show "See All >"
- [x] `lib/screens/detail_screen.dart` — fixed top zone (player + Download/Save/Share action buttons); scrollable zone with `MediaQuery.removePadding(removeTop:true)` + `CustomScrollView`; episodes header uses `SliverAppBar(pinned:true)` to stick below fixed zone; Expand/Collapse toggles horizontal card scroll ↔ full-width vertical episode list; RELATED section hidden when episodes expanded; `_EpisodesHeader`, `_EpisodeRow`, `_EpisodeCard`, `_ActionBtn` private widgets

### Pending / Requested Modifications
- [ ] *(add user-requested changes here after each session)*

---

## Session Log

| Date | Summary |
|---|---|
| 2026-06-05 | Initial build — full app scaffolded: models, data, providers, 5 widgets, 8 screens, router, theme |
| 2026-06-06 | Set up CLAUDE.md auto-update system |
| 2026-06-06 | UI redesign: poster cards, home screen app bar + hero, detail screen fixed/scroll layout, sticky episodes header, expand/collapse episode list |
