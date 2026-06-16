# SINEMAX — Project Context for Claude Code

> **READ THIS FILE FIRST, every session, before any search or edit.** It is the single source of
> truth and is kept current. Use the **Fast Navigation Index** below to jump straight to the right
> file (and often the right line) instead of grepping — that is the whole point of this document.
> Only fall back to Grep/Glob when the index doesn't cover what you need, then update the index.

---

## STANDING INSTRUCTION — End-of-Session Wrap-up

When the user explicitly passes an update prompt (e.g. "update the md"), **directly edit this file** —
refresh `## Current State`, the Fast Navigation Index if files/symbols moved, and append a row to
`## Session Log`. Do not print a paste block. Keep it dense and accurate, not verbose; this file is
loaded into context every session, so stale or bloated content costs tokens on every run.

---

## What This App Is

**Sinemax** — a streaming app for translated (dubbed) movies & series by Tanzanian DJs.
Flutter app, dark theme, Supabase backend, Hive local persistence, offline encrypted downloads,
device-identity subscriptions (mobile money), FCM new-content notifications.
Flutter package name is `sinemax`; display name is `SINEMAX`. UI copy is Swahili-leaning.

---

## Fast Navigation Index

**"Where do I change X?" — find the row, open that file. Line numbers drift; symbols don't.**

### Subsystems → owning file
| If the task touches… | Go to | Notes |
|---|---|---|
| App entry / Hive boxes / adapter registration / init order | [main.dart](lib/main.dart) | boxes opened here; `DownloadEngine.init()` after Hive |
| Routes / shell / back-nav / global offline overlay | [app.dart](lib/app.dart) | `appRouter`, `_AppShell`, `ConnectivityOverlay` builder |
| Catalog data (all Media) | [media_notifier.dart](lib/data/media_notifier.dart) | Hive-first cache + 24h refresh + Realtime |
| Per-media files (episodes/parts) | [files_notifier.dart](lib/data/files_notifier.dart) | lazy `ensureLoaded(mediaId)` + Realtime |
| Derived providers (home/trending/discover/search/library) | [providers.dart](lib/data/providers.dart) | re-exports the notifiers below |
| **Offline downloads + AES encryption + loopback player server** | [download_engine.dart](lib/data/download_engine.dart) | singleton; the heavy logic lives here |
| Downloads UI state / user actions (start/pause/cancel) | [downloads_notifier.dart](lib/data/downloads_notifier.dart) | thin wrapper over `DownloadEngine` |
| Online/offline detection | [connectivity_notifier.dart](lib/data/connectivity_notifier.dart) | TCP probe to 1.1.1.1/8.8.8.8 |
| **Subscriptions / entitlement / phone normalize / restore** | [subscription_notifier.dart](lib/data/subscription_notifier.dart) | hand-written (not codegen); tables `profiles`+`subscriptions` |
| Push notifications + deep linking | [fcm_service.dart](lib/data/fcm_service.dart) | `pendingNotificationMediaId`, `/detail/:id?autoplay=1` |
| Colors / text styles / theme | [app_theme.dart](lib/theme/app_theme.dart) | see Theme Quick Reference |
| Swahili home-row labels | [row_labels.dart](lib/utils/row_labels.dart) | `kRowLabels`, keyed `"country type"` |

### Models → file (+ Hive typeId)
| Model | File | typeId |
|---|---|---|
| `Media` (`@freezed`+Hive), `MediaFile` (Hive), `HomeRow` (plain), `sizeDisplay` getter | [media.dart](lib/models/media.dart) | 2 / 3 |
| `WatchedItem` (Hive) | [library_item.dart](lib/models/library_item.dart) | 0 |
| `DownloadRecord` (Hive) + `DownloadStatus` enum | [library_item.dart](lib/models/library_item.dart) | 4 |
| `DiscoverFilter` (`@freezed`) + `DiscoverFilterX` | [discover_filter.dart](lib/models/discover_filter.dart) | — |
| `ContentRequest` (plain) + `RequestStatus` | [request.dart](lib/models/request.dart) | — |
> typeId **1 is retired** (old `DownloadItem`). Do not reuse it.

### Screens → file (tab index)
| Screen | File | Tab |
|---|---|---|
| Splash (consumes `pendingNotificationMediaId`, auto-nav `/home`) | [splash_screen.dart](lib/screens/splash_screen.dart) | — |
| Home (trending carousel + country rows) | [home_screen.dart](lib/screens/home_screen.dart) | 0 |
| Discover (filter chips + 3-col grid) | [discover_screen.dart](lib/screens/discover_screen.dart) | 1 |
| Requests (form + history) | [requests_screen.dart](lib/screens/requests_screen.dart) | 2 |
| Library (Recent / Saved / Downloads pill tabs) | [library_screen.dart](lib/screens/library_screen.dart) | 3 |
| Profile (stats + subscription card + settings) | [profile_screen.dart](lib/screens/profile_screen.dart) | 4 |
| Detail (fixed player zone + scrollable info/episodes/related) | [detail_screen.dart](lib/screens/detail_screen.dart) | push |
| Search (autofocus, history, results grid) | [search_screen.dart](lib/screens/search_screen.dart) | push |

