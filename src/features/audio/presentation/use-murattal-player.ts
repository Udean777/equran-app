import {
  changeQari,
  playSingleAyah,
  playSurahFromAyah,
  skipNextAyah,
  skipPrevAyah,
  stopAudio,
  togglePlayPause,
} from "../data/audio-engine";
import { type AudioQariId, getQariProfile } from "../domain/audio-url";
import {
  type ActiveAudioSurah,
  useAudioPlayerStore,
} from "./use-audio-player-store";

export const useMurattalPlayer = () => {
  const qariId = useAudioPlayerStore((s) => s.qariId);
  const activeSurah = useAudioPlayerStore((s) => s.activeSurah);
  const currentAyah = useAudioPlayerStore((s) => s.currentAyah);
  const playbackMode = useAudioPlayerStore((s) => s.playbackMode);
  const isPlaying = useAudioPlayerStore((s) => s.isPlaying);
  const isBuffering = useAudioPlayerStore((s) => s.isBuffering);

  const playAyah = (surah: ActiveAudioSurah, ayahNumber: number) => {
    const isSameSingleTrack =
      activeSurah?.number === surah.number &&
      currentAyah === ayahNumber &&
      playbackMode === "single";
    if (isSameSingleTrack) {
      void togglePlayPause();
      return;
    }
    void playSingleAyah(surah, ayahNumber);
  };

  const playSurah = (surah: ActiveAudioSurah) => {
    if (activeSurah?.number === surah.number && playbackMode === "surah") {
      void togglePlayPause();
      return;
    }
    void playSurahFromAyah(surah, 1);
  };

  const selectQari = (nextQari: AudioQariId) => {
    void changeQari(nextQari);
  };

  return {
    qariId,
    qariProfile: getQariProfile(qariId),
    activeSurah,
    currentAyah,
    playbackMode,
    isPlaying,
    isBuffering,
    playAyah,
    playSurah,
    togglePlayPause: () => {
      void togglePlayPause();
    },
    skipNext: skipNextAyah,
    skipPrev: skipPrevAyah,
    stop: stopAudio,
    selectQari,
  };
};
