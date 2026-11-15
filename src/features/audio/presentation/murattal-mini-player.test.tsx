import { fireEvent, render } from "@testing-library/react-native";

import { i18next } from "@/lib/i18n";

import { MurattalMiniPlayer } from "./murattal-mini-player";
import { useAudioPlayerStore } from "./use-audio-player-store";

describe("MurattalMiniPlayer", () => {
  beforeEach(async () => {
    await i18next.changeLanguage("en");
    useAudioPlayerStore.getState().clearPlayback();
  });

  it("renders nothing when no surah is active", async () => {
    const { queryByLabelText } = await render(<MurattalMiniPlayer />);
    expect(queryByLabelText("Play")).toBeNull();
  });

  it("renders active surah and ayah, and stops playback when Stop is pressed", async () => {
    useAudioPlayerStore.getState().setActiveTrack(
      {
        number: 1,
        latin: "Al-Fatihah",
        ayatCount: 7,
      },
      2,
      "single",
    );

    const { getByLabelText, getByText } = await render(<MurattalMiniPlayer />);
    expect(getByText("Al-Fatihah • Ayah 2")).toBeTruthy();

    await fireEvent.press(getByLabelText("Stop audio"));
    expect(useAudioPlayerStore.getState().activeSurah).toBeNull();
  });
});
