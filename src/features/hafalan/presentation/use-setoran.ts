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
import { hafalanKeys } from "./hafalan-keys";

export type SetoranPhase =
  "idle" | "recording" | "comparing" | "done" | "error";

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
      const audioUri = recorder.uri;
      if (!audioUri) {
        setPhase("error");
        setErrorMessage(t("hafalan.recordingEmptyError"));
        return;
      }

      const compared = await compareRecitation({
        audioUri,
        targetText: params.targetText,
      });
      if (!compared.ok) {
        setPhase("error");
        setErrorMessage(t("hafalan.compareFailedError"));
        return;
      }

      const saved = saveSetoranResult({
        hafalanId: params.hafalanId,
        compareResult: compared.value,
      });
      if (saved.ok && saved.value.nextMurajaahAt) {
        await scheduleMurajaahReminder({
          hafalanId: params.hafalanId,
          scheduledFor: new Date(saved.value.nextMurajaahAt),
          channelName: t("hafalan.reminderChannel"),
          title: t("hafalan.reminderTitle"),
          body: t("hafalan.reminderBody", { surah: params.surahLabel }),
        });
      }

      setResult(compared.value);
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
