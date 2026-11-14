import {
  Bell,
  BellOff,
  Clock,
  Compass,
  MapPin,
  RefreshCw,
} from "lucide-react-native";
import { useColorScheme } from "nativewind";
import { useState } from "react";
import { useTranslation } from "react-i18next";
import { ScrollView, Switch, Text, View } from "react-native";
import { AnimatedPressable } from "@/components/animated-pressable";
import { LuxuryHeader } from "@/components/luxury-header";
import { Screen } from "@/components/screen";
import {
  formatCountdown,
  formatPrayerClock,
  type PrayerName,
} from "@/features/prayer/domain/prayer-times";
import { usePrayerAlarms } from "@/features/prayer/presentation/use-prayer-alarms";
import { usePrayerTimes } from "@/features/prayer/presentation/use-prayer-times";
import { QiblaCompassView } from "@/features/qibla/presentation/qibla-compass-view";
import { cn } from "@/lib/cn";
import { BRAND_COLORS, getThemePalette } from "@/theme/palette";

type ActiveTab = "schedule" | "qibla";

const PRAYER_ARABIC: Record<PrayerName, string> = {
  fajr: "الفجر",
  sunrise: "الشروق",
  dhuhr: "الظهر",
  asr: "العصر",
  maghrib: "المغرب",
  isha: "العشاء",
};

const goldColor = BRAND_COLORS.gold.DEFAULT;

