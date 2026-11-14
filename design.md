# Qurva RN — Design

React Native rewrite of the Qurva Flutter app, built as a portfolio slice.
The Flutter app is archived in `backup/` (gitignored) and is the **behavioural reference**, not a source to port line by line.

- Product: Qurva — Quran reader, murattal audio, prayer times, qibla, hafalan (memorisation) tracker.
- Purpose of this rewrite: demonstrate React Native + Expo competence (native modules, background execution, alarms, widgets) in a small, complete app.
- Non-goal: feature parity with `backup/`. Only the scope below.

## 1. Scope

| Feature | In scope | Notes |
|---|---|---|
| Onboarding (6 slides) | Yes | One-time flag, re-run from Settings |
| Surah list / detail / tafsir | Yes | Offline-first, API `equran.id` |
| Murattal audio | Yes | Background + lock screen, per-ayah and per-surah |
| Prayer times | Yes | Computed offline (`adhan-js`) + location |
| Prayer notification / alarm | Yes | `alarmClock` delivery, exact alarm permission |
| Qibla | Yes | Compass heading + location |
| Hafalan: list, status, setoran (record + AI compare), stats, muraja'ah reminders, history | Yes | Uploads to existing FastAPI service |
| Home screen widget (Android) | Yes | `expo-widgets` |
| Settings, i18n (id/en), theme | Yes | |
| Tasbih, prayer stats, imsakiyah, doa, catatan ayat, quran reminder, hafalan juz/filter/ayah-grid | No | Deliberately out of scope |
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
| Prayer times | `adhan-js` | Same algorithm as the Flutter `adhan` package |
| i18n | `i18next` + `react-i18next` + `expo-localization` | Flat JSON, no codegen |
| Testing | **Jest** (`jest-expo`) + `@testing-library/react-native` + one Maestro flow | Expo SDK 58 ships `jest-expo` and RNTL 14 is supported on the Jest path; two runners in one repo is a smell. |
| CI | GitHub Actions (typecheck, lint, test) + Expo Build for artifacts | Matches common practice; Build is free at this volume |

## 3. Architecture

Feature-first. Each feature is one folder with three layers, mirroring the Flutter tri-layer so reasoning transfers:

```
src/
  app/                      # expo-router routes ONLY — thin screens
    (onboarding)/
    (tabs)/
      index.tsx             # surah list
      prayer.tsx
      hafalan.tsx
      settings.tsx
    surah/[number].tsx
    surah/[number]/tafsir.tsx
    hafalan/[surah]/index.tsx
    hafalan/[surah]/setoran.tsx
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

**Dependency rule:** `presentation → domain ← data`. A screen imports from `features/*/presentation`; presentation calls `data` only through feature hooks; `domain` imports nothing from the app. No screen talks to `fetch` or SQLite directly.

Layer contents:

- `domain`: entity types, invariants (muraja'ah intervals, ayah global numbering, prayer calculation inputs), pure functions. Must be testable without React Native.
- `data`: zod schemas for remote payloads, repository functions returning typed results, SQLite queries, mappers to domain types.
- `presentation`: components, query/mutation hooks, view-model-ish selectors. No business rules that belong in `domain`.

## 4. Data contract

Remote:

| Source | Endpoint | Use |
|---|---|---|
| `https://equran.id/api/v2` | `/surat`, `/surat/{n}`, `/tafsir/{n}`, `/shalat`, `/shalat/provinsi`, `/shalat/kabkota` | Surah, tafsir, prayer reference data |
| `https://cdn.islamic.network/quran/audio/{bitrate}/{qari}/{globalAyah}.mp3` | — | Murattal (no API key) |
| `https://ssajudn-equran-hafalan-api.hf.space` | `POST /compare` (multipart: `user_audio`, `target_text`, `threshold`), `GET /health` | Hafalan AI scoring. Server: `server/` (FastAPI + faster-whisper + Levenshtein). |

Wire rules:

- Every response is parsed by a zod schema before it reaches the app. Unknown field → ignore; missing required field → typed `ParseError`, surfaced as a retryable failure.
- API shape changes are handled in `schema.ts`, never in components.
- `/health` is called when the setoran screen opens (HF Spaces sleeps), not when the user taps record.
- Upload body: `FormData` with `{ uri, name: 'recording.m4a', type: 'audio/m4a' }`; `AbortController` with a 120 s timeout; one retry on network failure only.

Local SQLite (`qurva.db`):

```
surah(number PK, name, latin, ayat_count, revelation, synced_at)
ayah(surah_number, number, text_arabic, text_latin, translation, PRIMARY KEY(surah_number, number))
tafsir(surah_number PK, content, synced_at)
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

**Sensors.** Qibla reads heading from `react-native-compass-heading`, smoothed with an exponential moving average; fall back to "device does not support compass" rather than showing a wrong direction. Never request `HIGH_SAMPLING_RATE_SENSORS` unnecessarily.

**Hafalan reminders.** On save, compute the next muraja'ah date from `[1, 3, 7, 30, 90]` days by level, cancel the previous notification, schedule a new one, and persist `notification_id` in `notification_ref`. Missing this bookkeeping is the classic bug: stale notifications accumulate.

## 7. Error, offline, and i18n policy

- One `Result<T, AppError>` type in `lib/result.ts`; `AppError` has codes (`network`, `timeout`, `parse`, `notFound`, `permission`, `server`). UI maps codes to i18n messages; repositories never format user-facing strings.
- Offline: surah/tafsir render from SQLite; audio requires network. Every list screen has an empty, loading, and error state — no screen renders raw errors.
- All user-facing copy goes through i18next (`id` default, `en` secondary). Domain and data layers contain no strings.

## 8. Testing

| Level | Tool | What must be covered |
|---|---|---|
| Unit | Jest (`jest-expo`) | Muraja'ah interval math, ayah global numbering, prayer-time inputs, zod schema edge cases, heading smoothing |
| Integration | Jest + `expo-sqlite` in memory | Repository read/write, notification bookkeeping |
| Component | RNTL | One happy path per critical component (setoran result, surah card) |
| E2E | Maestro (1 flow) | Open surah → play → pause from lock screen → open setoran |

A new rule, parser, or scheduling calculation without a test is not done.

## 9. Delivery phases

1. **Spike (2 weeks, gates the rest).** Prove on a physical device: `alarmClock` notification with screen off, 30 min background audio, Android widget via `expo-widgets`, Arabic mushaf-style text rendering. If alarm or Arabic text fails, stop and re-evaluate.
2. **Foundation.** Scaffold with `bun create expo --template default@sdk-58`, prebuild, expo-router, NativeWind tokens, i18n, CI, onboarding.
3. **Quran reading.** Surah list/detail/tafsir, SQLite + Query, offline.
4. **Audio.** Playlist, lock screen, per-ayah seek.
5. **Prayer + qibla.** adhan-js, location, alarm, compass.
6. **Hafalan.** Record → upload → compare → save → schedule → reminder → history → stats.
7. **Widget + polish + README** with screenshots and the three "lessons learned" notes.

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
- `server/` and the Hugging Face Space are external dependencies; the setoran UI needs a demo fallback so the repo runs without them.
