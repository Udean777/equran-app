import { useQueryClient } from "@tanstack/react-query";
import { RecordingPresets, useAudioRecorder } from "expo-audio";
import { useState } from "react";
import { useTranslation } from "react-i18next";
import {
  ensureRecordingReady,
  restorePlaybackAudioMode,
} from "@/features/hafalan/data/audio-recorder";
import { compareRecitation } from "@/features/hafalan/data/hafalan-api";
import { saveSetoranResult } from "@/features/hafalan/data/hafalan-repository";
import { scheduleMurajaahReminder } from "@/features/hafalan/data/murajaah-reminder-service";
import type { CompareResponse } from "@/features/hafalan/data/schema";
import { err, ok, type Result } from "@/lib/result";
import { hafalanKeys } from "./hafalan-keys";

export type SetoranPhase =
  "idle" | "recording" | "comparing" | "done" | "error";

const submitSetoranRecitation = async (params: {
  audioUri: string;
  hafalanId: string;
  surahLabel: string;
  targetText: string;
  reminderCopy: Readonly<{ channelName: string; title: string; body: string }>;
}): Promise<Result<CompareResponse>> => {
  const compared = await compareRecitation({
    audioUri: params.audioUri,
    targetText: params.targetText,
  });
  if (!compared.ok) return err("network", compared.error.message);

  const saved = saveSetoranResult({
    hafalanId: params.hafalanId,
    compareResult: compared.value,
  });
  if (saved.ok && saved.value.nextMurajaahAt) {
    await scheduleMurajaahReminder({
      hafalanId: params.hafalanId,
      scheduledFor: new Date(saved.value.nextMurajaahAt),
      ...params.reminderCopy,
    });
  }
  return ok(compared.value);
};

export const useSetoran = () => {
  const { t } = useTranslation();
  const queryClient = useQueryClient();
  const recorder = useAudioRecorder(RecordingPresets.HIGH_QUALITY);
  const [phase, setPhase] = useState<SetoranPhase>("idle");
  const [result, setResult] = useState<CompareResponse | null>(null);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const startRecording = async (): Promise<void> => {
    setErrorMessage(null);
    setResult(null);
    const ready = await ensureRecordingReady();
    if (!ready.ok) {
      setPhase("error");
      setErrorMessage(t("hafalan.micPermissionError"));
      return;
    }
    await recorder.prepareToRecordAsync();
    recorder.record();
    setPhase("recording");
  };

  const stopAndCompare = async (params: {
    hafalanId: string;
    surahLabel: string;
    targetText: string;
  }): Promise<void> => {
    setPhase("comparing");
    try {
      await recorder.stop();
      await restorePlaybackAudioMode();
      if (!recorder.uri) {
        setPhase("error");
        setErrorMessage(t("hafalan.recordingEmptyError"));
        return;
      }

      const submitted = await submitSetoranRecitation({
        audioUri: recorder.uri,
        ...params,
        reminderCopy: {
          channelName: t("hafalan.reminderChannel"),
          title: t("hafalan.reminderTitle"),
          body: t("hafalan.reminderBody", { surah: params.surahLabel }),
        },
      });
      if (!submitted.ok) {
        setPhase("error");
        setErrorMessage(t("hafalan.compareFailedError"));
        return;
      }

      setResult(submitted.value);
      setPhase("done");
      void queryClient.invalidateQueries({ queryKey: hafalanKeys.all });
    } catch {
      await restorePlaybackAudioMode();
      setPhase("error");
      setErrorMessage(t("hafalan.compareFailedError"));
    }
  };

  const reset = (): void => {
    setPhase("idle");
    setResult(null);
    setErrorMessage(null);
  };

  return { phase, result, errorMessage, startRecording, stopAndCompare, reset };
};
