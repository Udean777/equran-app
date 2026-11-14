import {
  clearAllPrefs,
  getLanguage,
  getOnboardingDone,
  getQari,
  getThemeMode,
  PREF_KEYS,
  prefsStorage,
  setLanguage,
  setOnboardingDone,
  setQari,
  setThemeMode,
} from "./prefs";

describe("prefs", () => {
  beforeEach(() => {
    clearAllPrefs();
  });

  it("returns safe defaults when storage is empty", () => {
    expect(getOnboardingDone()).toBe(false);
    expect(getThemeMode()).toBe("dark");
    expect(getQari()).toBe("ar.alafasy");
    expect(getLanguage()).toBe("id");
    expect(getLanguage("en")).toBe("en");
  });

  it("persists and reads typed preference values", () => {
    setOnboardingDone(true);
    setThemeMode("light");
    setQari("ar.husary");
    setLanguage("en");

    expect(getOnboardingDone()).toBe(true);
    expect(getThemeMode()).toBe("light");
    expect(getQari()).toBe("ar.husary");
    expect(getLanguage()).toBe("en");
  });

  it("falls back to defaults when stored values fail zod parsing", () => {
    prefsStorage.set(PREF_KEYS.onboardingDone, "not-a-boolean");
    prefsStorage.set(PREF_KEYS.theme, "sepia");
    prefsStorage.set(PREF_KEYS.qari, "unknown.qari");
    prefsStorage.set(PREF_KEYS.language, "fr");

    expect(getOnboardingDone()).toBe(false);
    expect(getThemeMode()).toBe("dark");
    expect(getQari()).toBe("ar.alafasy");
    expect(getLanguage()).toBe("id");
  });
});
