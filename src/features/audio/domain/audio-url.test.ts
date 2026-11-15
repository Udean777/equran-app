import {
  buildAyahAudioUrl,
  buildSurahAudioQueue,
  getQariProfile,
} from "./audio-url";

describe("audio url builder", () => {
  it("builds cdn.islamic.network URLs with the expected bitrate per qari", () => {
    expect(buildAyahAudioUrl(1, 1, "ar.alafasy")).toBe(
      "https://cdn.islamic.network/quran/audio/128/ar.alafasy/1.mp3",
    );
    expect(buildAyahAudioUrl(2, 1, "ar.abdurrahmaansudais")).toBe(
      "https://cdn.islamic.network/quran/audio/192/ar.abdurrahmaansudais/8.mp3",
    );
  });

  it("builds an ordered ayah queue for a surah", () => {
    const queue = buildSurahAudioQueue(114, 3, "ar.husary");
    expect(queue).toEqual([
      {
        surahNumber: 114,
        ayahNumber: 1,
        globalAyahNumber: 6231,
        uri: "https://cdn.islamic.network/quran/audio/128/ar.husary/6231.mp3",
      },
      {
        surahNumber: 114,
        ayahNumber: 2,
        globalAyahNumber: 6232,
        uri: "https://cdn.islamic.network/quran/audio/128/ar.husary/6232.mp3",
      },
      {
        surahNumber: 114,
        ayahNumber: 3,
        globalAyahNumber: 6233,
        uri: "https://cdn.islamic.network/quran/audio/128/ar.husary/6233.mp3",
      },
    ]);
  });

  it("returns the matching qari profile", () => {
    expect(getQariProfile("ar.minshawi").artistName).toBe(
      "Mohamed Siddiq Al-Minshawi",
    );
  });
});
