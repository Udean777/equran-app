import { ChevronRight } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import { useTranslation } from "react-i18next";
import { Text, View } from "react-native";

import { AnimatedPressable } from "@/components/animated-pressable";
import { cn } from "@/lib/cn";
import { getThemePalette } from "@/theme/palette";

import { type SurahSummary } from "../domain/entities";

type Props = Readonly<{
  surah: SurahSummary;
  onPress: (surah: SurahSummary) => void;
}>;

export const SurahCard = ({ surah, onPress }: Props) => {
  const { t } = useTranslation();
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);
  const isMekah = surah.revelation === "Mekah";
  const revelationLabel = isMekah
    ? t("quran.revelationMekah")
    : t("quran.revelationMadinah");

  return (
    <AnimatedPressable
      containerClassName="mb-2.5"
      accessibilityRole="button"
      accessibilityLabel={`${surah.number}. ${surah.latin}`}
      onPress={() => onPress(surah)}
      className="min-h-11 min-w-11 flex-row items-center gap-3.5 rounded-2xl border border-border bg-surface p-4"
    >
      <View className="h-11 w-11 items-center justify-center rounded-2xl border border-gold/40 bg-primary-container">
        <Text className="text-xs font-bold text-on-primary-container">
          {surah.number}
        </Text>
      </View>

      <View className="flex-1">
        <Text className="text-base font-bold text-text">{surah.latin}</Text>
        <View className="mt-1.5 flex-row items-center gap-2">
          <View
            className={cn(
              "rounded-full px-2.5 py-0.5",
              isMekah ? "bg-mekah-badge" : "bg-madinah-badge",
            )}
          >
            <Text
              className={cn(
                "text-xs font-semibold",
                isMekah ? "text-mekah-badge-text" : "text-madinah-badge-text",
              )}
            >
              {revelationLabel}
            </Text>
          </View>
          <View className="h-1 w-1 rounded-full bg-border" />
          <Text className="text-xs font-medium text-muted">
            {surah.ayatCount} {t("quran.ayatUnit")}
          </Text>
        </View>
      </View>

      <View className="flex-row items-center gap-2.5">
        <Text className="font-arabic text-arabic-surah text-primary">
          {surah.name}
        </Text>
        <View className="h-8 w-8 items-center justify-center rounded-full bg-surface-variant">
          <ChevronRight color={palette.muted} size={15} />
        </View>
      </View>
    </AnimatedPressable>
  );
};