### Widgets → file
| Widget | File |
|---|---|
| `SinemaxIcon` (inline SVG) | [sinemax_icon.dart](lib/widgets/sinemax_icon.dart) |
| `SinemaxBottomNav` (underline) | [bottom_nav_bar.dart](lib/widgets/bottom_nav_bar.dart) |
| `PosterCard` / `MovieCard` | [poster_card.dart](lib/widgets/poster_card.dart) · [movie_card.dart](lib/widgets/movie_card.dart) |
| `SectionHeader` / `SinemaxSearchBar` / `InfoChip` / `ActionBtn` | [section_header.dart](lib/widgets/section_header.dart) · [sinemax_search_bar.dart](lib/widgets/sinemax_search_bar.dart) · [info_chip.dart](lib/widgets/info_chip.dart) · [action_btn.dart](lib/widgets/action_btn.dart) |
| `DownloadActionBtn` + per-file download controls | [download_controls.dart](lib/widgets/download_controls.dart) |
| `ConnectivityOverlay` (offline/online toast) | [offline_banner.dart](lib/widgets/offline_banner.dart) |
| `RipplePlayButton` (idle "tap to play" affordance) | [ripple_play_button.dart](lib/widgets/ripple_play_button.dart) |
| `PlayerLoadingView` (blurred poster + spinner) | [player_loading_view.dart](lib/widgets/player_loading_view.dart) |
| `DetailSkeleton`/`EpisodesSkeleton`/`RelatedSkeleton` · `HomeTrendingSkeleton`/`HomeRowsSkeleton` | [detail_skeleton.dart](lib/widgets/detail_skeleton.dart) · [home_skeleton.dart](lib/widgets/home_skeleton.dart) |

---

## Stack

| Concern | Choice |
|---|---|
| State | `flutter_riverpod ^3.3.1` + `riverpod_annotation ^4.0.2` — `@riverpod` codegen via `build_runner` |
| Navigation | `go_router ^17.2.3` — `StatefulShellRoute.indexedStack`, 5 tabs |
| Backend | `supabase_flutter ^2.12.4` — tables `media`, `files`, `profiles`, `subscriptions`; Realtime active |
| Local persistence | `hive_ce ^2.16.0` + `hive_ce_flutter ^2.2.0` |
| Models | `freezed_annotation ^3.1.0` + `json_annotation ^4.9.0` |
| Skeletons | `skeletonizer ^2.1.3` |
| Fonts / Icons / Images | Barlow Condensed + DM Sans via `google_fonts ^6.2.1`; `flutter_svg ^2.3.0` + `font_awesome_flutter ^11.0.0`; `cached_network_image_ce ^4.1.0` |
| Video | `chewie ^1.8.5` + `video_player ^2.9.2` |
| Animations | `flutter_animate ^4.5.2` · expandable text `readmore ^3.0.0` |
| Notifications | `firebase_core ^4.10.0` + `firebase_messaging ^16.3.0` + `flutter_local_notifications ^19.4.2` |
| Offline downloads | `background_downloader ^9.2.0` (native bg) + `pointycastle ^3.9.1` (AES) + `flutter_secure_storage ^9.2.4` (key) + `path_provider ^2.1.5` + `disk_space_plus ^0.2.6` |
| Connectivity | `connectivity_plus ^7.1.1` |
| Misc | `flutter_dotenv ^5.2.1` (`.env`: `SUPABASE_URL`, `SUPABASE_ANON_KEY`), `url_launcher`, `path_drawing` |

**Codegen is required.** After any model/`@riverpod`/Hive change run:
```
dart run build_runner build --delete-conflicting-outputs
```
Generated (never edit by hand): `lib/data/{providers,media_notifier,files_notifier,downloads_notifier,connectivity_notifier}.g.dart`,
`lib/models/media.{freezed,g}.dart`, `lib/models/discover_filter.freezed.dart`, `lib/models/library_item.g.dart`, `lib/hive_registrar.g.dart`.
> Note: `subscription_notifier.dart` is **hand-written** (`AsyncNotifierProvider`, no codegen).

---

## Routes

