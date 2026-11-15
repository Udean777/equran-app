import { getThemeMode, setThemeMode } from "@/lib/storage/prefs";

import { useThemeStore } from "./use-theme-store";

describe("useThemeStore", () => {
  beforeEach(() => {
    setThemeMode("dark");
    useThemeStore.getState().hydrate();
  });

  it("switches between light, dark, and system modes and persists to storage", () => {
    useThemeStore.getState().setMode("light");
    expect(useThemeStore.getState().mode).toBe("light");
    expect(getThemeMode()).toBe("light");

    useThemeStore.getState().setMode("dark");
    expect(useThemeStore.getState().mode).toBe("dark");
    expect(getThemeMode()).toBe("dark");

    useThemeStore.getState().setMode("system");
    expect(useThemeStore.getState().mode).toBe("system");
    expect(getThemeMode()).toBe("system");
  });
});
