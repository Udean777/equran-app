# Qurva RN — Design

React Native rewrite of the Qurva Flutter app, built as a portfolio slice.
The Flutter app is archived in `backup/` (gitignored) and is the **behavioural reference**, not a source to port line by line.

- Product: Qurva — Quran reader, murattal audio, prayer times, qibla, hafalan (memorisation) tracker.
- Purpose of this rewrite: demonstrate React Native + Expo competence (native modules, background execution, alarms, widgets) in a small, complete app.
- Non-goal: feature parity with `backup/`. Only the scope below.

## 1. Scope

| Feature | In scope | Notes |
|---|---|---|
| Onboarding (4 slides) | Yes | One-time flag, re-run from Settings |
| Surah list / detail / tafsir | Yes | Offline-first, API `equran.id` (`/api/v2` for `id` + tafsir, `/api/en` for `en` translation) |
| Murattal audio | Yes | Background + lock screen, per-ayah and per-surah |
| Doa & dzikir | Yes | Offline-first SQLite cache (227 items via `/api/doa`), local filter by `grup`/`tag` |
| Semantic search | Yes | Online-only via `POST /api/vector` across `surat`, `ayat`, `tafsir`, `doa` |
| Prayer times | Yes | Computed offline (`adhan-js`) + location |
| Prayer notification / alarm | Yes | `alarmClock` delivery, exact alarm permission |
| Qibla | Yes | Compass heading + location |
| Hafalan: list, status, setoran (record + AI compare), stats, muraja'ah reminders, history | Yes | Uploads to existing FastAPI service |
| Home screen widget (Android) | Yes | `expo-widgets` |
| Settings, i18n (id/en), theme | Yes | |
| Tasbih, prayer stats, imsakiyah, catatan ayat, quran reminder, hafalan juz/filter/ayah-grid | No | Deliberately out of scope |
| iOS widget, live activity | No | Android widget only |

## 2. Stack

| Concern | Choice | Why this, not the alternative |
|---|---|---|
| Runtime / build | **Expo SDK 58** (RN 0.88, New Architecture only) with **prebuild**; `android/` and `ios/` committed | Widget + alarm config need native edits. Prebuild ≠ lock-in: native dirs are real. Community CLI has no advantage here. |
| Package manager | **Bun** (`bun.lock` only), Node LTS still installed for `expo` CLI internals | Faster installs; Expo Build picks Bun automatically when `bun.lock` is present. Bun's default "no lifecycle scripts" means `trustedDependencies` must be maintained explicitly. |
| Language | TypeScript, `strict` | |
| Styling | **NativeWind 4.2.x** + Tailwind, tokens in `tailwind.config.js` | Pin the stable 4.x line. `nativewind@5` is `rc` — do not adopt. |
| Navigation | `expo-router` (typed routes) | File-based routes replace `go_router`; deep links free. |
| Server state | **TanStack Query v5** | Caching, retries, offline-friendly. Never mirror server data into a store. |
| Client state | **zustand v5** | Small, no provider tree. UI state only. |
| Validation | **zod 4** | Parses every API payload at the boundary; replaces `freezed` + `json_serializable`. |
| Local DB | **`expo-sqlite`** (plain SQL, no ORM) | Six tables and simple queries do not justify drizzle-kit + a babel plugin + `.sql` resolver. Migrations stay a plain function, still testable. MMKV only for flat preferences. |
| Preferences | `react-native-mmkv` | Onboarding flag, theme, qari, language. |
| Audio | **`expo-audio`** (`AudioPlaylist`, `setActiveForLockScreen`) | Built-in foreground service + lock screen + gapless. Use `react-native-track-player` only if the playlist API proves insufficient. |
| Notifications | **`expo-notifications`** | `delivery: 'alarmClock'` + `requestExactAlarmPermissionsAsync`. Notifee is archived. |
| Widget | **`expo-widgets`** (Android, opt-in) | Widget UI in TSX. Fallback: native Kotlin + `react-native-android-widget`. |
| Sensors | `expo-sensors` + `react-native-compass-heading` 3 | Heading has a maintained lib; Magnetometer for fallback |
| Location | `expo-location` | |
| Offline detection | `@react-native-community/netinfo` | Drives the audio offline notice; nothing else blocks on it |
| Prayer times | `adhan-js` | Same algorithm as the Flutter `adhan` package |
| i18n | `i18next` + `react-i18next` + `expo-localization` | Flat JSON, no codegen |
| Testing | **Jest** (`jest-expo`) + `@testing-library/react-native` + one Maestro flow | Expo SDK 58 ships `jest-expo` and RNTL 14 is supported on the Jest path; two runners in one repo is a smell. |
| CI | GitHub Actions: `ci.yml` (typecheck, lint, test) + `release.yml` (manual, signed APK + AAB via Gradle) | One stored upload keystore, no EAS account; release stays a deliberate dispatch, not a side effect of a push |

