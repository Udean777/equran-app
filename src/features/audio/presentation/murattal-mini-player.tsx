import { Pause, Play, SkipBack, SkipForward, X } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import { useTranslation } from "react-i18next";
import { ActivityIndicator, Text, View } from "react-native";

import { IconButton } from "@/components/icon-button";
import { getThemePalette } from "@/theme/palette";

import { useMurattalPlayer } from "./use-murattal-player";

export const MurattalMiniPlayer = () => {
  const { t } = useTranslation();
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);
  const {
    qariProfile,
    activeSurah,
    currentAyah,
    isPlaying,
    isBuffering,
    togglePlayPause,
    skipNext,
    skipPrev,
    stop,
  } = useMurattalPlayer();

  if (!activeSurah) return null;

  const canPrev = currentAyah > 1;
  const canNext = currentAyah < activeSurah.ayatCount;
  const playPauseLabel = isPlaying ? t("audio.pause") : t("audio.play");

  return (
    <View className="mt-2 flex-row items-center gap-3 rounded-3xl border border-gold/45 bg-surface px-4 py-3">
      <View className="flex-1">
        <Text className="text-sm font-bold text-text" numberOfLines={1}>
          {activeSurah.latin} • {t("quran.ayahLabel", { number: currentAyah })}
        </Text>
        <Text className="mt-0.5 text-xs text-muted" numberOfLines={1}>
          {qariProfile.artistName}
        </Text>
      </View>

      <View className="flex-row items-center gap-1">
        <IconButton
          variant="ghost"
          label={t("audio.prevAyah")}
          disabled={!canPrev}
          onPress={skipPrev}
        >
          <SkipBack color={canPrev ? palette.text : palette.muted} size={18} />
        </IconButton>

        <IconButton
          variant="primary"
          label={playPauseLabel}
          onPress={togglePlayPause}
        >
          {isBuffering ? (
            <ActivityIndicator size="small" color={palette.onPrimary} />
          ) : isPlaying ? (
            <Pause color={palette.onPrimary} size={18} />
          ) : (
            <Play color={palette.onPrimary} size={18} />
          )}
        </IconButton>

        <IconButton
          variant="ghost"
          label={t("audio.nextAyah")}
          disabled={!canNext}
          onPress={skipNext}
        >
          <SkipForward
            color={canNext ? palette.text : palette.muted}
            size={18}
          />
        </IconButton>

        <IconButton variant="ghost" label={t("audio.stop")} onPress={stop}>
          <X color={palette.muted} size={18} />
        </IconButton>
      </View>
    </View>
  );
};
