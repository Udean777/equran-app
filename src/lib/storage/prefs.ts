import { MMKV } from "react-native-mmkv";
import { z } from "zod";

export const ThemeModeSchema = z.enum(["dark", "light", "system"]);
export type ThemeMode = z.infer<typeof ThemeModeSchema>;

export const AppLanguageSchema = z.enum(["id", "en"]);
export type AppLanguage = z.infer<typeof AppLanguageSchema>;

export const QariIdSchema = z.enum([
  "ar.alafasy",
  "ar.abdurrahmaansudais",
  "ar.husary",
  "ar.minshawi",
]);
export type QariId = z.infer<typeof QariIdSchema>;

export const LastReadSurahSchema = z.object({
  number: z.number().int().min(1).max(114),
  name: z.string().min(1),
  latin: z.string().min(1),
  ayatCount: z.number().int().positive(),
});
export type LastReadSurah = z.infer<typeof LastReadSurahSchema>;

export const PREF_KEYS = {
  onboardingDone: "onboarding_done",
  theme: "theme",
  qari: "qari",
  language: "language",
  lastReadSurah: "last_read_surah",
  lastLocation: "last_location",
  prayerAlarmsEnabled: "prayer_alarms_enabled",
  prayerNotificationIds: "prayer_notification_ids",
} as const;

export const prefsStorage = new MMKV({ id: "qurva.prefs" });

const OnboardingDoneSchema = z.boolean();

export const getOnboardingDone = (): boolean => {
  const parsed = OnboardingDoneSchema.safeParse(
    prefsStorage.getBoolean(PREF_KEYS.onboardingDone),
  );
  return parsed.success ? parsed.data : false;
};

export const setOnboardingDone = (done: boolean): void => {
  prefsStorage.set(PREF_KEYS.onboardingDone, done);
};

export const getThemeMode = (): ThemeMode => {
  const parsed = ThemeModeSchema.safeParse(
    prefsStorage.getString(PREF_KEYS.theme),
  );
  return parsed.success ? parsed.data : "dark";
};

export const setThemeMode = (mode: ThemeMode): void => {
  prefsStorage.set(PREF_KEYS.theme, mode);
};

export const getQari = (): QariId => {
  const parsed = QariIdSchema.safeParse(prefsStorage.getString(PREF_KEYS.qari));
  return parsed.success ? parsed.data : "ar.alafasy";
};

export const setQari = (qari: QariId): void => {
  prefsStorage.set(PREF_KEYS.qari, qari);
};

export const getLanguage = (fallback: AppLanguage = "id"): AppLanguage => {
  const parsed = AppLanguageSchema.safeParse(
    prefsStorage.getString(PREF_KEYS.language),
  );
  return parsed.success ? parsed.data : fallback;
};

export const setLanguage = (language: AppLanguage): void => {
  prefsStorage.set(PREF_KEYS.language, language);
};

const readJsonPref = <T>(key: string, schema: z.ZodType<T>, fallback: T): T => {
  const raw = prefsStorage.getString(key);
  if (!raw) return fallback;
  try {
    const parsed = schema.safeParse(JSON.parse(raw));
    return parsed.success ? parsed.data : fallback;
  } catch {
    return fallback;
  }
};

export const getLastReadSurah = (): LastReadSurah | null =>
  readJsonPref(PREF_KEYS.lastReadSurah, LastReadSurahSchema, null);

export const setLastReadSurah = (surah: LastReadSurah): void => {
  prefsStorage.set(PREF_KEYS.lastReadSurah, JSON.stringify(surah));
};

export const LastLocationSchema = z.object({
  latitude: z.number().min(-90).max(90),
  longitude: z.number().min(-180).max(180),
  city: z.string().optional(),
  updatedAt: z.number(),
});

export type LastLocation = z.infer<typeof LastLocationSchema>;

export const getLastLocation = (): LastLocation | undefined =>
  readJsonPref(PREF_KEYS.lastLocation, LastLocationSchema, undefined);

export const setLastLocation = (location: LastLocation): void => {
  prefsStorage.set(PREF_KEYS.lastLocation, JSON.stringify(location));
};

export const getPrayerAlarmsEnabled = (): boolean =>
  prefsStorage.getBoolean(PREF_KEYS.prayerAlarmsEnabled) ?? true;

export const setPrayerAlarmsEnabled = (enabled: boolean): void => {
  prefsStorage.set(PREF_KEYS.prayerAlarmsEnabled, enabled);
};

const NotificationIdsSchema = z.array(z.string());

export const getPrayerNotificationIds = (): readonly string[] =>
  readJsonPref(PREF_KEYS.prayerNotificationIds, NotificationIdsSchema, []);

export const setPrayerNotificationIds = (ids: readonly string[]): void => {
  prefsStorage.set(PREF_KEYS.prayerNotificationIds, JSON.stringify(ids));
};

export const clearAllPrefs = (): void => {
  prefsStorage.clearAll();
};
