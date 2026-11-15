# Features

What ships in Qurva RN today, and how each part behaves. For scope decisions see
[design.md](../design.md) §1.

## Status

| Feature | Status |
|---|---|
| Onboarding (4 slides, replayable) | Shipped |
| Surah list, reader, tafsir (id/en) | Shipped |
| Murattal audio (per ayah and per surah) | Shipped |
| Prayer times and alarms | Shipped |
| Qibla compass | Shipped |
| Hafalan with AI scoring and reminders | Shipped |
| Settings (theme, language, qari) | Shipped |
| Doa and dzikir, semantic search | Planned (design.md §9, phase 7) |
| Android home screen widget | Planned (phase 8) |

## Quran reader

- Data comes from `equran.id` (`/api/v2` for Indonesian and tafsir, `/api/en` for English) and is
  parsed with zod before use.
- Surah list and detail are cached in SQLite, so the reader works offline after the first load.
  English translation is hydrated lazily into the same table.
- The reader searches within a surah by ayah number or translation text.
- The last read position is stored and surfaced as a hero card on the surah list.
- Tafsir has its own screen per surah with ayah search.

## Murattal audio

- Built on `expo-audio` playlists: one ayah, or a whole surah as a gapless queue.
- Background playback and lock screen controls are enabled; a floating mini player gives
  previous, play/pause, next, and close.
- Qari is chosen in Settings. Audio URLs follow `cdn.islamic.network/.../{qari}/{globalAyah}.mp3`.
- When the device is offline, an inline notice is shown. Audio is not cached beyond the OS.

## Prayer times and alarms

- Times are calculated with `adhan` from the device location, with no network request.
- The hero card shows the next prayer and a live countdown.
- Each prayer can have an alarm, delivered as an `alarmClock` notification. Android 12+ needs the
  exact-alarm permission, which is requested in context.
- Alarm identifiers are persisted and cancelled before rescheduling, so stale alarms do not pile up.
- Android only. iOS cannot match alarm behaviour, and the copy does not promise it.

## Qibla compass

- Heading comes from `react-native-compass-heading`, smoothed with an exponential moving average
  in unwrapped degrees, so the needle never takes the 359° to 0° long way.
- Animation runs on the UI thread through Reanimated. React state (digits, aligned badge) updates
  at most 5 times per second.
- The qibla bearing is true-north, the sensor is magnetic-north. The app reads the declination
  once per session and falls back to magnetic with no silent error. A missing sensor shows an
  explicit "not supported" state.

## Hafalan

1. Choose a surah and ayah range as a target.
2. Record a **setoran**. The audio is uploaded to the scoring service in `server/`
   (FastAPI, faster-whisper, Levenshtein character error rate).
3. The result is shown with a score, and saved to history.
4. A muraja'ah reminder is scheduled from the level intervals `[1, 3, 7, 30, 90]` days. The
   previous notification is cancelled first, and the new id stored in `notification_ref`.

If the service is unreachable the app shows a retryable error. It never fabricates a score.

## Settings, theme, language

- Light, dark, or system theme, backed by tokens in `tailwind.config.js` and `src/theme/`.
- Indonesian and English UI through i18next (`src/lib/locales/`). Every new string needs both.
- Preferences (theme, language, qari, onboarding flag) live in MMKV.
- Onboarding can be replayed from Settings.
