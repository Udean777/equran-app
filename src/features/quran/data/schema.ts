import { z } from "zod";

import {
  type Ayah,
  type QuranLanguage,
  type RevelationPlace,
  type SurahDetail,
  type SurahSummary,
  type SurahTafsir,
  type TafsirEntry,
} from "../domain/entities";

export const RevelationPlaceSchema = z.enum(["Mekah", "Madinah"]);
export const EnglishRevelationTypeSchema = z.enum(["Meccan", "Medinan"]);

export const SurahNumberSchema = z.coerce.number().int().min(1).max(114);

export const SuratDtoSchema = z.object({
  nomor: z.number().int().min(1).max(114),
  nama: z.string().min(1),
  namaLatin: z.string().min(1),
  jumlahAyat: z.number().int().positive(),
  tempatTurun: RevelationPlaceSchema,
});

export const SuratListResponseSchema = z.object({
  code: z.number().int(),
  message: z.string(),
  data: z.array(SuratDtoSchema),
});

export const AyatDtoSchema = z.object({
  nomorAyat: z.number().int().positive(),
  teksArab: z.string().min(1),
  teksLatin: z.string(),
  teksIndonesia: z.string(),
});

export const SuratDetailDtoSchema = SuratDtoSchema.extend({
  ayat: z.array(AyatDtoSchema),
});

export const SuratDetailResponseSchema = z.object({
  code: z.number().int(),
  message: z.string(),
  data: SuratDetailDtoSchema,
});

export const TafsirAyatDtoSchema = z.object({
  ayat: z.number().int().positive(),
  teks: z.string().min(1),
});

export const TafsirDataDtoSchema = SuratDtoSchema.extend({
  tafsir: z.array(TafsirAyatDtoSchema),
});

export const TafsirResponseSchema = z.object({
  code: z.number().int(),
  message: z.string(),
  data: TafsirDataDtoSchema,
});

export const EnglishAyahDtoSchema = z.object({
  numberInSurah: z.number().int().positive(),
  textArabic: z.string().min(1),
  textLatin: z.string(),
  textEnglish: z.string(),
});

export const EnglishSuratDetailDtoSchema = z.object({
  number: z.number().int().min(1).max(114),
  name: z.string().min(1),
  englishName: z.string().min(1),
  numberOfAyahs: z.number().int().positive(),
  revelationType: EnglishRevelationTypeSchema,
  ayahs: z.array(EnglishAyahDtoSchema),
});

export const EnglishSuratDetailResponseSchema = z.object({
  code: z.number().int(),
  message: z.string(),
  data: EnglishSuratDetailDtoSchema,
});

export const SurahRowSchema = z.object({
  number: z.number().int().min(1).max(114),
  name: z.string().min(1),
  latin: z.string().min(1),
  ayat_count: z.number().int().positive(),
  revelation: RevelationPlaceSchema,
  synced_at: z.number().int().nonnegative(),
});

export const AyahRowSchema = z.object({
  surah_number: z.number().int().min(1).max(114),
  number: z.number().int().positive(),
  text_arabic: z.string().min(1),
  text_latin: z.string(),
  translation: z.string(),
  translation_en: z.string().nullable().optional(),
});

export const TafsirEntrySchema = z.object({
  ayahNumber: z.number().int().positive(),
  text: z.string().min(1),
});

export const TafsirEntriesJsonSchema = z.array(TafsirEntrySchema);

export const TafsirRowSchema = z.object({
  surah_number: z.number().int().min(1).max(114),
  content: z.string().min(2),
  synced_at: z.number().int().nonnegative(),
});

export type SuratDto = z.infer<typeof SuratDtoSchema>;
export type SuratDetailDto = z.infer<typeof SuratDetailDtoSchema>;
export type TafsirDataDto = z.infer<typeof TafsirDataDtoSchema>;
export type EnglishSuratDetailDto = z.infer<typeof EnglishSuratDetailDtoSchema>;
export type SurahRow = z.infer<typeof SurahRowSchema>;
export type AyahRow = z.infer<typeof AyahRowSchema>;

const toRevelation = (value: RevelationPlace): RevelationPlace => value;

const toRevelationFromEnglish = (
  value: z.infer<typeof EnglishRevelationTypeSchema>,
): RevelationPlace => (value === "Meccan" ? "Mekah" : "Madinah");

export const mapSurahDtoToDomain = (dto: SuratDto): SurahSummary => ({
  number: dto.nomor,
  name: dto.nama,
  latin: dto.namaLatin,
  ayatCount: dto.jumlahAyat,
  revelation: toRevelation(dto.tempatTurun),
});

export const mapSurahRowToDomain = (row: SurahRow): SurahSummary => ({
  number: row.number,
  name: row.name,
  latin: row.latin,
  ayatCount: row.ayat_count,
  revelation: toRevelation(row.revelation),
});

export const mapAyahRowToDomain = (
  row: AyahRow,
  language: QuranLanguage = "id",
): Ayah => ({
  surahNumber: row.surah_number,
  number: row.number,
  textArabic: row.text_arabic,
  textLatin: row.text_latin,
  translation: language === "en" ? (row.translation_en ?? "") : row.translation,
});

export const mapEnglishSurahDetailDtoToDomain = (
  dto: EnglishSuratDetailDto,
): SurahDetail => ({
  surah: {
    number: dto.number,
    name: dto.name,
    latin: dto.englishName,
    ayatCount: dto.numberOfAyahs,
    revelation: toRevelationFromEnglish(dto.revelationType),
  },
  ayat: dto.ayahs.map((ayah) => ({
    surahNumber: dto.number,
    number: ayah.numberInSurah,
    textArabic: ayah.textArabic,
    textLatin: ayah.textLatin,
    translation: ayah.textEnglish,
  })),
});

export const mapSurahDetailDtoToDomain = (
  dto: SuratDetailDto,
): SurahDetail => ({
  surah: mapSurahDtoToDomain(dto),
  ayat: dto.ayat.map((ayah) => ({
    surahNumber: dto.nomor,
    number: ayah.nomorAyat,
    textArabic: ayah.teksArab,
    textLatin: ayah.teksLatin,
    translation: ayah.teksIndonesia,
  })),
});

export const mapTafsirDtoToDomain = (dto: TafsirDataDto): SurahTafsir => ({
  surah: mapSurahDtoToDomain(dto),
  entries: dto.tafsir.map((entry): TafsirEntry => ({
    ayahNumber: entry.ayat,
    text: entry.teks,
  })),
});
