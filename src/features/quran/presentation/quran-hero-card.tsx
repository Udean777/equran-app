import { BookOpen, Sparkles } from "lucide-react-native";
import { useTranslation } from "react-i18next";
import { Text, View } from "react-native";
import Animated, { FadeIn } from "react-native-reanimated";

import { AnimatedPressable } from "@/components/animated-pressable";
import { Button } from "@/components/button";
import { type LastReadSurah } from "@/lib/storage/prefs";
import { BRAND_COLORS } from "@/theme/palette";

type Props = Readonly<{
  lastRead: LastReadSurah | null;
  onOpenSurah: (surahNumber: number) => void;
}>;

const QUICK_SURAHS: readonly {
  readonly number: number;
  readonly label: string;
}[] = [
  { number: 1, label: "Al-Fatihah" },
  { number: 18, label: "Al-Kahf" },
  { number: 36, label: "Yasin" },
  { number: 67, label: "Al-Mulk" },
];

const goldColor = BRAND_COLORS.gold.DEFAULT;
const onGoldColor = BRAND_COLORS.gold.onGold;

export const QuranHeroCard = ({ lastRead, onOpenSurah }: Props) => {
  const { t } = useTranslation();

  return (
    <Animated.View
      entering={FadeIn.duration(240)}
      className="mb-3 overflow-hidden rounded-3xl border border-gold/40 bg-onboarding-bg p-5"
    >
      <View className=" flex-row items-start justify-between gap-3">
        <View className="flex-1">
          <View className="flex-row items-center gap-2">
            {lastRead ? (
              <BookOpen color={goldColor} size={15} />
            ) : (
              <Sparkles color={goldColor} size={15} />
            )}
            <Text className="text-xs font-bold uppercase tracking-wider text-gold">
              {lastRead
                ? t("quran.lastReadLabel")
                : t("quran.heroWelcomeLabel")}
            </Text>
          </View>

          <Text className="mt-2 font-serif text-2xl font-bold text-onboarding-text">
            {lastRead ? lastRead.latin : t("quran.heroWelcomeTitle")}
          </Text>

          <Text className="mt-1 text-xs leading-5 text-onboarding-muted">
            {lastRead
              ? `${t("quran.surahNumberLabel", { number: lastRead.number })} • ${lastRead.ayatCount} ${t("quran.ayatUnit")}`
              : t("quran.heroWelcomeSubtitle")}
          </Text>
        </View>

        <View className="items-end">
          <View className="rounded-2xl border border-gold/35 bg-onboarding-surface px-3.5 py-2">
            <Text className="font-arabic text-arabic-surah text-gold">
              {lastRead ? lastRead.name : "الفاتحة"}
            </Text>
          </View>

          <Button
            containerClassName="mt-3"
            variant="gold"
            size="sm"
            label={
              lastRead ? t("quran.continueReading") : t("quran.startFatihah")
            }
            icon={<BookOpen color={onGoldColor} size={14} />}
            onPress={() => onOpenSurah(lastRead ? lastRead.number : 1)}
          />
        </View>
      </View>

      <View className="my-3.5 h-px bg-gold/25" />

      <View className="flex-row flex-wrap items-center gap-2">
        <Text className="mr-1 text-xs font-medium text-onboarding-muted">
          {t("quran.quickAccess")}:
        </Text>
        {QUICK_SURAHS.map((item) => (
          <AnimatedPressable
            key={item.number}
            accessibilityRole="button"
            accessibilityLabel={item.label}
            onPress={() => onOpenSurah(item.number)}
            className="min-h-11 justify-center rounded-full border border-gold/35 bg-onboarding-surface px-3 py-1.5"
          >
            <Text className="text-xs font-semibold text-onboarding-text">
              {item.label}
            </Text>
          </AnimatedPressable>
        ))}
      </View>
    </Animated.View>
  );
};
