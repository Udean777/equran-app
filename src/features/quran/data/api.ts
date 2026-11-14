import { type z } from "zod";

import { err, ok, type Result } from "@/lib/result";

import {
  type SurahDetail,
  type SurahSummary,
  type SurahTafsir,
} from "../domain/entities";
import {
  mapSurahDetailDtoToDomain,
  mapSurahDtoToDomain,
  mapTafsirDtoToDomain,
  SuratDetailResponseSchema,
  SuratListResponseSchema,
  TafsirResponseSchema,
} from "./schema";

const BASE_URL = "https://equran.id/api/v2";
const REQUEST_TIMEOUT_MS = 15_000;

const fetchAndParse = async <TSchema extends z.ZodTypeAny, TDomain>(
  path: string,
  schema: TSchema,
  mapper: (parsed: z.infer<TSchema>) => TDomain,
  signal?: AbortSignal,
): Promise<Result<TDomain>> => {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), REQUEST_TIMEOUT_MS);

  const onAbort = () => controller.abort();
  signal?.addEventListener("abort", onAbort, { once: true });

  try {
    const response = await fetch(`${BASE_URL}${path}`, {
      signal: controller.signal,
      headers: { Accept: "application/json" },
    });

    if (response.status === 404) {
      return err("notFound", `Resource not found: ${path}`);
    }
    if (!response.ok) {
      return err("server", `HTTP ${response.status} on ${path}`);
    }

    const json: unknown = await response.json();
    const parsed = schema.safeParse(json);
    if (!parsed.success) {
      return err("parse", `Invalid API payload for ${path}`, parsed.error);
    }

    return ok(mapper(parsed.data));
  } catch (cause) {
    if (controller.signal.aborted && !signal?.aborted) {
      return err("timeout", `Request timed out for ${path}`, cause);
    }
    return err("network", `Network error for ${path}`, cause);
  } finally {
    clearTimeout(timeoutId);
    signal?.removeEventListener("abort", onAbort);
  }
};

export const fetchSurahList = (
  signal?: AbortSignal,
): Promise<Result<readonly SurahSummary[]>> =>
  fetchAndParse(
    "/surat",
    SuratListResponseSchema,
    (res) => res.data.map(mapSurahDtoToDomain),
    signal,
  );

export const fetchSurahDetail = (
  surahNumber: number,
  signal?: AbortSignal,
): Promise<Result<SurahDetail>> =>
  fetchAndParse(
    `/surat/${surahNumber}`,
    SuratDetailResponseSchema,
    (res) => mapSurahDetailDtoToDomain(res.data),
    signal,
  );

export const fetchSurahTafsir = (
  surahNumber: number,
  signal?: AbortSignal,
): Promise<Result<SurahTafsir>> =>
  fetchAndParse(
    `/tafsir/${surahNumber}`,
    TafsirResponseSchema,
    (res) => mapTafsirDtoToDomain(res.data),
    signal,
  );
