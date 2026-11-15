import { BookOpenText, Pause, Play } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import { useTranslation } from "react-i18next";
import { Text, View } from "react-native";

import { AnimatedPressable } from "@/components/animated-pressable";
import { cn } from "@/lib/cn";
import { getThemePalette } from "@/theme/palette";

import { type Ayah } from "../domain/entities";

type Props = Readonly<{
  ayah: Ayah;
  totalAyat: number;
  isActiveAyah?: boolean;
  isPlayingAyah?: boolean;
  onTogglePlay?: () => void;
  onOpenTafsir: () => void;
}>;

export const AyahCard = ({
  ayah,
  totalAyat,
  isActiveAyah = false,
  isPlayingAyah = false,
  onTogglePlay,
  onOpenTafsir,
}: Props) => {
  const { t } = useTranslation();
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);
  const playLabel = isPlayingAyah
    ? t("audio.pauseAyah", { number: ayah.number })
    : t("audio.playAyah", { number: ayah.number });

  return (
    <View
      className={cn(
        "mb-3.5 rounded-3xl border bg-surface p-5",
        isActiveAyah ? "border-gold" : "border-border",
      )}
    >
      <View className="mb-3.5 flex-row items-center justify-between gap-2">
        <View className="flex-row items-center gap-2.5">
          <View className="h-9 min-w-9 items-center justify-center rounded-xl border border-gold/40 bg-primary-container px-2.5">
            <Text className="text-xs font-bold text-on-primary-container">
              {ayah.surahNumber}:{ayah.number}
            </Text>
          </View>
          <Text className="text-xs font-medium text-muted">
            {t("quran.ayahProgressLabel", {
              number: ayah.number,
              total: totalAyat,
            })}
          </Text>
        </View>

        <View className="flex-row items-center gap-2">
          {onTogglePlay ? (
            <AnimatedPressable
              accessibilityRole="button"
              accessibilityLabel={playLabel}
              onPress={onTogglePlay}
              className={cn(
                "min-h-11 min-w-11 items-center justify-center rounded-xl border px-3 py-1.5",
                isPlayingAyah
                  ? "border-primary bg-primary"
                  : "border-border bg-surface-variant",
              )}
            >
              {isPlayingAyah ? (
                <Pause color={palette.onPrimary} size={14} />
              ) : (
                <Play color={palette.primary} size={14} />
              )}
            </AnimatedPressable>
          ) : null}

          <AnimatedPressable
            accessibilityRole="button"
            accessibilityLabel={t("quran.tafsirButton")}
            onPress={onOpenTafsir}
            className="min-h-11 min-w-11 flex-row items-center justify-center gap-1.5 rounded-xl border border-border bg-surface-variant px-3 py-1.5"
          >
            <BookOpenText color={palette.primary} size={14} />
            <Text className="text-xs font-semibold text-primary">
              {t("quran.tafsirButton")}
            </Text>
          </AnimatedPressable>
        </View>
      </View>

      <Text className="text-right font-arabic text-arabic-ayah text-primary">
        {ayah.textArabic}
      </Text>

      <View className="my-3.5 h-px bg-border" />

      <Text className="text-sm italic leading-6 text-muted">
        {ayah.textLatin}
      </Text>

      <View className="mt-3 rounded-2xl border border-border-variant bg-surface-variant p-4">
        <Text className="text-sm leading-6 text-text">{ayah.translation}</Text>
      </View>
    </View>
  );
};