export const PrayerScreen = () => {
  const { t } = useTranslation();
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);
  const [activeTab, setActiveTab] = useState<ActiveTab>("schedule");

  const { location, schedule, isLocating, refreshLocation } = usePrayerTimes();
  const {
    alarmsEnabled,
    exactAlarmGranted,
    permissionDenied,
    toggleAlarms,
    requestExactAlarm,
  } = usePrayerAlarms(location.latitude, location.longitude);

  const cityLabel =
    location.city ??
    (location.source === "fallback"
      ? t("prayer.fallbackCity")
      : t("prayer.unknownCity"));

  return (
    <Screen edges={["top", "left", "right"]} className="px-4 pt-3">
      <LuxuryHeader
        title={t("prayer.title")}
        subtitle={cityLabel}
        showBrandMark
        rightAction={
          <AnimatedPressable
            accessibilityRole="button"
            accessibilityLabel={t("prayer.refreshLocation")}
            onPress={() => void refreshLocation()}
            disabled={isLocating}
            className="h-11 w-11 items-center justify-center rounded-2xl border border-border bg-surface"
          >
            <RefreshCw size={18} color={palette.primary} />
          </AnimatedPressable>
        }
      />

      <ScrollView
        showsVerticalScrollIndicator={false}
        contentContainerClassName="pb-28"
      >
        {/* Segmented mode switcher */}
        <View className="mt-1 flex-row rounded-2xl border border-border bg-surface p-1">
          <AnimatedPressable
            accessibilityRole="tab"
            accessibilityState={{ selected: activeTab === "schedule" }}
            accessibilityLabel={t("prayer.tabSchedule")}
            onPress={() => setActiveTab("schedule")}
            className={cn(
              "min-h-11 flex-1 flex-row items-center justify-center gap-2 rounded-xl px-3",
              activeTab === "schedule" ? "bg-onboarding-bg" : "bg-transparent",
            )}
          >
            <Clock
              size={15}
              color={activeTab === "schedule" ? goldColor : palette.muted}
            />
            <Text
              className={cn(
                "text-sm font-semibold",
                activeTab === "schedule"
                  ? "text-onboarding-text"
                  : "text-muted",
              )}
            >
              {t("prayer.tabSchedule")}
            </Text>
          </AnimatedPressable>

          <AnimatedPressable
            accessibilityRole="tab"
            accessibilityState={{ selected: activeTab === "qibla" }}
            accessibilityLabel={t("prayer.tabQibla")}
            onPress={() => setActiveTab("qibla")}
            className={cn(
              "min-h-11 flex-1 flex-row items-center justify-center gap-2 rounded-xl px-3",
              activeTab === "qibla" ? "bg-onboarding-bg" : "bg-transparent",
            )}
          >
            <Compass
              size={15}
              color={activeTab === "qibla" ? goldColor : palette.muted}
            />
            <Text
              className={cn(
                "text-sm font-semibold",
                activeTab === "qibla" ? "text-onboarding-text" : "text-muted",
              )}
            >
              {t("prayer.tabQibla")}
            </Text>
          </AnimatedPressable>
        </View>

        {activeTab === "qibla" ? (
          <QiblaCompassView
            latitude={location.latitude}
            longitude={location.longitude}
            cityLabel={cityLabel}
          />
        ) : (
          <View className="mt-4 gap-4">
            {/* Next Prayer Hero Card matching QuranHeroCard's emerald-and-gold palette */}
            {schedule.nextPrayer ? (
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
                      {t(`prayer.names.${schedule.nextPrayer.name}`)}
                    </Text>
                  </View>

                  <View className="items-end">
                    <View className="rounded-2xl border border-gold/35 bg-onboarding-surface px-3.5 py-1.5">
                      <Text className="font-arabic text-arabic-surah text-gold">
                        {PRAYER_ARABIC[schedule.nextPrayer.name]}
                      </Text>
                    </View>
                    <Text className="mt-2.5 text-2xl font-bold tabular-nums text-gold">
                      {formatPrayerClock(schedule.nextPrayer.time)}
                    </Text>
                  </View>
                </View>

                {schedule.remainingMs !== null ? (
                  <>
                    <View className="my-3.5 h-px bg-gold/25" />
                    <View className="flex-row items-center justify-between">
                      <Text className="text-xs text-onboarding-muted">
                        {t("prayer.countdownPrefix")}
                      </Text>
                      <View className="rounded-full bg-gold px-3.5 py-1">
                        <Text className="text-xs font-bold tabular-nums text-on-gold">
                          {formatCountdown(schedule.remainingMs)}
                        </Text>
                      </View>
                    </View>
                  </>
                ) : null}
              </View>
            ) : null}

            {/* Daily Schedule List */}
            <View className="overflow-hidden rounded-2xl border border-border bg-surface">
              {schedule.entries.map((entry, idx) => {
                const isNext = schedule.nextPrayer?.name === entry.name;
                return (
                  <View
                    key={entry.name}
                    className={cn(
                      "flex-row items-center justify-between px-4 py-3.5",
                      idx > 0 ? "border-t border-border" : "",
                      isNext
                        ? "border-l-4 border-l-primary bg-primary-container/50"
                        : "",
                    )}
                  >
                    <View className="flex-row items-center gap-3">
                      <Text
                        className={cn(
                          "text-base",
                          isNext
                            ? "font-bold text-primary"
                            : entry.isFardh
                              ? "font-semibold text-text"
                              : "font-normal text-muted",
                        )}
                      >
                        {t(`prayer.names.${entry.name}`)}
                      </Text>
                      {isNext ? (
                        <View className="rounded-md bg-primary px-2 py-0.5">
                          <Text className="text-[11px] font-semibold text-on-primary">
                            {t("prayer.nextBadge")}
                          </Text>
                        </View>
                      ) : null}
                    </View>

                    <View className="flex-row items-center gap-3">
                      <Text
                        className={cn(
                          "font-arabic text-base",
                          isNext ? "text-primary" : "text-muted",
                        )}
                      >
                        {PRAYER_ARABIC[entry.name]}
                      </Text>
                      <Text
                        className={cn(
                          "text-base tabular-nums",
                          isNext
                            ? "font-bold text-primary"
                            : entry.isFardh
                              ? "font-semibold text-text"
                              : "font-normal text-muted",
                        )}
                      >
                        {formatPrayerClock(entry.time)}
                      </Text>
                    </View>
                  </View>
                );
              })}
            </View>

            {/* Alarm Toggle & Android Exact Alarm Banner */}
            <View className="rounded-2xl border border-border bg-surface p-4">
              <View className="flex-row items-center justify-between gap-3">
                <View className="flex-1 flex-row items-center gap-3">
                  {alarmsEnabled ? (
                    <Bell size={18} color={palette.primary} />
                  ) : (
                    <BellOff size={18} color={palette.muted} />
                  )}
                  <View className="flex-1">
                    <Text className="text-sm font-semibold text-text">
                      {t("prayer.alarmsTitle")}
                    </Text>
                    <Text className="text-xs text-muted">
                      {t("prayer.alarmsSubtitle")}
                    </Text>
                  </View>
                </View>
                <Switch
                  value={alarmsEnabled}
                  onValueChange={(value) => void toggleAlarms(value)}
                  accessibilityLabel={t("prayer.alarmsTitle")}
                />
              </View>

              {alarmsEnabled && !exactAlarmGranted ? (
                <View className="mt-3 rounded-xl bg-warning-container p-3">
                  <Text className="text-xs leading-4 text-text">
                    {t("prayer.exactAlarmWarning")}
                  </Text>
                  <AnimatedPressable
                    accessibilityRole="button"
                    accessibilityLabel={t("prayer.enableExactAlarm")}
                    onPress={() => void requestExactAlarm()}
                    className="mt-2 min-h-11 items-center justify-center rounded-xl bg-primary px-3"
                  >
                    <Text className="text-xs font-semibold text-on-primary">
                      {t("prayer.enableExactAlarm")}
                    </Text>
                  </AnimatedPressable>
                </View>
              ) : null}

              {permissionDenied ? (
                <Text className="mt-2 text-xs text-error">
                  {t("prayer.notificationPermissionDenied")}
                </Text>
              ) : null}
            </View>
          </View>
        )}
      </ScrollView>
    </Screen>
  );
};
