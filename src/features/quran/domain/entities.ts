export type RevelationPlace = "Mekah" | "Madinah";
export type RevelationFilter = "all" | RevelationPlace;

export type SurahSummary = Readonly<{
  number: number;
  name: string;
  latin: string;
  ayatCount: number;
  revelation: RevelationPlace;
}>;

export type Ayah = Readonly<{
  surahNumber: number;
  number: number;
  textArabic: string;
  textLatin: string;
  translation: string;
}>;

export type SurahDetail = Readonly<{
  surah: SurahSummary;
  ayat: readonly Ayah[];
}>;

export type TafsirEntry = Readonly<{
  ayahNumber: number;
  text: string;
}>;

export type SurahTafsir = Readonly<{
  surah: SurahSummary;
  entries: readonly TafsirEntry[];
}>;

export const filterSurahs = (
  surahs: readonly SurahSummary[],
  query: string,
  revelation: RevelationFilter = "all",
): readonly SurahSummary[] => {
  const byRevelation =
    revelation === "all"
      ? surahs
      : surahs.filter((surah) => surah.revelation === revelation);

  const normalized = query.trim().toLowerCase();
  if (normalized.length === 0) return byRevelation;

  return byRevelation.filter(
    (surah) =>
      surah.latin.toLowerCase().includes(normalized) ||
      surah.name.includes(normalized) ||
      String(surah.number) === normalized,
  );
};

export const filterAyat = (
  ayat: readonly Ayah[],
  query: string,
): readonly Ayah[] => {
  const normalized = query.trim().toLowerCase();
  if (normalized.length === 0) return ayat;

  return ayat.filter(
    (item) =>
      String(item.number) === normalized ||
      item.translation.toLowerCase().includes(normalized) ||
      item.textLatin.toLowerCase().includes(normalized),
  );
};

export const filterTafsirEntries = (
  entries: readonly TafsirEntry[],
  query: string,
): readonly TafsirEntry[] => {
  const normalized = query.trim().toLowerCase();
  if (normalized.length === 0) return entries;

  return entries.filter(
    (entry) =>
      String(entry.ayahNumber) === normalized ||
      entry.text.toLowerCase().includes(normalized),
  );
};

export const shouldShowBasmalahHeader = (surahNumber: number): boolean =>
  surahNumber !== 1 && surahNumber !== 9;
