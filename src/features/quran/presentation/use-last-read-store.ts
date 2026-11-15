import { create } from "zustand";

import {
  getLastReadSurah,
  type LastReadSurah,
  setLastReadSurah,
} from "@/lib/storage/prefs";

type LastReadState = Readonly<{
  lastRead: LastReadSurah | null;
  hydrate: () => void;
  recordLastRead: (surah: LastReadSurah) => void;
}>;

export const useLastReadStore = create<LastReadState>((set) => ({
  lastRead: getLastReadSurah(),
  hydrate: () => {
    set({ lastRead: getLastReadSurah() });
  },
  recordLastRead: (surah) => {
    setLastReadSurah(surah);
    set({ lastRead: surah });
  },
}));
