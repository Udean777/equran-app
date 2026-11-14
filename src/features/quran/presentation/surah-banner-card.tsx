import { Pause, Play } from "lucide-react-native";
import { useTranslation } from "react-i18next";
import { Text, View } from "react-native";
import Animated, { FadeIn } from "react-native-reanimated";

import { AnimatedPressable } from "@/components/animated-pressable";
import { BRAND_COLORS } from "@/theme/palette";

import {
  shouldShowBasmalahHeader,
  type SurahSummary,
} from "../domain/entities";

type Props = Readonly<{
  surah: SurahSummary;
  isPlayingSurah?: boolean;
  onTogglePlaySurah?: () => void;
}>;

export const SurahBannerCard = ({
  surah,
  isPlayingSurah = false,
  onTogglePlaySurah,
}: Props) => {
  const { t } = useTranslation();
  const revelationLabel =
    surah.revelation === "Mekah"
      ? t("quran.revelationMekah")
      : t("quran.revelationMadinah");
  const playLabel = isPlayingSurah
    ? t("audio.pauseSurah")
    : t("audio.playSurah");

  return (
    <Animated.View
      entering={FadeIn.duration(220)}
      className="mb-4 items-center overflow-hidden rounded-3xl border border-gold/40 bg-onboarding-bg p-6"
    >
      <Text className="text-center font-arabic text-4xl text-gold">
        {surah.name}
      </Text>

      <View className="my-3 h-0.5 w-14 rounded-full bg-gold" />

      <Text className="text-center font-serif text-2xl font-bold text-onboarding-text">
        {surah.latin}
      </Text>

      <View className="mt-3 flex-row flex-wrap items-center justify-center gap-2">
        <View className="rounded-full border border-gold/35 bg-onboarding-surface px-3 py-1">
          <Text className="text-xs font-semibold text-gold">
            {revelationLabel}
          </Text>
        </View>
        <View className="rounded-full border border-gold/35 bg-onboarding-surface px-3 py-1">
          <Text className="text-xs font-semibold text-onboarding-text">
            {surah.ayatCount} {t("quran.ayatUnit")}
          </Text>
        </View>
        <View className="rounded-full border border-gold/35 bg-onboarding-surface px-3 py-1">
          <Text className="text-xs font-semibold text-onboarding-muted">
            {t("quran.surahNumberLabel", { number: surah.number })}
          </Text>
        </View>
      </View>

      {shouldShowBasmalahHeader(surah.number) ? (
        <View className="mt-5 w-full items-center rounded-2xl border border-gold/35 bg-onboarding-surface px-4 py-3.5">
          <Text className="text-center font-arabic text-arabic-surah text-gold">
            {t("quran.basmalah")}
          </Text>
        </View>
      ) : null}

      {onTogglePlaySurah ? (
        <AnimatedPressable
          accessibilityRole="button"
          accessibilityLabel={playLabel}
          onPress={onTogglePlaySurah}
          className="mt-4 min-h-11 min-w-11 flex-row items-center justify-center gap-2 rounded-2xl bg-gold px-5 py-2.5"
        >
          {isPlayingSurah ? (
            <Pause color={BRAND_COLORS.gold.onGold} size={16} />
          ) : (
            <Play color={BRAND_COLORS.gold.onGold} size={16} />
          )}
          <Text className="text-xs font-bold text-on-gold">{playLabel}</Text>
        </AnimatedPressable>
      ) : null}
    </Animated.View>
  );
};
