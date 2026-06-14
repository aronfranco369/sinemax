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

### 1. No authentication / user accounts  *(missing feature)*
- There is **no login, signup, or session** anywhere. `supabase_flutter` is initialized but
  `Supabase.instance.client.auth` is never used.
- The Profile screen is **100% hardcoded**: `'Amani Mushi'`, `'@amani'`, `'Member since Jan 2024'`
  in [profile_screen.dart](lib/screens/profile_screen.dart#L97-L107).
- Consequence: every install is anonymous and identical. Library, saved, watch history, and
  downloads are **device-local only** (Hive) — nothing syncs across devices or survives reinstall.
- Reference: every comparable app gates personalization behind an account (email/phone OTP,
  Google sign-in). For a TZ audience, **phone-number OTP** is the usual choice.

### 2. No subscription / payment logic  *(missing feature)*
- The Premium card ("PREMIUM · TZS 5,000 / month · Active · Renews Jul 1") is a **static widget**
  with no backing state — [profile_screen.dart](lib/screens/profile_screen.dart#L167-L224).
- There is **no paywall, entitlement check, or payment gateway** (no M-Pesa / Tigo Pesa / Airtel
  Money / Selcom / card). All content is fully free and playable.
- If monetization is part of the business model, this is a launch blocker: needs an entitlements
  table, a payment provider integration, and gating in the player / download flow.

### 3. "Saved" list is write-only — no surface to view it  *(incomplete logic)*
- Users can bookmark from Home and Detail (`savedProvider.toggle`), and `savedContentProvider`
  exists in [providers.dart](lib/data/providers.dart#L288-L293) — but **no screen ever reads it**.
- The Library tab was repurposed to **Downloads only** ([library_screen.dart](lib/screens/library_screen.dart));
  the old Recent / Saved / Downloads tab bar described in `CLAUDE.md` no longer exists in code.
- Net effect: you can save a title but **never browse your saved titles**. Either restore a
  Saved tab/screen or drop the Save button.

### 4. Watch history is never recorded  *(incomplete / dead logic)*
- `Recent.markWatched()` ([providers.dart](lib/data/providers.dart#L304-L312)) is **never called**
  from anywhere in the app. The `recent` Hive box is therefore always empty.
- Consequences:
  - Profile "Watched" stat is **permanently 0** ([profile_screen.dart](lib/screens/profile_screen.dart#L16)).
  - `recentContentProvider` is dead code — no UI consumes it.
  - There is **no "Continue Watching" row** on Home, the single most-used row in any streaming app.
- Fix: call `markWatched` when the player initializes / on dispose, surface a Continue Watching row.

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

### 7. Share button is a no-op  *(incomplete logic)*
- The Share `ActionBtn` on Detail has **no `onTap`** ([detail_screen.dart](lib/screens/detail_screen.dart#L289-L291)).
- No `share_plus`, no deep-link URL scheme, no dynamic links. Sharing a title does nothing.
- Reference: viral growth in this category leans heavily on WhatsApp sharing — worth prioritizing.

### 8. Profile settings are non-functional  *(incomplete logic)*
- All settings tiles are static rows with no handlers:
  - "Notifications" toggle is **local ephemeral state** (`_ToggleState`) — does **not** subscribe/
    unsubscribe FCM topics ([profile_screen.dart](lib/screens/profile_screen.dart#L258-L301), [fcm_service.dart](lib/data/fcm_service.dart#L38-L41)).
  - "Download on Wi-Fi only" toggle is decorative — the [download_engine.dart](lib/data/download_engine.dart)
    never checks connection type before downloading.
  - "Video Quality: Auto", "Language: English", "About Sinemax", "Help & Support" tiles do nothing.
- Only **Refresh Library Data** and visual toggles actually work.

### 9. No video quality / adaptive streaming  *(missing feature)*
- Player streams a **single MP4 URL** from the `files` table with a hard-coded
  `aspectRatio: 16/9` and a BigBuckBunny-style fallback ([detail_screen.dart](lib/screens/detail_screen.dart#L129-L142)).
- No HLS/DASH, no resolution selection, no bitrate adaptation. On poor TZ networks this means
  buffering with no lower-quality fallback. The "Video Quality" setting (#8) has nothing to control.

### 10. No ratings, reviews, or comments  *(missing feature)*
- Detail shows metadata chips and a description only. No star rating, no review list, no comment
  thread. The gold star on the Trending card is a **static label**, not a real rating.

### 11. Trending is not time-windowed  *(minor logic gap)*
- Labeled "MOST WATCHED THIS WEEK" but computed as all-time top-5 by `view_count`
  ([providers.dart](lib/data/providers.dart#L83-L88)). Needs a time-windowed metric (or a
  `trending_score`) to be truthful.

### 12. "Related" is a naive heuristic  *(minor logic gap)*
- `relatedMedia` matches on same country **or** identical first genre, capped at 6, unordered
  ([providers.dart](lib/data/providers.dart#L90-L105)). No relevance ranking, no de-dupe by quality.

### 13. Requests have no two-way lifecycle in-app  *(partial feature)*
- Submitting a request writes to Supabase `requests` and shows status chips
  ([requests_screen.dart](lib/screens/requests_screen.dart)), but there is **no admin reply surface,
  no notification when a requested title is added**, and status is read-only. Acceptable for v1,
  but the loop is open.

---

## 🟡 MINOR / POLISH & cleanup

### 14. `admin/schema.sql` is stale and wrong  *(cleanup)*
- It still defines a **`books` table** (leftover from the original "kitabu" books concept) — see
  [schema.sql](admin/schema.sql) — while the app uses `media` + `files` + `requests`. Anyone
  bootstrapping a fresh Supabase project from this file gets the wrong schema. Replace with the
  real `media` / `files` / `requests` DDL.

### 15. Dev artifact wired into Profile  *(cleanup)*
- The edit FAB on Profile pushes `AnimatedSvgLogo` from
  [logo_animation.dart](lib/screens/logo_animation.dart) ([profile_screen.dart](lib/screens/profile_screen.dart#L21-L25)).
  This is a logo-animation playground, not an "edit profile" flow — remove or replace with a real
  edit-profile screen.

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
