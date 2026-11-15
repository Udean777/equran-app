import { MapPin } from "lucide-react-native";
import { useTranslation } from "react-i18next";
import { Text, View } from "react-native";
import {
  formatCountdown,
  formatPrayerClock,
  type PrayerName,
  type PrayerTimeEntry,
} from "@/features/prayer/domain/prayer-times";
import { BRAND_COLORS } from "@/theme/palette";

export const PRAYER_ARABIC: Record<PrayerName, string> = {
  fajr: "الفجر",
  sunrise: "الشروق",
  dhuhr: "الظهر",
  asr: "العصر",
  maghrib: "المغرب",
  isha: "العشاء",
};

type Props = Readonly<{
  nextPrayer: PrayerTimeEntry;
  remainingMs: number | null;
  cityLabel: string;
}>;

const goldColor = BRAND_COLORS.gold.DEFAULT;

export const PrayerHeroCard = ({
  nextPrayer,
  remainingMs,
  cityLabel,
}: Props) => {
  const { t } = useTranslation();

  return (
    <View className="overflow-hidden rounded-3xl border border-gold/40 bg-onboarding-bg p-5">
      <View className="flex-row items-start justify-between gap-3">
        <View className="flex-1">
          <View className="flex-row items-center gap-1.5">
            <MapPin size={13} color={goldColor} />
            <Text className="text-xs font-semibold text-gold">
              {cityLabel} · {t("prayer.methodKemenag")}
            </Text>
          </View>

          <Text className="mt-3 text-xs font-medium text-onboarding-muted">
            {t("prayer.nextPrayerLabel")}
          </Text>
          <Text className="mt-0.5 font-serif text-3xl font-bold text-onboarding-text">
            {t(`prayer.names.${nextPrayer.name}`)}
          </Text>
        </View>

        <View className="items-end">
          <View className="rounded-2xl border border-gold/35 bg-onboarding-surface px-3.5 py-1.5">
            <Text className="font-arabic text-arabic-surah text-gold">
              {PRAYER_ARABIC[nextPrayer.name]}
            </Text>
          </View>
          <Text className="mt-2.5 text-2xl font-bold tabular-nums text-gold">
            {formatPrayerClock(nextPrayer.time)}
          </Text>
        </View>
      </View>

      {remainingMs !== null ? (
        <>
          <View className="my-3.5 h-px bg-gold/25" />
          <View className="flex-row items-center justify-between">
            <Text className="text-xs text-onboarding-muted">
              {t("prayer.countdownPrefix")}
            </Text>
            <View className="rounded-full bg-gold px-3.5 py-1">
              <Text className="text-xs font-bold tabular-nums text-on-gold">
                {formatCountdown(remainingMs)}
              </Text>
            </View>
          </View>
        </>
      ) : null}
    </View>
  );
};