## 3. Architecture

Feature-first. Each feature is one folder with three layers, mirroring the Flutter tri-layer so reasoning transfers:

```
src/
  app/                      # expo-router routes ONLY — thin screens
    (onboarding)/
    (tabs)/
      index.tsx             # surah list
      prayer.tsx
      hafalan.tsx           # targets + history; setoran via sheet
      settings.tsx
    surah/[number]/index.tsx
    surah/[number]/tafsir.tsx
    _layout.tsx
  features/
    quran/
      domain/               # pure TS: types, rules, no imports from data/presentation
        entities.ts
        ayat-number.ts
      data/                 # api client, zod schemas, sqlite queries, mappers
        api.ts
        schema.ts
        repository.ts
      presentation/         # components + query hooks used by screens
        use-surah-list.ts
        surah-card.tsx
    doa/
    search/
    audio/
    prayer/
    qibla/
    hafalan/
    onboarding/
    settings/
  components/               # cross-feature primitives (Button, Screen, EmptyState)
  lib/                      # db client, query client, i18n, logger, result type
  theme/                    # tokens consumed by NativeWind
```

Hafalan has no nested routes: `surah-picker-modal.tsx` and `setoran-sheet.tsx` live in
`features/hafalan/presentation/` and open from the tab. Planned but not built yet:
`doa/index.tsx`, `doa/[id].tsx`, `search.tsx` (delivery phase 7 in §9).

**Dependency rule:** `presentation → domain ← data`. A screen imports from `features/*/presentation`; presentation calls `data` only through feature hooks; `domain` imports nothing from the app. No screen talks to `fetch` or SQLite directly.

Layer contents:

