import { useAudioPlayerStore } from "../presentation/use-audio-player-store";
import { playSingleAyah, playSurahFromAyah, stopAudio } from "./audio-engine";

const mockPlaylist = {
  addListener: jest.fn(),
  play: jest.fn(),
  pause: jest.fn(),
  next: jest.fn(),
  previous: jest.fn(),
  skipTo: jest.fn(),
  clear: jest.fn(),
  add: jest.fn(),
  setActiveForLockScreen: jest.fn(),
  updateLockScreenMetadata: jest.fn(),
  clearLockScreenControls: jest.fn(),
};

jest.mock("expo-audio", () => ({
  setAudioModeAsync: jest.fn().mockResolvedValue(undefined),
  createAudioPlaylist: jest.fn(() => mockPlaylist),
}));

const surah = { number: 1, latin: "Al-Fatihah", ayatCount: 7 };

describe("audio-engine playback modes", () => {
  beforeEach(() => {
    jest.clearAllMocks();
    stopAudio();
  });

  it("loads only 1 track when playing a single ayah so it does not autoplay", async () => {
    await playSingleAyah(surah, 3);

    expect(mockPlaylist.add).toHaveBeenCalledTimes(1);
    expect(mockPlaylist.skipTo).toHaveBeenCalledWith(0);
    expect(mockPlaylist.play).toHaveBeenCalledTimes(1);
    expect(useAudioPlayerStore.getState().playbackMode).toBe("single");
    expect(useAudioPlayerStore.getState().currentAyah).toBe(3);
  });

  it("loads the full surah queue when playing the surah from the top banner", async () => {
    await playSurahFromAyah(surah, 1);

    expect(mockPlaylist.add).toHaveBeenCalledTimes(7);
    expect(mockPlaylist.skipTo).toHaveBeenCalledWith(0);
    expect(mockPlaylist.play).toHaveBeenCalledTimes(1);
    expect(useAudioPlayerStore.getState().playbackMode).toBe("surah");
  });
});
