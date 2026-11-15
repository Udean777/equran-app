import { Clock, Compass, RefreshCw } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import { useState } from "react";
import { useTranslation } from "react-i18next";
import { ScrollView, Text, View } from "react-native";
import { IconButton } from "@/components/icon-button";
import { LuxuryHeader } from "@/components/luxury-header";
import { Screen } from "@/components/screen";
import { SegmentedTabs } from "@/components/segmented-tabs";
import { formatPrayerClock } from "@/features/prayer/domain/prayer-times";
import { PrayerAlarmCard } from "@/features/prayer/presentation/prayer-alarm-card";
import {
  PRAYER_ARABIC,
  PrayerHeroCard,
} from "@/features/prayer/presentation/prayer-hero-card";
import { usePrayerAlarms } from "@/features/prayer/presentation/use-prayer-alarms";
import { usePrayerTimes } from "@/features/prayer/presentation/use-prayer-times";
import { QiblaCompassView } from "@/features/qibla/presentation/qibla-compass-view";
import { cn } from "@/lib/cn";
import { getThemePalette } from "@/theme/palette";

type ActiveTab = "schedule" | "qibla";

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
          <IconButton
            label={t("prayer.refreshLocation")}
            onPress={() => void refreshLocation()}
            disabled={isLocating}
          >
            <RefreshCw size={18} color={palette.primary} />
          </IconButton>
        }
      />

      <ScrollView
        showsVerticalScrollIndicator={false}
        contentContainerClassName="pb-28"
      >
        <SegmentedTabs<ActiveTab>
          className="mt-1"
          value={activeTab}
          onChange={setActiveTab}
          options={[
            {
              value: "schedule",
              label: t("prayer.tabSchedule"),
              renderIcon: (color) => <Clock size={15} color={color} />,
            },
            {
              value: "qibla",
              label: t("prayer.tabQibla"),
              renderIcon: (color) => <Compass size={15} color={color} />,
            },
          ]}
        />

        {activeTab === "qibla" ? (
          <QiblaCompassView
            latitude={location.latitude}
            longitude={location.longitude}
            cityLabel={cityLabel}
          />
        ) : (
          <View className="mt-4 gap-4">
            {schedule.nextPrayer ? (
              <PrayerHeroCard
                nextPrayer={schedule.nextPrayer}
                remainingMs={schedule.remainingMs}
                cityLabel={cityLabel}
              />
            ) : null}

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

            <PrayerAlarmCard
              alarmsEnabled={alarmsEnabled}
              exactAlarmGranted={exactAlarmGranted}
              permissionDenied={permissionDenied}
              onToggle={(value) => void toggleAlarms(value)}
              onRequestExactAlarm={() => void requestExactAlarm()}
            />
          </View>
        )}
      </ScrollView>
    </Screen>
  );
};
