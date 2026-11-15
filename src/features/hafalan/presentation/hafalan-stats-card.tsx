import { Award, BookMarked } from "lucide-react-native";
import { useTranslation } from "react-i18next";
import { Text, View } from "react-native";
import type { HafalanStats } from "@/features/hafalan/domain/murajaah";
import { BRAND_COLORS } from "@/theme/palette";

type Props = Readonly<{
  stats: HafalanStats;
}>;

const goldColor = BRAND_COLORS.gold.DEFAULT;

export const HafalanStatsCard = ({ stats }: Props) => {
  const { t } = useTranslation();

  return (
    <View className="mb-4 overflow-hidden rounded-3xl border border-gold/40 bg-onboarding-bg p-5">
      <View className="flex-row items-center justify-between">
        <View className="flex-row items-center gap-2">
          <BookMarked size={16} color={goldColor} />
          <Text className="text-xs font-bold uppercase tracking-wider text-gold">
            {t("hafalan.statsLabel")}
          </Text>
        </View>
        <View className="rounded-xl border border-gold/35 bg-onboarding-surface px-3 py-1">
          <Text className="font-arabic text-lg text-gold">الحِفْظ</Text>
        </View>
      </View>

      <View className="mt-4 flex-row gap-3">
        <View className="flex-1 rounded-2xl border border-gold/25 bg-onboarding-surface p-3">
          <Text className="text-xs text-onboarding-muted">
            {t("hafalan.statSurahs")}
          </Text>
          <Text className="mt-1 text-2xl font-bold tabular-nums text-onboarding-text">
            {stats.totalSurahs}
          </Text>
        </View>

        <View className="flex-1 rounded-2xl border border-gold/25 bg-onboarding-surface p-3">
          <Text className="text-xs text-onboarding-muted">
            {t("hafalan.statDue")}
          </Text>
          <Text className="mt-1 text-2xl font-bold tabular-nums text-gold">
            {stats.dueCount}
          </Text>
        </View>

        <View className="flex-1 rounded-2xl border border-gold/25 bg-onboarding-surface p-3">
          <View className="flex-row items-center gap-1">
            <Award size={12} color={goldColor} />
            <Text className="text-xs text-onboarding-muted">
              {t("hafalan.statAvgScore")}
            </Text>
          </View>
          <Text className="mt-1 text-2xl font-bold tabular-nums text-onboarding-text">
            {stats.averageScore !== null
              ? `${stats.averageScore.toFixed(0)}%`
              : "—"}
          </Text>
        </View>
      </View>
    </View>
  );
};
