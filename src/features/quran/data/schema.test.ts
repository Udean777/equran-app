import {
  mapSurahDetailDtoToDomain,
  mapSurahDtoToDomain,
  mapTafsirDtoToDomain,
  SuratDetailResponseSchema,
  SuratListResponseSchema,
  TafsirResponseSchema,
} from "./schema";

describe("quran schemas", () => {
  it("parses surah list response and ignores unknown fields", () => {
    const payload = {
      code: 200,
      message: "Data retrieved successfully",
      data: [
        {
          nomor: 1,
          nama: "الفاتحة",
          namaLatin: "Al-Fatihah",
          jumlahAyat: 7,
          tempatTurun: "Mekah",
          arti: "Pembukaan",
          audioFull: { "05": "https://example.com/001.mp3" },
        },
      ],
    };

    const parsed = SuratListResponseSchema.safeParse(payload);
    expect(parsed.success).toBe(true);
    if (parsed.success) {
      expect(parsed.data.data.map(mapSurahDtoToDomain)).toEqual([
        {
          number: 1,
          name: "الفاتحة",
          latin: "Al-Fatihah",
          ayatCount: 7,
          revelation: "Mekah",
        },
      ]);
    }
  });

  it("rejects surah list payload with missing required fields", () => {
    const parsed = SuratListResponseSchema.safeParse({
      code: 200,
      message: "ok",
      data: [{ nomor: 1, nama: "الفاتحة" }],
    });
    expect(parsed.success).toBe(false);
  });

  it("parses surah detail and maps ayahs", () => {
    const payload = {
      code: 200,
      message: "ok",
      data: {
        nomor: 1,
        nama: "الفاتحة",
        namaLatin: "Al-Fatihah",
        jumlahAyat: 1,
        tempatTurun: "Mekah",
        suratSelanjutnya: false,
        suratSebelumnya: false,
        ayat: [
          {
            nomorAyat: 1,
            teksArab: "بِسْمِ اللّٰهِ",
            teksLatin: "Bismillāh",
            teksIndonesia: "Dengan nama Allah",
          },
        ],
      },
    };

    const parsed = SuratDetailResponseSchema.safeParse(payload);
    expect(parsed.success).toBe(true);
    if (parsed.success) {
      const detail = mapSurahDetailDtoToDomain(parsed.data.data);
      expect(detail.surah.latin).toBe("Al-Fatihah");
      expect(detail.ayat).toEqual([
        {
          surahNumber: 1,
          number: 1,
          textArabic: "بِسْمِ اللّٰهِ",
          textLatin: "Bismillāh",
          translation: "Dengan nama Allah",
        },
      ]);
    }
  });

  it("parses tafsir response and maps entries", () => {
    const payload = {
      code: 200,
      message: "ok",
      data: {
        nomor: 1,
        nama: "الفاتحة",
        namaLatin: "Al-Fatihah",
        jumlahAyat: 7,
        tempatTurun: "Mekah",
        tafsir: [{ ayat: 1, teks: "Tafsir ayat pertama." }],
      },
    };

    const parsed = TafsirResponseSchema.safeParse(payload);
    expect(parsed.success).toBe(true);
    if (parsed.success) {
      const tafsir = mapTafsirDtoToDomain(parsed.data.data);
      expect(tafsir.entries).toEqual([
        { ayahNumber: 1, text: "Tafsir ayat pertama." },
      ]);
    }
  });
});
