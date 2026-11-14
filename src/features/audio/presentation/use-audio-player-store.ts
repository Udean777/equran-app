import { create } from "zustand";

import { getQari } from "@/lib/storage/prefs";

import { type AudioQariId } from "../domain/audio-url";

export type ActiveAudioSurah = Readonly<{
  number: number;
  latin: string;
  ayatCount: number;
}>;

export type PlaybackMode = "single" | "surah";

type AudioPlayerState = Readonly<{
  qariId: AudioQariId;
  activeSurah: ActiveAudioSurah | null;
  currentAyah: number;
  playbackMode: PlaybackMode;
  isPlaying: boolean;
  isBuffering: boolean;
  setQariId: (qariId: AudioQariId) => void;
  setActiveTrack: (
    surah: ActiveAudioSurah,
    ayahNumber: number,
    playbackMode: PlaybackMode,
  ) => void;
  setPlaybackFlags: (flags: {
    isPlaying: boolean;
    isBuffering: boolean;
  }) => void;
  setCurrentAyah: (ayahNumber: number) => void;
  clearPlayback: () => void;
}>;

export const useAudioPlayerStore = create<AudioPlayerState>((set) => ({
  qariId: getQari(),
  activeSurah: null,
  currentAyah: 1,
  playbackMode: "single",
  isPlaying: false,
  isBuffering: false,
  setQariId: (qariId) => set({ qariId }),
  setActiveTrack: (activeSurah, currentAyah, playbackMode) =>
    set({ activeSurah, currentAyah, playbackMode }),
  setPlaybackFlags: ({ isPlaying, isBuffering }) =>
    set({ isPlaying, isBuffering }),
  setCurrentAyah: (currentAyah) => set({ currentAyah }),
  clearPlayback: () =>
    set({
      activeSurah: null,
      currentAyah: 1,
      playbackMode: "single",
      isPlaying: false,
      isBuffering: false,
    }),
}));
