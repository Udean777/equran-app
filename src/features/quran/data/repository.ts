import { z } from "zod";

import { db } from "@/lib/db/client";
import { err, ok, type Result } from "@/lib/result";

import {
  type SurahDetail,
  type SurahSummary,
  type SurahTafsir,
} from "../domain/entities";
import { fetchSurahDetail, fetchSurahList, fetchSurahTafsir } from "./api";
import {
  AyahRowSchema,
  mapAyahRowToDomain,
  mapSurahRowToDomain,
  SurahNumberSchema,
  SurahRowSchema,
  TafsirEntriesJsonSchema,
  TafsirRowSchema,
} from "./schema";

const TOTAL_SURAH_COUNT = 114;

const upsertSurah = (surah: SurahSummary, now: number): void => {
  db.runSync(
    `INSERT OR REPLACE INTO surah (number, name, latin, ayat_count, revelation, synced_at)
     VALUES (?, ?, ?, ?, ?, ?)`,
    surah.number,
    surah.name,
    surah.latin,
    surah.ayatCount,
    surah.revelation,
    now,
  );
};

const readCachedSurah = (surahNumber: number): SurahSummary | null => {
  const row = db.getFirstSync<unknown>(
    "SELECT number, name, latin, ayat_count, revelation, synced_at FROM surah WHERE number = ?",
    surahNumber,
  );
  const parsed = SurahRowSchema.safeParse(row);
  return parsed.success ? mapSurahRowToDomain(parsed.data) : null;
};

export const getSurahList = async (
  signal?: AbortSignal,
): Promise<Result<readonly SurahSummary[]>> => {
  const rows = db.getAllSync<unknown>(
    "SELECT number, name, latin, ayat_count, revelation, synced_at FROM surah ORDER BY number ASC",
  );
  const cached = z.array(SurahRowSchema).safeParse(rows);
  if (cached.success && cached.data.length === TOTAL_SURAH_COUNT) {
    return ok(cached.data.map(mapSurahRowToDomain));
  }

  const remote = await fetchSurahList(signal);
  if (!remote.ok) return remote;

  const now = Date.now();
  db.withTransactionSync(() => {
    for (const surah of remote.value) {
      upsertSurah(surah, now);
    }
  });

  return remote;
};

export const getSurahDetail = async (
  surahNumber: number,
  signal?: AbortSignal,
): Promise<Result<SurahDetail>> => {
  if (!SurahNumberSchema.safeParse(surahNumber).success) {
    return err("notFound", `Invalid surah number: ${surahNumber}`);
  }

  const cachedSurah = readCachedSurah(surahNumber);
  if (cachedSurah) {
    const ayahRows = db.getAllSync<unknown>(
      "SELECT surah_number, number, text_arabic, text_latin, translation FROM ayah WHERE surah_number = ? ORDER BY number ASC",
      surahNumber,
    );
    const parsedAyahs = z.array(AyahRowSchema).safeParse(ayahRows);
    if (
      parsedAyahs.success &&
      parsedAyahs.data.length === cachedSurah.ayatCount
    ) {
      return ok({
        surah: cachedSurah,
        ayat: parsedAyahs.data.map(mapAyahRowToDomain),
      });
    }
  }

  const remote = await fetchSurahDetail(surahNumber, signal);
  if (!remote.ok) return remote;

  const now = Date.now();
  db.withTransactionSync(() => {
    upsertSurah(remote.value.surah, now);
    for (const ayah of remote.value.ayat) {
      db.runSync(
        `INSERT OR REPLACE INTO ayah (surah_number, number, text_arabic, text_latin, translation)
         VALUES (?, ?, ?, ?, ?)`,
        ayah.surahNumber,
        ayah.number,
        ayah.textArabic,
        ayah.textLatin,
        ayah.translation,
      );
    }
  });

  return remote;
};

export const getSurahTafsir = async (
  surahNumber: number,
  signal?: AbortSignal,
): Promise<Result<SurahTafsir>> => {
  if (!SurahNumberSchema.safeParse(surahNumber).success) {
    return err("notFound", `Invalid surah number: ${surahNumber}`);
  }

  const cachedSurah = readCachedSurah(surahNumber);
  if (cachedSurah) {
    const row = db.getFirstSync<unknown>(
      "SELECT surah_number, content, synced_at FROM tafsir WHERE surah_number = ?",
      surahNumber,
    );
    const parsedRow = TafsirRowSchema.safeParse(row);
    if (parsedRow.success) {
      try {
        const parsedEntries = TafsirEntriesJsonSchema.safeParse(
          JSON.parse(parsedRow.data.content),
        );
        if (parsedEntries.success) {
          return ok({ surah: cachedSurah, entries: parsedEntries.data });
        }
      } catch {
        // Fall through to remote fetch if cached JSON is corrupted.
      }
    }
  }

  const remote = await fetchSurahTafsir(surahNumber, signal);
  if (!remote.ok) return remote;

  const now = Date.now();
  db.withTransactionSync(() => {
    upsertSurah(remote.value.surah, now);
    db.runSync(
      `INSERT OR REPLACE INTO tafsir (surah_number, content, synced_at)
       VALUES (?, ?, ?)`,
      remote.value.surah.number,
      JSON.stringify(remote.value.entries),
      now,
    );
  });

  return remote;
};
