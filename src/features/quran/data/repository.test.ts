import { err, ok } from "@/lib/result";

import {
  fetchEnglishSurahDetail,
  fetchSurahDetail,
  fetchSurahList,
  fetchSurahTafsir,
} from "./api";
import { getSurahDetail, getSurahList, getSurahTafsir } from "./repository";

const mockGetAllSync = jest.fn();
const mockGetFirstSync = jest.fn();
const mockRunSync = jest.fn();
const mockWithTransactionSync = jest.fn((fn: () => void) => fn());

jest.mock("@/lib/db/client", () => ({
  db: {
    getAllSync: (...args: unknown[]) => mockGetAllSync(...args),
    getFirstSync: (...args: unknown[]) => mockGetFirstSync(...args),
    runSync: (...args: unknown[]) => mockRunSync(...args),
    withTransactionSync: (fn: () => void) => mockWithTransactionSync(fn),
  },
}));

jest.mock("./api", () => ({
  fetchSurahList: jest.fn(),
  fetchSurahDetail: jest.fn(),
  fetchEnglishSurahDetail: jest.fn(),
  fetchSurahTafsir: jest.fn(),
}));

describe("quran repository", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it("returns cached 114 surahs from SQLite without hitting API", async () => {
    const cachedRows = Array.from({ length: 114 }, (_, i) => ({
      number: i + 1,
      name: "الفاتحة",
      latin: `Surah ${i + 1}`,
      ayat_count: 7,
      revelation: "Mekah",
      synced_at: 1000,
    }));
    mockGetAllSync.mockReturnValue(cachedRows);

    const result = await getSurahList();
    expect(result.ok).toBe(true);
    if (result.ok) {
      expect(result.value).toHaveLength(114);
      expect(result.value[0]?.number).toBe(1);
    }
    expect(fetchSurahList).not.toHaveBeenCalled();
  });

  it("fetches surah list from API and caches to SQLite when cache is empty", async () => {
    mockGetAllSync.mockReturnValue([]);
    jest.mocked(fetchSurahList).mockResolvedValue(
      ok([
        {
          number: 1,
          name: "الفاتحة",
          latin: "Al-Fatihah",
          ayatCount: 7,
          revelation: "Mekah",
        },
      ]),
    );

    const result = await getSurahList();
    expect(result.ok).toBe(true);
    expect(fetchSurahList).toHaveBeenCalledTimes(1);
    expect(mockWithTransactionSync).toHaveBeenCalledTimes(1);
    expect(mockRunSync).toHaveBeenCalledTimes(1);
  });

  it("returns cached surah detail when ayah count matches", async () => {
    mockGetFirstSync.mockReturnValue({
      number: 1,
      name: "الفاتحة",
      latin: "Al-Fatihah",
      ayat_count: 1,
      revelation: "Mekah",
      synced_at: 1000,
    });
    mockGetAllSync.mockReturnValue([
      {
        surah_number: 1,
        number: 1,
        text_arabic: "بِسْمِ اللّٰهِ",
        text_latin: "Bismillah",
        translation: "Dengan nama Allah",
      },
    ]);

    const result = await getSurahDetail(1);
    expect(result.ok).toBe(true);
    expect(fetchSurahDetail).not.toHaveBeenCalled();
  });

  it("returns notFound error for invalid surah numbers", async () => {
    const detailResult = await getSurahDetail(0);
    const tafsirResult = await getSurahTafsir(115);

    expect(detailResult).toEqual(err("notFound", "Invalid surah number: 0"));
    expect(tafsirResult).toEqual(err("notFound", "Invalid surah number: 115"));
    expect(fetchSurahDetail).not.toHaveBeenCalled();
    expect(fetchSurahTafsir).not.toHaveBeenCalled();
  });

  it("fetches tafsir from API and caches JSON when not in SQLite", async () => {
    mockGetFirstSync.mockReturnValue(null);
    jest.mocked(fetchSurahTafsir).mockResolvedValue(
      ok({
        surah: {
          number: 1,
          name: "الفاتحة",
          latin: "Al-Fatihah",
          ayatCount: 7,
          revelation: "Mekah",
        },
        entries: [{ ayahNumber: 1, text: "Tafsir 1" }],
      }),
    );

    const result = await getSurahTafsir(1);
    expect(result.ok).toBe(true);
    expect(fetchSurahTafsir).toHaveBeenCalledWith(1, undefined);
    expect(mockWithTransactionSync).toHaveBeenCalledTimes(1);
  });

  it("lazily hydrates English translation when translation_en is missing in SQLite", async () => {
    mockGetFirstSync.mockReturnValue({
      number: 1,
      name: "الفاتحة",
      latin: "Al-Fatihah",
      ayat_count: 1,
      revelation: "Mekah",
      synced_at: 1000,
    });
    mockGetAllSync.mockReturnValue([
      {
        surah_number: 1,
        number: 1,
        text_arabic: "بِسْمِ اللّٰهِ",
        text_latin: "Bismillah",
        translation: "Dengan nama Allah",
        translation_en: null,
      },
    ]);
    jest.mocked(fetchEnglishSurahDetail).mockResolvedValue(
      ok({
        surah: {
          number: 1,
          name: "الفاتحة",
          latin: "Al-Fatihah",
          ayatCount: 1,
          revelation: "Mekah",
        },
        ayat: [
          {
            surahNumber: 1,
            number: 1,
            textArabic: "بِسْمِ اللّٰهِ",
            textLatin: "Bismillah",
            translation: "In the name of God",
          },
        ],
      }),
    );

    const result = await getSurahDetail(1, "en");
    expect(result.ok).toBe(true);
    expect(fetchEnglishSurahDetail).toHaveBeenCalledWith(1, undefined);
    expect(mockRunSync).toHaveBeenCalledWith(
      expect.stringContaining("ON CONFLICT(surah_number, number) DO UPDATE"),
      1,
      1,
      "بِسْمِ اللّٰهِ",
      "Bismillah",
      "In the name of God",
    );
  });

  it("returns cached English translation without hitting API", async () => {
    mockGetFirstSync.mockReturnValue({
      number: 1,
      name: "الفاتحة",
      latin: "Al-Fatihah",
      ayat_count: 1,
      revelation: "Mekah",
      synced_at: 1000,
    });
    mockGetAllSync.mockReturnValue([
      {
        surah_number: 1,
        number: 1,
        text_arabic: "بِسْمِ اللّٰهِ",
        text_latin: "Bismillah",
        translation: "Dengan nama Allah",
        translation_en: "In the name of God",
      },
    ]);

    const result = await getSurahDetail(1, "en");
    expect(result.ok).toBe(true);
    if (result.ok) {
      expect(result.value.ayat[0]?.translation).toBe("In the name of God");
    }
    expect(fetchEnglishSurahDetail).not.toHaveBeenCalled();
  });
});