- `domain`: entity types, invariants (muraja'ah intervals, ayah global numbering, prayer calculation inputs), pure functions. Must be testable without React Native.
- `data`: zod schemas for remote payloads, repository functions returning typed results, SQLite queries, mappers to domain types.
- `presentation`: components, query/mutation hooks, view-model-ish selectors. No business rules that belong in `domain`.

## 4. Data contract

Remote:

| Source | Endpoint | Use |
|---|---|---|
| `https://equran.id/api/v2` | `/surat`, `/surat/{n}`, `/tafsir/{n}`, `/shalat`, `/shalat/provinsi`, `/shalat/kabkota` | Surah (`id`), tafsir, prayer reference data |
| `https://equran.id/api/en` | `/surah`, `/surah/{n}` | English Quran translation (`alquran.cloud / Muhammad Asad`, UI attribution required; no tafsir) |
| `https://equran.id/api/doa` | `/`, `/{id}` | Doa & dzikir (227 items, 44 groups, 22 tags) |
| `https://equran.id/api/vector` | `POST /` | Semantic search across `surat`, `ayat`, `tafsir`, `doa` |
| `https://cdn.islamic.network/quran/audio/{bitrate}/{qari}/{globalAyah}.mp3` | — | Murattal (no API key) |
| `https://ssajudn-equran-hafalan-api.hf.space` | `POST /compare` (multipart: `user_audio`, `target_text`, `threshold`), `GET /health` | Hafalan AI scoring. Server: `server/` (FastAPI + faster-whisper + Levenshtein). |

Wire rules:

- Every response is parsed by a zod schema before it reaches the app. Unknown field → ignore; missing required field → typed `ParseError`, surfaced as a retryable failure.
- API shape changes are handled in `schema.ts`, never in components.
- **Excluded legacy/SDK**: `v1 (/api)` (legacy `400` error shape) and the `equran` npm SDK (duplicates TanStack Query + SQLite cache and introduces foreign types) are not used.
- **HTTP cache**: REST endpoints (`/api/v2`, `/api/en`, `/api/doa`, `/api/v2/shalat`) serve `public, max-age=2592000, stale-while-revalidate=604800` (30 days) with `ETag` (`If-None-Match` → `304`). `/api/vector` serves `Cache-Control: no-store` and is never persisted to SQLite.
- **Surah boundaries**: `previousSurah` / `suratSebelumnya` returns `false` on surah 1 and `nextSurah` / `suratSelanjutnya` returns `null` on surah 114; model both safely in Zod.
- **Doa (`/api/doa`)**: Valid IDs are `1..227` (`228` → `404 { status: "error", message }`). `tr`, `idn`, and `tentang` can be empty strings (`z.string()`, never `.min(1)`). Server ignores `?limit`/`?page` and AND-s `?grup` + `?tag`; sync all 227 items and filter locally.
- **Vector (`/api/vector`)**: `POST` `{ cari, batas, tipe[], skorMin }`; clamp `batas` to `1..10` (avoid `0`, which returns `1`). Parse `hasil[].data` with a `z.discriminatedUnion` per `tipe` (`snake_case` fields). Handle `400 { status: "gagal", kode }` (`PENCARIAN_KOSONG`, `TIPE_TIDAK_VALID`). Debounce/throttle on client (30 req/min server limit exposes no `RateLimit-*` headers).
- **Shalat (`/api/v2/shalat`)**: Reference only (`adhan-js` remains primary). Only years `2026–2028` currently return `200` (outside → `404`); validate `bulan`/`tahun` on client before `POST` (server silently falls back to current month/year on invalid values) and always use `POST` (`GET` returns `200` docs JSON).
- `/health` is called with a 5 s timeout when the setoran sheet opens (HF Spaces sleeps), not when the user taps record.
- Upload body: `FormData` with `user_audio` as an `expo-file-system` `File`, plus `target_text`, `threshold`, `is_arabic`, sent through `expo/fetch`; `AbortController` with a 120 s timeout; one retry on network failure only (timeout, server, and parse errors are not retried).

Local SQLite (`qurva.db`):

```
surah(number PK, name, latin, ayat_count, revelation, synced_at)
ayah(surah_number, number, text_arabic, text_latin, translation, translation_en, PRIMARY KEY(surah_number, number))
tafsir(surah_number PK, content, synced_at)
doa(id PK, group_name, title, text_arabic, text_latin, translation, notes, tags_json, synced_at)
hafalan(id PK, surah_number, level, status, last_setoran_at, next_murajaah_at, note)
setoran(id PK, hafalan_id, created_at, score, cer, result_json)
notification_ref(id PK, hafalan_id, notification_id, scheduled_for)
prefs  -- MMKV, not SQLite
```

Migrations: one plain SQL string per schema version in `lib/db/client.ts`, applied in a transaction on app start and tracked with `PRAGMA user_version`.

## 5. State rules

- Server/remote data → TanStack Query only. Query keys are defined once per feature (`quranKeys.surahList()`), never written inline.
- UI state (selected qari, sheet open, onboarding step) → zustand or local `useState`; zustand for state shared across routes.
- Derived values are computed, not stored. If it can be recalculated from query data + prefs, it is not in a store.
- Cache persistence: query results for surah/tafsir are written to SQLite and rehydrated; audio is not cached beyond the OS.

## 6. Platform specifics

**Prayer alarm (highest risk).** `expo-notifications` schedules an Android trigger with `delivery: 'alarmClock'`; requires `android.permission.USE_EXACT_ALARM` (already justified: alarm-category app) plus `SCHEDULE_EXACT_ALARM`. On Android 14+, check `getExactAlarmPermissionsAsync()` and route the user to settings when denied. iOS has no full-screen alarm; schedule a local notification with a bundled sound and accept the weaker behaviour — document it, do not fake it.

**Background audio.** `enableBackgroundPlayback: true` in the `expo-audio` plugin config; call `setAudioModeAsync({ playsInSilentMode: true, shouldPlayInBackground: true, interruptionMode: 'doNotMix' })` and `setActiveForLockScreen` — without the latter Android stops playback after ~3 minutes.

**Widget.** `expo-widgets` plugin with `enableAndroid: true`; widget bodies use the `'widget'` directive, are pure, and receive data only via `updateSnapshot` props. No hooks, no async, no imports from app modules. Update on app foreground and after prayer-time recomputation.

**Sensors.** Qibla reads the raw heading stream from `react-native-compass-heading` (`degreeUpdateRate: 2`), smoothed with an exponential moving average kept in *unwrapped* degrees so rotations never take the 359°→0° long way. The steady stream is written to Reanimated shared values on the JS thread and applied on the UI thread; React state (digits, aligned badge) updates at most 5 Hz. `adhan.Qibla` returns a true-north bearing while the sensor reports magnetic north, so `expo-location` `getHeadingAsync()` is read once per compass session (1.5 s timeout; Android stays silent and iOS throws without a location fix) to get the declination. If it cannot be resolved, declination is 0 and the compass runs magnetic — never show a silently wrong direction, and fall back to "device does not support compass" when the sensor is missing. Never request `HIGH_SAMPLING_RATE_SENSORS` unnecessarily.

**Hafalan reminders.** On save, compute the next muraja'ah date from `[1, 3, 7, 30, 90]` days by level, cancel the previous notification, schedule a new one, and persist `notification_id` in `notification_ref`. Missing this bookkeeping is the classic bug: stale notifications accumulate.

**Release builds.** `.github/workflows/release.yml` is manual (`workflow_dispatch`) and takes a bump type: `patch`, `minor`, `major`, or `custom`. The version is derived from the latest `v*` tag (Flutter-era build metadata such as `v0.6.0+7` is stripped, so the RN line continues at `0.7.0`), must be newer than that tag, and is written into `android/app/build.gradle`; `versionCode = major*10000 + minor*100 + patch`. One dispatch produces a signed AAB (Play) plus two split release APKs (`arm64-v8a`, `armeabi-v7a`) attached to a GitHub Release. Signing comes from `plugins/with-android-release-signing.js`, which reads keystore values from `-PQURVA_UPLOAD_*` properties and enables v1–v4 APK signatures; the keystore itself exists only in the four `ANDROID_*` repository secrets. A release task without those properties is **refused** instead of falling back to the debug keystore, because a debug-signed APK installs poorly outside Play and cannot be uploaded. CI then verifies zipalign, the absence of the debug certificate, and the v2/v3 schemes on every artifact. There is no `eas build` path.

## 7. Error, offline, and i18n policy

- One `Result<T, AppError>` type in `lib/result.ts`; `AppError` has codes (`network`, `timeout`, `parse`, `notFound`, `permission`, `server`). UI maps codes to i18n messages; repositories never format user-facing strings.
- Offline: `surah`, `tafsir`, and `doa` render from SQLite; `audio` and `vector search` require network (show offline/retry state when disconnected). Every list screen has an empty, loading, and error state — no screen renders raw errors. `useIsOffline` (`netinfo`) gates starting murattal playback with a translated toast; hafalan setoran stays a network-only write path.
- All user-facing copy goes through i18next (`id` default, `en` secondary). Domain and data layers contain no strings.

## 8. Testing

| Level | Tool | What must be covered |
|---|---|---|
| Unit | Jest (`jest-expo`) | Muraja'ah interval math, ayah global numbering, prayer-time inputs, zod schema edge cases, heading smoothing |
| Integration | Jest + `sql.js` (wasm SQLite) | Migrations applied in order against the real schema (`src/lib/db/migrations.test.ts`); repository SQL and notification bookkeeping still to add |
| Component | RNTL | One happy path per critical component (setoran result, surah card) |
| E2E | Maestro (1 flow) | Open surah → play → pause from lock screen → open setoran |

A new rule, parser, or scheduling calculation without a test is not done.

Tests run with `TZ=Asia/Jakarta`. `adhan` derives the prayer day from local date getters, so any
future-based schedule fixture is only meaningful in a fixed timezone — a UTC runner otherwise
computes a different day and the prayer-time tests fail for reasons unrelated to the change.

Outstanding: Maestro is not set up yet (the single flow above), and the repository layer still
relies on unit tests with a mocked `db`.

## 9. Delivery phases

1. **Spike (2 weeks, gates the rest).** Prove on a physical device: `alarmClock` notification with screen off, 30 min background audio, Android widget via `expo-widgets`, Arabic mushaf-style text rendering. If alarm or Arabic text fails, stop and re-evaluate.
2. **Foundation.** Scaffold with `bun create expo --template default@sdk-58`, prebuild, expo-router, NativeWind tokens, i18n, CI, onboarding.
3. **Quran reading.** Surah list/detail/tafsir, English Quran mode (`/api/en` + `translation_en` lazy hydration), SQLite + Query, offline.
4. **Audio.** Playlist, lock screen, per-ayah seek.
5. **Prayer + qibla.** adhan-js, location, alarm, compass.
6. **Hafalan.** Record → upload → compare → save → schedule → reminder → history → stats.
7. **Doa & semantic search.** Offline-first doa & dzikir (`/api/doa`), online semantic search (`POST /api/vector`).
8. **Widget + polish + README** with screenshots and the three "lessons learned" notes.

## 10. Decisions worth remembering

- **Expo over community CLI**, because no constraint here needs bare bootstrapping; prebuild still yields native projects.
- **Bun over npm/pnpm**: install speed, and Expo Build auto-detects `bun.lock`. The trade-off is explicit `trustedDependencies` bookkeeping, because Bun skips lifecycle scripts by default.
- **No Notifee**: archived April 2026; `expo-notifications` covers local notifications and alarms.
- **`expo-audio` over `react-native-track-player`**: first-party, maintained with the SDK; RNTP is the escape hatch.
- **SQLite over a document store**: Quran text is relational and query-heavy; hafalan joins against surah/ayah.
- **`expo-sqlite` without an ORM**: the schema is small and stable; an ORM adds a codegen step, a babel plugin, and a Metro resolver for no query that plain SQL does not cover.
- **Jest over Vitest**: `jest-expo` is the SDK-supported path and RNTL targets Jest; a single runner beats faster unit tests.
- **Scope is a slice, not parity**: the goal is depth in a few hard features, not LOC.
- **Branding**: keep the "Qurva" name but use a distinct `applicationId`, and say "RN port" in the README so it is not mistaken for the shipped app.

## 11. Open risks

- Arabic text layout (line breaking, kashida, page-accurate mushaf) is weaker in RN than Flutter. Validate in the spike; if it fails, ship text-mode reading, not mushaf pages.
- iOS alarm parity is not achievable; product copy must not promise it.
- `expo-widgets` is one SDK old; if it proves too limited, fall back to a Kotlin widget behind the same data update path.
- `server/` and the Hugging Face Space are external dependencies; setoran requires the service and fails with a retryable error (no demo scores are fabricated).
- `/api/v2/shalat` year availability (`2026–2028`) and `/api/vector` rate-limit enforcement (30 req/min without headers) may shift server-side without notice.
