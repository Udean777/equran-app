import {
  type CompareResponse,
  CompareResponseSchema,
} from "@/features/hafalan/data/schema";
import { err, ok, type Result } from "@/lib/result";

const HAFALAN_API_BASE = "https://ssajudn-equran-hafalan-api.hf.space";
const COMPARE_TIMEOUT_MS = 45_000;

export type CompareRecitationInput = Readonly<{
  audioUri: string;
  targetText: string;
  threshold?: number;
}>;

export const compareRecitation = async ({
  audioUri,
  targetText,
  threshold = 75,
}: CompareRecitationInput): Promise<Result<CompareResponse>> => {
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), COMPARE_TIMEOUT_MS);

  try {
    const form = new FormData();
    form.append("user_audio", {
      uri: audioUri,
      name: "setoran.m4a",
      type: "audio/m4a",
    } as unknown as Blob);
    form.append("target_text", targetText);
    form.append("threshold", String(threshold));
    form.append("is_arabic", "true");

    const response = await fetch(`${HAFALAN_API_BASE}/compare`, {
      method: "POST",
      body: form,
      signal: controller.signal,
    });

    if (!response.ok) {
      return err(
        "server",
        `Hafalan compare failed with status ${response.status}`,
      );
    }

    const json: unknown = await response.json();
    const parsed = CompareResponseSchema.safeParse(json);
    if (!parsed.success) {
      return err("parse", "Invalid compare response payload", parsed.error);
    }

    return ok(parsed.data);
  } catch (cause) {
    if (cause instanceof Error && cause.name === "AbortError") {
      return err("timeout", "Hafalan compare request timed out", cause);
    }
    return err("network", "Failed to upload recitation for comparison", cause);
  } finally {
    clearTimeout(timeout);
  }
};
