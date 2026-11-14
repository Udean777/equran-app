import {
  type AudioPlaylist,
  createAudioPlaylist,
  setAudioModeAsync,
} from "expo-audio";

import { logger } from "@/lib/logger";
import { setQari } from "@/lib/storage/prefs";

import {
  type AudioQariId,
  buildAyahAudioUrl,
  buildSurahAudioQueue,
  getQariProfile,
} from "../domain/audio-url";
import {
  type ActiveAudioSurah,
  useAudioPlayerStore,
} from "../presentation/use-audio-player-store";

let playlistInstance: AudioPlaylist | null = null;
let loadedKey: string | null = null;
let audioModeReady = false;
let lockScreenActive = false;

const buildMetadata = (
  surah: ActiveAudioSurah,
  ayahNumber: number,
  qariId: AudioQariId,
) => ({
  title: `${surah.latin} • Ayat ${ayahNumber}`,
  artist: getQariProfile(qariId).artistName,
  albumTitle: "Qurva",
});

const ensureAudioMode = async (): Promise<void> => {
  if (audioModeReady) return;
  try {
    await setAudioModeAsync({
      playsInSilentMode: true,
      shouldPlayInBackground: true,
      interruptionMode: "doNotMix",
    });
    audioModeReady = true;
  } catch (error) {
    logger.warn("[audio] Failed to configure audio mode", error);
  }
};

const syncLockScreen = (
  playlist: AudioPlaylist,
  surah: ActiveAudioSurah,
  ayahNumber: number,
  qariId: AudioQariId,
): void => {
  const metadata = buildMetadata(surah, ayahNumber, qariId);
  if (!lockScreenActive) {
    playlist.setActiveForLockScreen(true, metadata);
    lockScreenActive = true;
    return;
  }
  playlist.updateLockScreenMetadata(metadata);
};

const getOrCreatePlaylist = (): AudioPlaylist => {
  if (playlistInstance) return playlistInstance;

  const playlist = createAudioPlaylist({
    sources: [],
    updateInterval: 500,
    loop: "none",
  });

  playlist.addListener("playlistStatusUpdate", (status) => {
    useAudioPlayerStore.getState().setPlaybackFlags({
      isPlaying: status.playing,
      isBuffering: status.isBuffering,
    });
  });

  playlist.addListener("trackChanged", ({ currentIndex }) => {
    const state = useAudioPlayerStore.getState();
    const { activeSurah, playbackMode, qariId } = state;
    if (!activeSurah || playbackMode !== "surah" || currentIndex < 0) return;

    const ayahNumber = Math.min(currentIndex + 1, activeSurah.ayatCount);
    state.setCurrentAyah(ayahNumber);
    syncLockScreen(playlist, activeSurah, ayahNumber, qariId);
  });

  playlistInstance = playlist;
  return playlist;
};

const loadSurahQueue = (
  playlist: AudioPlaylist,
  surah: ActiveAudioSurah,
  qariId: AudioQariId,
): void => {
  const queue = buildSurahAudioQueue(surah.number, surah.ayatCount, qariId);
  playlist.clear();
  for (const track of queue) {
    playlist.add({
      uri: track.uri,
      name: `${surah.latin} ${track.ayahNumber}`,
    });
  }
  loadedKey = `surah:${surah.number}:${qariId}`;
};

const loadSingleTrack = (
  playlist: AudioPlaylist,
  surah: ActiveAudioSurah,
  ayahNumber: number,
  qariId: AudioQariId,
): void => {
  playlist.clear();
  playlist.add({
    uri: buildAyahAudioUrl(surah.number, ayahNumber, qariId),
    name: `${surah.latin} ${ayahNumber}`,
  });
  loadedKey = `single:${surah.number}:${ayahNumber}:${qariId}`;
};

export const playSingleAyah = async (
  surah: ActiveAudioSurah,
  ayahNumber: number,
): Promise<void> => {
  await ensureAudioMode();
  const state = useAudioPlayerStore.getState();
  const { qariId } = state;
  const targetAyah = Math.max(1, Math.min(ayahNumber, surah.ayatCount));
  const playlist = getOrCreatePlaylist();
  const nextKey = `single:${surah.number}:${targetAyah}:${qariId}`;

  if (loadedKey !== nextKey) {
    loadSingleTrack(playlist, surah, targetAyah, qariId);
  }

  state.setActiveTrack(surah, targetAyah, "single");
  playlist.skipTo(0);
  syncLockScreen(playlist, surah, targetAyah, qariId);
  playlist.play();
};

export const playSurahFromAyah = async (
  surah: ActiveAudioSurah,
  startAyah = 1,
): Promise<void> => {
  await ensureAudioMode();
  const state = useAudioPlayerStore.getState();
  const { qariId } = state;
  const targetAyah = Math.max(1, Math.min(startAyah, surah.ayatCount));
  const playlist = getOrCreatePlaylist();
  const nextKey = `surah:${surah.number}:${qariId}`;

  if (loadedKey !== nextKey) {
    loadSurahQueue(playlist, surah, qariId);
  }

  state.setActiveTrack(surah, targetAyah, "surah");
  playlist.skipTo(targetAyah - 1);
  syncLockScreen(playlist, surah, targetAyah, qariId);
  playlist.play();
};

export const togglePlayPause = async (): Promise<void> => {
  const state = useAudioPlayerStore.getState();
  if (!state.activeSurah) return;
  await ensureAudioMode();
  const playlist = getOrCreatePlaylist();

  if (state.isPlaying) {
    playlist.pause();
    return;
  }

  syncLockScreen(playlist, state.activeSurah, state.currentAyah, state.qariId);
  playlist.play();
};

export const skipNextAyah = (): void => {
  const { activeSurah, currentAyah, playbackMode } =
    useAudioPlayerStore.getState();
  if (!activeSurah || currentAyah >= activeSurah.ayatCount) return;
  if (playbackMode === "single") {
    void playSingleAyah(activeSurah, currentAyah + 1);
    return;
  }
  getOrCreatePlaylist().next();
};

export const skipPrevAyah = (): void => {
  const { activeSurah, currentAyah, playbackMode } =
    useAudioPlayerStore.getState();
  if (!activeSurah || currentAyah <= 1) return;
  if (playbackMode === "single") {
    void playSingleAyah(activeSurah, currentAyah - 1);
    return;
  }
  getOrCreatePlaylist().previous();
};

export const stopAudio = (): void => {
  if (playlistInstance) {
    playlistInstance.pause();
    playlistInstance.clear();
    if (lockScreenActive) {
      playlistInstance.clearLockScreenControls();
      lockScreenActive = false;
    }
  }
  loadedKey = null;
  useAudioPlayerStore.getState().clearPlayback();
};

export const changeQari = async (qariId: AudioQariId): Promise<void> => {
  setQari(qariId);
  const state = useAudioPlayerStore.getState();
  state.setQariId(qariId);

  if (!state.activeSurah) return;

  const { activeSurah, currentAyah, playbackMode, isPlaying } = state;
  await ensureAudioMode();
  const playlist = getOrCreatePlaylist();

  if (playbackMode === "single") {
    loadSingleTrack(playlist, activeSurah, currentAyah, qariId);
    playlist.skipTo(0);
  } else {
    loadSurahQueue(playlist, activeSurah, qariId);
    playlist.skipTo(currentAyah - 1);
  }

  syncLockScreen(playlist, activeSurah, currentAyah, qariId);
  if (isPlaying) {
    playlist.play();
  }
};
