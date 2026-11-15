import { CalculationMethod, Coordinates, Prayer, PrayerTimes } from "adhan";

export type PrayerName =
  "fajr" | "sunrise" | "dhuhr" | "asr" | "maghrib" | "isha";

export type FardhPrayerName = "fajr" | "dhuhr" | "asr" | "maghrib" | "isha";

export type PrayerCalculationMethodId =
  "kemenag" | "muslimWorldLeague" | "egyptian" | "ummAlQura";

export type GeoCoordinates = Readonly<{
  latitude: number;
  longitude: number;
}>;

export type PrayerTimeEntry = Readonly<{
  name: PrayerName;
  time: Date;
  isFardh: boolean;
}>;

export type DailyPrayerSchedule = Readonly<{
  date: Date;
  entries: readonly PrayerTimeEntry[];
  nextPrayer: PrayerTimeEntry | null;
  remainingMs: number | null;
}>;

export type AlarmScheduleEntry = Readonly<{
  prayer: FardhPrayerName;
  triggerAt: Date;
}>;

// Jakarta fallback when GPS has not been granted yet.
export const DEFAULT_COORDINATES: GeoCoordinates = {
  latitude: -6.2088,
  longitude: 106.8456,
};

const getCalculationParams = (method: PrayerCalculationMethodId) => {
  switch (method) {
    case "muslimWorldLeague":
      return CalculationMethod.MuslimWorldLeague();
    case "egyptian":
      return CalculationMethod.Egyptian();
    case "ummAlQura":
      return CalculationMethod.UmmAlQura();
    case "kemenag":
    default:
      return CalculationMethod.Singapore();
  }
};

const mapAdhanNextPrayer = (
  prayer: (typeof Prayer)[keyof typeof Prayer],
): PrayerName | null => {
  switch (prayer) {
    case Prayer.Fajr:
      return "fajr";
    case Prayer.Sunrise:
      return "sunrise";
    case Prayer.Dhuhr:
      return "dhuhr";
    case Prayer.Asr:
      return "asr";
    case Prayer.Maghrib:
      return "maghrib";
    case Prayer.Isha:
      return "isha";
    default:
      return null;
  }
};

export const computeDailyPrayerTimes = (
  coords: GeoCoordinates,
  now: Date = new Date(),
  method: PrayerCalculationMethodId = "kemenag",
): DailyPrayerSchedule => {
  const adhanCoords = new Coordinates(coords.latitude, coords.longitude);
  const params = getCalculationParams(method);
  const times = new PrayerTimes(adhanCoords, now, params);

  const entries: readonly PrayerTimeEntry[] = [
    { name: "fajr", time: times.fajr, isFardh: true },
    { name: "sunrise", time: times.sunrise, isFardh: false },
    { name: "dhuhr", time: times.dhuhr, isFardh: true },
    { name: "asr", time: times.asr, isFardh: true },
    { name: "maghrib", time: times.maghrib, isFardh: true },
    { name: "isha", time: times.isha, isFardh: true },
  ];

  const nextName = mapAdhanNextPrayer(times.nextPrayer(now));
  let nextPrayer = nextName
    ? (entries.find((entry) => entry.name === nextName) ?? null)
    : null;

  if (!nextPrayer) {
    const tomorrow = new Date(now.getTime() + 24 * 60 * 60 * 1000);
    const tomorrowTimes = new PrayerTimes(adhanCoords, tomorrow, params);
    nextPrayer = { name: "fajr", time: tomorrowTimes.fajr, isFardh: true };
  }

  const remainingMs = Math.max(0, nextPrayer.time.getTime() - now.getTime());

  return {
    date: now,
    entries,
    nextPrayer,
    remainingMs,
  };
};

export const buildAlarmScheduleEntries = (
  coords: GeoCoordinates,
  now: Date = new Date(),
  method: PrayerCalculationMethodId = "kemenag",
): readonly AlarmScheduleEntry[] => {
  const adhanCoords = new Coordinates(coords.latitude, coords.longitude);
  const params = getCalculationParams(method);
  const tomorrow = new Date(now.getTime() + 24 * 60 * 60 * 1000);

  const todayTimes = new PrayerTimes(adhanCoords, now, params);
  const tomorrowTimes = new PrayerTimes(adhanCoords, tomorrow, params);

  const candidates: readonly AlarmScheduleEntry[] = [
    { prayer: "fajr", triggerAt: todayTimes.fajr },
    { prayer: "dhuhr", triggerAt: todayTimes.dhuhr },
    { prayer: "asr", triggerAt: todayTimes.asr },
    { prayer: "maghrib", triggerAt: todayTimes.maghrib },
    { prayer: "isha", triggerAt: todayTimes.isha },
    { prayer: "fajr", triggerAt: tomorrowTimes.fajr },
    { prayer: "dhuhr", triggerAt: tomorrowTimes.dhuhr },
    { prayer: "asr", triggerAt: tomorrowTimes.asr },
    { prayer: "maghrib", triggerAt: tomorrowTimes.maghrib },
    { prayer: "isha", triggerAt: tomorrowTimes.isha },
  ];

  const nowMs = now.getTime();
  return candidates.filter((item) => item.triggerAt.getTime() > nowMs);
};

export const formatCountdown = (remainingMs: number): string => {
  const totalSeconds = Math.max(0, Math.floor(remainingMs / 1000));
  const hours = Math.floor(totalSeconds / 3600);
  const minutes = Math.floor((totalSeconds % 3600) / 60);
  const seconds = totalSeconds % 60;

  const pad = (value: number) => String(value).padStart(2, "0");
  return `${pad(hours)}:${pad(minutes)}:${pad(seconds)}`;
};

export const formatPrayerClock = (date: Date): string => {
  const hours = String(date.getHours()).padStart(2, "0");
  const minutes = String(date.getMinutes()).padStart(2, "0");
  return `${hours}:${minutes}`;
};
