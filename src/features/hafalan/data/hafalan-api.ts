import { File } from "expo-file-system";
import { fetch } from "expo/fetch";

import {
  type CompareResponse,
  CompareResponseSchema,
} from "@/features/hafalan/data/schema";
import { err, ok, type Result } from "@/lib/result";

const HAFALAN_API_BASE = "https://ssajudn-equran-hafalan-api.hf.space";
const COMPARE_TIMEOUT_MS = 120_000;
const HEALTH_TIMEOUT_MS = 5_000;

export type CompareRecitationInput = Readonly<{
  audioUri: string;
  targetText: string;
  threshold?: number;
}>;

const postCompare = async ({
  audioUri,
  targetText,
  threshold,
}: Required<CompareRecitationInput>): Promise<Result<CompareResponse>> => {
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), COMPARE_TIMEOUT_MS);

  try {
    const form = new FormData();
    form.append("user_audio", new File(audioUri));
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

export const compareRecitation = async (
  input: CompareRecitationInput,
): Promise<Result<CompareResponse>> => {
  const params = { ...input, threshold: input.threshold ?? 75 };
  const firstAttempt = await postCompare(params);
  if (firstAttempt.ok || firstAttempt.error.code !== "network") {
    return firstAttempt;
  }
  return postCompare(params);
};

/** HF Spaces sleeps; wake it while the user is still reading the target ayah. */
export const warmHafalanApi = async (): Promise<Result<void>> => {
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), HEALTH_TIMEOUT_MS);

  try {
    const response = await fetch(`${HAFALAN_API_BASE}/health`, {
      signal: controller.signal,
    });
    if (!response.ok) {
      return err("server", `Hafalan health check failed: ${response.status}`);
    }
    return ok(undefined);
  } catch (cause) {
    if (cause instanceof Error && cause.name === "AbortError") {
      return err("timeout", "Hafalan health check timed out", cause);
    }
    return err("network", "Hafalan health check failed", cause);
  } finally {
    clearTimeout(timeout);
  }
};
