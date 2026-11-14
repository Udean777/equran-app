import { toGlobalAyahNumber } from "@/features/quran/domain/ayat-number";

export type AudioQariId =
  "ar.alafasy" | "ar.abdurrahmaansudais" | "ar.husary" | "ar.minshawi";

export type QariProfile = Readonly<{
  id: AudioQariId;
  labelKey: string;
  artistName: string;
  bitrate: 128 | 192;
}>;

export type AyahAudioTrack = Readonly<{
  surahNumber: number;
  ayahNumber: number;
  globalAyahNumber: number;
  uri: string;
}>;

// Sudais is hosted at 192 kbps on cdn.islamic.network; the others are 128 kbps.
export const QARI_PROFILES: readonly QariProfile[] = [
  {
    id: "ar.alafasy",
    labelKey: "audio.qari.alafasy",
    artistName: "Mishary Rashid Alafasy",
    bitrate: 128,
  },
  {
    id: "ar.abdurrahmaansudais",
    labelKey: "audio.qari.sudais",
    artistName: "Abdurrahmaan As-Sudais",
    bitrate: 192,
  },
  {
    id: "ar.husary",
    labelKey: "audio.qari.husary",
    artistName: "Mahmoud Khalil Al-Husary",
    bitrate: 128,
  },
  {
    id: "ar.minshawi",
    labelKey: "audio.qari.minshawi",
    artistName: "Mohamed Siddiq Al-Minshawi",
    bitrate: 128,
  },
];

const DEFAULT_QARI = QARI_PROFILES[0];

export const getQariProfile = (qariId: AudioQariId): QariProfile => {
  const found = QARI_PROFILES.find((item) => item.id === qariId);
  if (found) return found;
  if (!DEFAULT_QARI) throw new Error("QARI_PROFILES cannot be empty");
  return DEFAULT_QARI;
};

export const buildAyahAudioUrl = (
  surahNumber: number,
  ayahNumber: number,
  qariId: AudioQariId,
): string => {
  const globalAyah = toGlobalAyahNumber(surahNumber, ayahNumber);
  const { bitrate } = getQariProfile(qariId);
  return `https://cdn.islamic.network/quran/audio/${bitrate}/${qariId}/${globalAyah}.mp3`;
};

export const buildSurahAudioQueue = (
  surahNumber: number,
  ayatCount: number,
  qariId: AudioQariId,
): readonly AyahAudioTrack[] => {
  if (!Number.isInteger(ayatCount) || ayatCount < 1) {
    throw new RangeError(`ayatCount out of range: ${ayatCount}`);
  }

  return Array.from({ length: ayatCount }, (_, index) => {
    const ayahNumber = index + 1;
    const globalAyahNumber = toGlobalAyahNumber(surahNumber, ayahNumber);
    return {
      surahNumber,
      ayahNumber,
      globalAyahNumber,
      uri: buildAyahAudioUrl(surahNumber, ayahNumber, qariId),
    };
  });
};