| Path | Screen | Notes |
|---|---|---|
| `/splash` | SplashScreen | initial; redirects to `/home` (or deep-link target) |
| `/home` `/discover` `/requests` `/library` `/profile` | tabs 0–4 | inside `StatefulShellRoute` |
| `/detail/:id` | DetailScreen | push. Query: `?autoplay=1` (play-this surfaces), `?file=<MediaFile id>` (deep-link episode) |
| `/search` | SearchScreen | push |

---

## Data Architecture

### Caching
- **`MediaNotifier`** owns all `Media`. First launch blocks on a full Supabase fetch → stores every row
  in Hive `media_cache`. Cold starts use the cache immediately, refresh in background if >24h old.
- **`FilesNotifier`** starts empty. Files fetched lazily per media via `ensureLoaded(mediaId)` → `files_cache`;
  `files_fetched` (Box<bool>) tracks which media IDs are cached.
- Both subscribe to Supabase Realtime (`PostgresChangeEvent.all`) → apply incremental updates to Hive →
  Hive `watch()` listener refreshes provider state. Both re-sync when `connectionStatusProvider` flips online.

### Offline downloads (download_engine.dart) — security-sensitive, read before editing
- `background_downloader` does native parallel/pause/resume/cancel downloads that survive app kill, with
  progress notifications. Temp file: `applicationSupport/dl_tmp/<fileId>.part`.
- On complete, the file is **AES-256-CTR encrypted** off the main isolate into `applicationSupport/media_enc/<fileId>.enc`
  (16-byte IV prepended). Key is 32 random bytes in Keystore-backed `flutter_secure_storage` (`sinemax_media_key`) —
  copied `.enc` files are unreadable on any other device.
- Playback streams from a **loopback HTTP server** (`127.0.0.1`, random `?t=` token) that decrypts on the fly
  with HTTP Range support (`AesCtr.transform` does random-access decrypt). `playbackUrl(fileId)` returns its URL.
- Storage gate: refuses download unless free space ≥ `fileSize × kStorageSafetyFactor (3)`; throws
  `InsufficientStorageException`. `DownloadStatus`: queued→running→encrypting→completed / paused / failed.
  `init()` reconciles records left transient by a prior app death.

### Subscriptions (subscription_notifier.dart)
- Identity = `username` (`sinemax#####`) from the `create_profile()` RPC, stored once in Hive `metadata`.
  Durable across payments; only changes on reinstall. `restore(phone, username)` reclaims it (2-factor).
- `msisdn` is a payment attribute, not identity. `subscribe()` inserts/extends the `subscriptions` row,
  stamps the latest number, bumps `renewal_count`. Entitlement = `status active|grace AND expires_at > now`.
- Plans: `SubPlan.wiki` (7d, TZS 500) / `SubPlan.mwezi` (30d, TZS 1,500). `normalizeTzPhone()` → `+255XXXXXXXXX`.
- **Charge is still client-side** (TODO: move write server-side on mobile-money callback; client should then only read).

### Hive boxes (opened in main.dart)
| Box | Type | Purpose |
|---|---|---|
| `saved` | `Box<bool>` | saved media IDs |
| `recent` | `Box<WatchedItem>` | watch history |
| `download_records` | `Box<DownloadRecord>` | offline downloads (keyed by fileId) |
| `media_cache` | `Box<Media>` | Supabase media cache |
| `files_cache` | `Box<MediaFile>` | Supabase files cache |
| `files_fetched` | `Box<bool>` | per-mediaId fetch flag |
| `metadata` | `Box<String>` | `media_last_synced`, `username`, `subscription` JSON |
| `recent_searches` | `Box<String>` | recent search terms / tapped media |

---

## Key Providers (lib/data/)

```dart
// Core notifiers (own files; re-exported from providers.dart)
mediaProvider                 // AsyncNotifier — all Media; Hive-cached, Realtime
filesProvider                 // AsyncNotifier — all MediaFile; lazy, Realtime
downloadsProvider             // Notifier<Map<fileId,DownloadRecord>> — wraps DownloadEngine
connectionStatusProvider      // Notifier<bool> — real reachability
subscriptionProvider          // AsyncNotifier<SubscriptionState> (hand-written)

// Catalog (providers.dart)
mediaByIdProvider(id)         // FutureProvider<Media?>
homeRowsProvider              // FutureProvider<List<HomeRow>> — grouped by country, sorted by view_count
trendingMediaProvider         // FutureProvider<List<Media>> — top 5 by view_count (all-time; see FEATURE_GAPS #11)
mediaFilesProvider(id)        // FutureProvider<List<MediaFile>> — ensureLoaded + watches filesProvider + connectivity
relatedMediaProvider(id)      // FutureProvider<List<Media>> — same country/genre, max 6
filterYears/Djs/CountriesProvider  // FutureProvider<List<String>>

// Discover / Search
discoverFiltersProvider       // NotifierProvider<DiscoverFilters, DiscoverFilter>
discoverResultsProvider       // FutureProvider<List<Media>>
searchQueryProvider           // NotifierProvider<SearchQuery, String>
searchResultsProvider         // FutureProvider<List<Media>>
recentSearchTermsProvider / recentSearchMediaProvider / recentSearchMediaContentProvider  // search history

// Library (Hive-backed)
savedProvider / savedContentProvider
recentProvider / recentContentProvider   // Recent.markWatched defined; wiring is a FEATURE_GAP
downloadsContentProvider      // FutureProvider<List<(Media, List<DownloadRecord>)>> — grouped, newest first

// Requests (in-memory, not persisted)
requestsProvider / pendingRequestTitleProvider
```

