import {
  getRecordingPermissionsAsync,
  requestRecordingPermissionsAsync,
  setAudioModeAsync,
} from "expo-audio";
import { err, ok, type Result } from "@/lib/result";

export const ensureRecordingReady = async (): Promise<Result<void>> => {
  try {
    const existing = await getRecordingPermissionsAsync();
    let granted = existing.granted;
    if (!granted) {
      const requested = await requestRecordingPermissionsAsync();
      granted = requested.granted;
    }
    if (!granted) {
      return err("permission", "Microphone permission not granted");
    }

    await setAudioModeAsync({
      allowsRecording: true,
      playsInSilentMode: true,
      shouldPlayInBackground: false,
      interruptionMode: "doNotMix",
    });
    return ok(undefined);
  } catch (cause) {
    return err("permission", "Failed to prepare microphone", cause);
  }
};

export const restorePlaybackAudioMode = async (): Promise<void> => {
  await setAudioModeAsync({
    allowsRecording: false,
    playsInSilentMode: true,
    shouldPlayInBackground: true,
    interruptionMode: "doNotMix",
  }).catch(() => undefined);
};
