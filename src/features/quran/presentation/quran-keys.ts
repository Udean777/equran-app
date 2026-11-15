import { type QuranLanguage } from "../domain/entities";

export const quranKeys = {
  all: ["quran"] as const,
  surahList: () => [...quranKeys.all, "surah-list"] as const,
  surahDetail: (surahNumber: number, language: QuranLanguage = "id") =>
    [...quranKeys.all, "surah-detail", surahNumber, language] as const,
  tafsir: (surahNumber: number) =>
    [...quranKeys.all, "tafsir", surahNumber] as const,
};
