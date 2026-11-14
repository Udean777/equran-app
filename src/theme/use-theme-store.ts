import { create } from "zustand";

import {
  getThemeMode,
  setThemeMode,
  type ThemeMode,
} from "@/lib/storage/prefs";

type ThemeStore = Readonly<{
  mode: ThemeMode;
  hydrate: () => void;
  setMode: (mode: ThemeMode) => void;
}>;

export const useThemeStore = create<ThemeStore>((set) => ({
  mode: getThemeMode(),
  hydrate: () => {
    set({ mode: getThemeMode() });
  },
  setMode: (mode) => {
    setThemeMode(mode);
    set({ mode });
  },
}));
