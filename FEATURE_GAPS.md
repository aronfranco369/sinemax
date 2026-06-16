# SINEMAX — Feature Gaps & Incomplete Logic

> Audit of the current Flutter codebase (`lib/`) against what a production streaming app
> (Netflix / Showmax / Viu / iROKOtv class) is expected to do. Items are grouped by
> **importance to shipping Sinemax**, not by effort. Each item notes whether it is a
> *missing feature*, a *minor/polish item*, or *incomplete logic already half-wired in code*.

Last reviewed: 2026-06-13 · Branch: `main`

---

## Legend

| Tag | Meaning |
|---|---|
| 🔴 **MAJOR** | Blocks launch or is core to the product promise |
| 🟠 **SECONDARY** | Expected by users, but app is usable without it short-term |
| 🟡 **MINOR / POLISH** | Nice-to-have, cosmetic, or cleanup |
| ⚙️ **INCOMPLETE LOGIC** | Code exists but is dead, stubbed, or a reserved TODO |

---

## 🔴 MAJOR — must address before / around launch




### 5. Resume playback / progress tracking not implemented  *(reserved INCOMPLETE LOGIC)*
- Saving and restoring playback position are the **reserved DO-NOT-TOUCH TODOs** in
  [detail_screen.dart](lib/screens/detail_screen.dart#L62-L65) (box `watch_progress`).
- Also reserved: the **per-episode progress bar** overlays in `_FileCard` / `_FileRow`
  ([detail_screen.dart](lib/screens/detail_screen.dart#L525-L527) and [#L595-L599](lib/screens/detail_screen.dart#L595-L599)).
- Until done, every play starts from 0:00 and there is no visual "where I left off." Pairs with #4.

### 6. `view_count` / `download_count` never incremented  *(reserved INCOMPLETE LOGIC)*
- Increment-on-play is a reserved TODO ([detail_screen.dart](lib/screens/detail_screen.dart#L62-L63)).
- Because of this, **Trending, Home row ordering, and Discover sorting are all driven by static
  seed counts** that never change in production. The home "MOST WATCHED THIS WEEK" label is
  misleading — `trendingMediaProvider` is top-5 by *all-time* `view_count`, not a weekly window
  ([providers.dart](lib/data/providers.dart#L83-L88)).
- Needs a Supabase RPC (`increment_view_count`) + a `download_count` bump on completed download.

---

## 🟠 SECONDARY — expected, not strictly blocking


### 11. Trending is not time-windowed  *(minor logic gap)*
- Labeled "MOST WATCHED THIS WEEK" but computed as all-time top-5 by `view_count`
  ([providers.dart](lib/data/providers.dart#L83-L88)). Needs a time-windowed metric (or a
  `trending_score`) to be truthful.

### 12. "Related" is a naive heuristic  *(minor logic gap)*
- `relatedMedia` matches on same country **or** identical first genre, capped at 6, unordered
  ([providers.dart](lib/data/providers.dart#L90-L105)). No relevance ranking, no de-dupe by quality.


---

## 🟡 MINOR / POLISH & cleanup


### 16. No real localization (i18n)  *(polish)*
- UI is a **hardcoded mix of Swahili and English** (e.g. "Agiza", "Soma zaidi", "Downloads",
  "Save", "Share"). The "Language" setting implies switching but nothing is wired. Introduce
  `flutter_localizations` / ARB files and pick one default.

### 17. Onboarding / first-run experience  *(missing, minor)*
- App goes Splash → Home directly. No onboarding, no permission priming for notifications,
  no first-run "connect to load catalog" education beyond the offline fallback notice.

### 18. No pull-to-refresh on Home / Discover  *(polish)*
- Only the Requests list has `RefreshIndicator`. Home and Discover rely on the 24h background
  refresh or the Profile "Refresh Library Data" tile.

### 19. No analytics / crash reporting  *(missing, ops)*
- Firebase is present (messaging only). No Crashlytics, no Analytics. Hard to learn what users
  watch or where they drop off — and #6's metrics gap compounds this.

### 20. Player UX details  *(polish)*
- No fullscreen-orientation handling beyond portrait lock in [main.dart](lib/main.dart#L44),
  no next-episode autoplay, no skip-intro, no playback-speed control, no captions/subtitles track.

---

## Quick reference — dead / stubbed code to revisit

| Symbol | File | State |
|---|---|---|
| `Recent.markWatched` | [providers.dart:304](lib/data/providers.dart#L304) | defined, never called |
| `recentContentProvider` | [providers.dart:315](lib/data/providers.dart#L315) | no UI consumer |
| `savedContentProvider` | [providers.dart:288](lib/data/providers.dart#L288) | no UI consumer |
| Share `ActionBtn` | [detail_screen.dart:289](lib/screens/detail_screen.dart#L289) | no `onTap` |
| Settings toggles/tiles | [profile_screen.dart:59](lib/screens/profile_screen.dart#L59) | cosmetic only |
| view/download count bump | [detail_screen.dart:62](lib/screens/detail_screen.dart#L62) | reserved TODO |
| resume position + progress bars | [detail_screen.dart:64](lib/screens/detail_screen.dart#L64) | reserved TODO |
| `admin/schema.sql` | [schema.sql](admin/schema.sql) | wrong table (`books`) |

---

## Suggested order of attack

1. **Watch history + Continue Watching + resume position** (#4, #5) — biggest UX lift, all the
   plumbing/boxes already exist.
2. **Saved screen** (#3) — restore a surface for an action users can already take.
3. **view/download counters** (#6) — makes Trending/Home/Discover real; small Supabase RPC.
4. **Auth** (#1) — unlocks cross-device sync and everything personalized.
5. **Payments/entitlements** (#2) — only if monetization is in scope for v1.
6. **Share** (#7) and **functional settings** (#8) — cheap wins.
7. Everything in 🟡 as cleanup passes.
