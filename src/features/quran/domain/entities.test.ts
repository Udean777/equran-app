import {
  type Ayah,
  filterAyat,
  filterSurahs,
  filterTafsirEntries,
  shouldShowBasmalahHeader,
  type SurahSummary,
  type TafsirEntry,
} from "./entities";

const SAMPLE_SURAHS: readonly SurahSummary[] = [
  {
    number: 1,
    name: "الفاتحة",
    latin: "Al-Fatihah",
    ayatCount: 7,
    revelation: "Mekah",
  },
  {
    number: 2,
    name: "البقرة",
    latin: "Al-Baqarah",
    ayatCount: 286,
    revelation: "Madinah",
  },
  {
    number: 9,
    name: "التوبة",
    latin: "At-Taubah",
    ayatCount: 129,
    revelation: "Madinah",
  },
];

const SAMPLE_AYAT: readonly Ayah[] = [
  {
    surahNumber: 1,
    number: 1,
    textArabic: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
    textLatin: "Bismillahir-rahmanir-rahim",
    translation: "Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.",
  },
  {
    surahNumber: 1,
    number: 2,
    textArabic: "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
    textLatin: "Al-hamdu lillahi rabbil-'alamin",
    translation: "Segala puji bagi Allah, Tuhan seluruh alam.",
  },
];

const SAMPLE_TAFSIR: readonly TafsirEntry[] = [
  { ayahNumber: 1, text: "Tafsir basmalah pembuka surah." },
  { ayahNumber: 2, text: "Tafsir pujian kepada Allah." },
];

describe("filterSurahs", () => {
  it("returns all surahs when query is empty or whitespace", () => {
    expect(filterSurahs(SAMPLE_SURAHS, "")).toEqual(SAMPLE_SURAHS);
    expect(filterSurahs(SAMPLE_SURAHS, "   ")).toEqual(SAMPLE_SURAHS);
  });

  it("filters by latin name case-insensitively", () => {
    expect(filterSurahs(SAMPLE_SURAHS, "baqarah")).toEqual([SAMPLE_SURAHS[1]]);
  });

  it("filters by exact surah number or arabic name", () => {
    expect(filterSurahs(SAMPLE_SURAHS, "9")).toEqual([SAMPLE_SURAHS[2]]);
    expect(filterSurahs(SAMPLE_SURAHS, "الفاتحة")).toEqual([SAMPLE_SURAHS[0]]);
  });

  it("filters by revelation place combined with search query", () => {
    expect(filterSurahs(SAMPLE_SURAHS, "", "Mekah")).toEqual([
      SAMPLE_SURAHS[0],
    ]);
    expect(filterSurahs(SAMPLE_SURAHS, "taubah", "Madinah")).toEqual([
      SAMPLE_SURAHS[2],
    ]);
    expect(filterSurahs(SAMPLE_SURAHS, "taubah", "Mekah")).toEqual([]);
  });
});

describe("filterAyat and filterTafsirEntries", () => {
  it("filters ayat by number, translation, or latin text", () => {
    expect(filterAyat(SAMPLE_AYAT, "")).toEqual(SAMPLE_AYAT);
    expect(filterAyat(SAMPLE_AYAT, "2")).toEqual([SAMPLE_AYAT[1]]);
    expect(filterAyat(SAMPLE_AYAT, "pengasih")).toEqual([SAMPLE_AYAT[0]]);
  });

  it("filters tafsir entries by ayah number or text keyword", () => {
    expect(filterTafsirEntries(SAMPLE_TAFSIR, "")).toEqual(SAMPLE_TAFSIR);
    expect(filterTafsirEntries(SAMPLE_TAFSIR, "2")).toEqual([SAMPLE_TAFSIR[1]]);
    expect(filterTafsirEntries(SAMPLE_TAFSIR, "basmalah")).toEqual([
      SAMPLE_TAFSIR[0],
    ]);
  });
});

describe("shouldShowBasmalahHeader", () => {
  it("hides basmalah header for Al-Fatihah and At-Taubah", () => {
    expect(shouldShowBasmalahHeader(1)).toBe(false);
    expect(shouldShowBasmalahHeader(9)).toBe(false);
  });

  it("shows basmalah header for all other surahs", () => {
    expect(shouldShowBasmalahHeader(2)).toBe(true);
    expect(shouldShowBasmalahHeader(114)).toBe(true);
  });
});