---

## Supabase Schema

| Table | Key columns |
|---|---|
| `media` | `id`, `title`, `poster_url`, `description`, `country`, `year`, `type`('movie'/'series'), `genres[]`, `tags[]`, `dj`, `view_count`, `download_count` |
| `files` | `id`, `media_id`, `season`, `label`, `download_url`, `episode_number`, `file_size`, `created_at` |
| `profiles` | `username` (`sinemax#####`); created by `create_profile()` RPC |
| `subscriptions` | `username`, `msisdn`, `status`, `plan`('wiki'/'mwezi'), `expires_at`, `renewal_count`, `updated_at` |

---

## Reserved TODOs in detail_screen.dart — DO NOT IMPLEMENT/REMOVE

Intentionally left for a future session. Never implement or delete unless the user explicitly asks:
1. Increment `view_count` on Supabase after player initializes (`_loadAndInitPlayer`).
2. Restore saved playback position from Hive box `watch_progress` after player initializes (+ per-episode progress bars).

See [FEATURE_GAPS.md](FEATURE_GAPS.md) for the broader audit of incomplete logic and suggested order of attack.

---

## Theme Quick Reference

```dart
SinemaxColors.bg #050D1A · bg2 #0A1628 (nav) · panel #0E1D33 · panel2 #11233D (chips)
SinemaxColors.line rgba(120,160,220,.14) · line2 rgba(120,160,220,.26)
SinemaxColors.blue #2D8EFF · blueBright #19C3FB · blueDeep #1A6FE8
SinemaxColors.ink #EAF2FF (default text) · muted #8FA6C8 · muted2 #5E7298
SinemaxColors.gold #F4C13B · teal #22D3A6 · red #FF5D7A · orange #FF8A3D · purple #7C5CFF

SinemaxTextStyles.display(size, weight, color)  // Barlow Condensed
SinemaxTextStyles.body(size, weight, color)     // DM Sans
```

---

## Design Source Files (READ-ONLY reference)

```
sinemax app ui/  →  data.js (mock data), sinemax-parts.jsx (nav variants),
                    sinemax-icons.jsx (ported), tweaks-panel.jsx (inline nav, pulse splash)
```

---

## Current State

**Last updated: 2026-06-14**

### Completed
- [x] Full app: models, data layer, providers, all widgets, 8 screens, router, theme.
- [x] Supabase backend (media/files) with Hive-first caching + Realtime.
- [x] Offline encrypted downloads: `background_downloader` + AES-256-CTR + loopback decrypt server.
- [x] Connectivity detection + global offline/online toast overlay.
- [x] Subscriptions (device-identity username + mobile-money plans + restore).
- [x] FCM → local notifications with `/detail/:id?autoplay=1` deep linking.
- [x] Search history (`recent_searches` box).
- [x] Codegen active for all `@riverpod`/`@freezed`/`@HiveType` (subscription notifier is hand-written).
- [x] CLAUDE.md restructured as a read-first Fast Navigation Index.

### Pending / Requested
- [ ] *(see [FEATURE_GAPS.md](FEATURE_GAPS.md); add user-requested changes here after each session)*

---

## Session Log

| Date | Summary |
|---|---|
| 2026-06-05 | Initial build — models, data, providers, 5 widgets, 8 screens, router, theme |
| 2026-06-06 | CLAUDE.md auto-update system |
| 2026-06-06 | UI redesign: poster cards, home app bar/hero, detail fixed/scroll layout, sticky episodes |
| 2026-06-08 | Backend migration to Supabase; freezed Media/MediaFile; @riverpod codegen; Hive library persistence |
| 2026-06-09 | Data-layer refactor: split MediaNotifier/FilesNotifier; skeletonizer; new widgets; row_labels |
| 2026-06-13 | FEATURE_GAPS.md audit added |
| 2026-06-14 | Rewrote CLAUDE.md as read-first Fast Navigation Index; documented downloads/encryption, connectivity, subscriptions, FCM deep-linking, search history; fixed stale typeIds & box names |
