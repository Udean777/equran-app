export const quranKeys = {
  all: ["quran"] as const,
  surahList: () => [...quranKeys.all, "surah-list"] as const,
  surahDetail: (surahNumber: number) =>
    [...quranKeys.all, "surah-detail", surahNumber] as const,
  tafsir: (surahNumber: number) =>
    [...quranKeys.all, "tafsir", surahNumber] as const,
};
