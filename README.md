# SINEMAX

**SINEMAX** is a streaming app for translated (dubbed) movies & series by Tanzanian DJs. It's a Flutter application with a dark theme, a Supabase backend, and Hive for local persistence and offline playback.

> The Flutter package name is `sinemax`; the display name is **SINEMAX**.

---

## Features

- 🎬 Browse trending movies & series, grouped into Swahili-labelled category rows
- 🔍 Search and discover content by year, type, country, and DJ
- 📥 **Offline downloads** with a custom download engine and connectivity-aware UI
- 📚 Personal library — Recent watch history, Saved titles, and Downloads
- 🎞️ In-app video player (Chewie + video_player) streaming from Supabase
- 📝 Content request form so users can ask for new titles
- ⚡ Realtime catalog updates via Supabase Realtime
- 🗄️ Hive-first caching for instant cold starts and offline access
- 💀 Skeleton loading states throughout

---

## Tech Stack

| Concern | Choice |
|---|---|
| Framework | Flutter (Dart) |
| State management | `flutter_riverpod` + `riverpod_annotation` (`@riverpod` codegen) |
| Navigation | `go_router` — `StatefulShellRoute.indexedStack` with 5 tabs |
| Backend | `supabase_flutter` — tables: `media`, `files`; Realtime subscriptions |
| Local persistence | `hive_ce` + `hive_ce_flutter` — offline cache + library boxes |
| Models | `freezed` + `json_serializable` |
| Video player | `chewie` + `video_player` |
| Images | `cached_network_image_ce` |
| Skeletons | `skeletonizer` |
| Animations | `flutter_animate` |
| Fonts | Barlow Condensed (display) + DM Sans (body) via `google_fonts` |
| Icons | Custom SVG via `flutter_svg` |
| Config | `flutter_dotenv` — `.env` with `SUPABASE_URL` + `SUPABASE_ANON_KEY` |

---

## Project Structure

```
lib/
├── main.dart            # Entry: dotenv + Supabase + Hive init + ProviderScope
├── app.dart             # GoRouter + app shell
├── theme/               # Colors, text styles, theme builder
├── models/              # Media, MediaFile, library items, requests (@freezed / @HiveType)
├── data/                # Riverpod notifiers + providers, download engine, connectivity
├── utils/               # Swahili row labels
├── widgets/             # Reusable UI (cards, nav bar, skeletons, download controls…)
└── screens/             # Splash, Home, Discover, Requests, Library, Profile, Detail, Search
```

---

## Getting Started

### Prerequisites
- Flutter SDK
- A Supabase project with `media` and `files` tables

### Setup

1. Clone the repo:
   ```bash
   git clone https://github.com/aronfranco369/kitabu.git
   cd kitabu
   ```

2. Create a `.env` file in the project root:
   ```
   SUPABASE_URL=your-supabase-url
   SUPABASE_ANON_KEY=your-supabase-anon-key
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run code generation (required after model/provider/Hive changes):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. Run the app:
   ```bash
   flutter run
   ```

---

## Data Model

| Table | Key columns |
|---|---|
| `media` | `id`, `title`, `poster_url`, `description`, `country`, `year`, `type` (`movie`/`series`), `genres[]`, `tags[]`, `dj`, `view_count`, `download_count` |
| `files` | `id`, `media_id`, `season`, `label`, `download_url`, `episode_number`, `created_at` |

---

## License

This project is private and not currently licensed for redistribution.
