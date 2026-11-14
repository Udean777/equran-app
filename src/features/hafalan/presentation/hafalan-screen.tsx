import { FlashList } from "@shopify/flash-list";
import { format } from "date-fns";
import { BookOpen, History, Mic, Plus, Trash2 } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import { useState } from "react";
import { useTranslation } from "react-i18next";
import { Text, View } from "react-native";
import { AnimatedPressable } from "@/components/animated-pressable";
import { LuxuryHeader } from "@/components/luxury-header";
import { Screen } from "@/components/screen";
import type { HafalanItem } from "@/features/hafalan/domain/murajaah";
import { HafalanStatsCard } from "@/features/hafalan/presentation/hafalan-stats-card";
import { SetoranSheet } from "@/features/hafalan/presentation/setoran-sheet";
import { SurahPickerModal } from "@/features/hafalan/presentation/surah-picker-modal";
import { useHafalan } from "@/features/hafalan/presentation/use-hafalan";
import { useSurahList } from "@/features/quran/presentation/use-surah-list";
import { cn } from "@/lib/cn";
import { BRAND_COLORS, getThemePalette } from "@/theme/palette";

type ActiveTab = "targets" | "history";
const goldColor = BRAND_COLORS.gold.DEFAULT;

export const HafalanScreen = () => {
  const { t } = useTranslation();
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);
  const { surahs } = useSurahList();
  const { items, history, stats, addTarget, deleteTarget } = useHafalan();

  const [activeTab, setActiveTab] = useState<ActiveTab>("targets");
  const [pickerOpen, setPickerOpen] = useState(false);
  const [activeSetoranItem, setActiveSetoranItem] =
    useState<HafalanItem | null>(null);

  const surahByNumber = new Map(surahs.map((s) => [s.number, s]));
  const trackedSet = new Set(items.map((item) => item.surahNumber));
  const itemById = new Map(items.map((item) => [item.id, item]));

  const resolveSurahLabel = (surahNumber: number): string =>
    surahByNumber.get(surahNumber)?.latin ??
    t("quran.surahNumberLabel", { number: surahNumber });

  return (
    <Screen edges={["top", "left", "right"]} className="px-4 pt-3">
      <LuxuryHeader
        title={t("hafalan.title")}
        subtitle={t("hafalan.subtitle")}
        showBrandMark
        rightAction={
          <AnimatedPressable
            accessibilityRole="button"
            accessibilityLabel={t("hafalan.addTarget")}
            onPress={() => setPickerOpen(true)}
            className="h-11 w-11 items-center justify-center rounded-2xl border border-border bg-surface"
          >
            <Plus size={19} color={palette.primary} />
          </AnimatedPressable>
        }
      />

      <HafalanStatsCard stats={stats} />

      <View className="mb-3 flex-row rounded-2xl border border-border bg-surface p-1">
        <AnimatedPressable
          accessibilityRole="tab"
          accessibilityState={{ selected: activeTab === "targets" }}
          accessibilityLabel={t("hafalan.tabTargets")}
          onPress={() => setActiveTab("targets")}
          className={cn(
            "min-h-11 flex-1 flex-row items-center justify-center gap-2 rounded-xl px-3",
            activeTab === "targets" ? "bg-onboarding-bg" : "bg-transparent",
          )}
        >
          <BookOpen
            size={15}
            color={activeTab === "targets" ? goldColor : palette.muted}
          />
          <Text
            className={cn(
              "text-sm font-semibold",
              activeTab === "targets" ? "text-onboarding-text" : "text-muted",
            )}
          >
            {t("hafalan.tabTargets")}
          </Text>
        </AnimatedPressable>

        <AnimatedPressable
          accessibilityRole="tab"
          accessibilityState={{ selected: activeTab === "history" }}
          accessibilityLabel={t("hafalan.tabHistory")}
          onPress={() => setActiveTab("history")}
          className={cn(
            "min-h-11 flex-1 flex-row items-center justify-center gap-2 rounded-xl px-3",
            activeTab === "history" ? "bg-onboarding-bg" : "bg-transparent",
          )}
        >
          <History
            size={15}
            color={activeTab === "history" ? goldColor : palette.muted}
          />
          <Text
            className={cn(
              "text-sm font-semibold",
              activeTab === "history" ? "text-onboarding-text" : "text-muted",
            )}
          >
            {t("hafalan.tabHistory")}
          </Text>
        </AnimatedPressable>
      </View>

      {activeTab === "targets" ? (
        <FlashList
          data={items}
          keyExtractor={(item) => item.id}
          contentContainerStyle={{ paddingBottom: 112 }}
          ListEmptyComponent={
            <View className="mt-4 items-center rounded-3xl border border-border bg-surface p-6">
              <Text className="text-center font-serif text-lg font-bold text-text">
                {t("hafalan.emptyTitle")}
              </Text>
              <Text className="mt-1.5 text-center text-xs leading-5 text-muted">
                {t("hafalan.emptySubtitle")}
              </Text>
              <AnimatedPressable
                accessibilityRole="button"
                accessibilityLabel={t("hafalan.addTarget")}
                onPress={() => setPickerOpen(true)}
                className="mt-4 min-h-11 flex-row items-center gap-2 rounded-full bg-primary px-5 py-2.5"
              >
                <Plus size={16} color={palette.onPrimary} />
                <Text className="text-xs font-bold text-on-primary">
                  {t("hafalan.addTarget")}
                </Text>
              </AnimatedPressable>
            </View>
          }
          renderItem={({ item }) => {
            const surah = surahByNumber.get(item.surahNumber);
            const isDue = item.status === "due";
            return (
              <View
                className={cn(
                  "mb-3 rounded-2xl border bg-surface p-4",
                  isDue
                    ? "border-l-4 border-border border-l-gold"
                    : "border-border",
                )}
              >
                <View className="flex-row items-start justify-between gap-3">
                  <View className="flex-1">
                    <View className="flex-row items-center gap-2">
                      <Text className="font-serif text-lg font-bold text-text">
                        {surah?.latin ??
                          t("quran.surahNumberLabel", {
                            number: item.surahNumber,
                          })}
                      </Text>
                      <View
                        className={cn(
                          "rounded-md px-2 py-0.5",
                          isDue ? "bg-gold" : "bg-primary-container",
                        )}
                      >
                        <Text
                          className={cn(
                            "text-[11px] font-semibold",
                            isDue
                              ? "text-on-gold"
                              : "text-on-primary-container",
                          )}
                        >
                          {t(`hafalan.status.${item.status}`)}
                        </Text>
                      </View>
                    </View>

                    <Text className="mt-1 text-xs text-muted">
                      {item.nextMurajaahAt
                        ? t("hafalan.nextMurajaahDate", {
                            date: format(
                              new Date(item.nextMurajaahAt),
                              "dd MMM yyyy",
                            ),
                          })
                        : t("hafalan.notTestedYet")}
                    </Text>
                  </View>

                  {surah ? (
                    <Text className="font-arabic text-xl text-primary">
                      {surah.name}
                    </Text>
                  ) : null}
                </View>

                <View className="mt-3 flex-row items-center justify-between gap-2">
                  <AnimatedPressable
                    accessibilityRole="button"
                    accessibilityLabel={t("hafalan.startSetoran")}
                    onPress={() => setActiveSetoranItem(item)}
                    className="min-h-11 flex-1 flex-row items-center justify-center gap-2 rounded-xl bg-primary px-4"
                  >
                    <Mic size={15} color={palette.onPrimary} />
                    <Text className="text-xs font-bold text-on-primary">
                      {t("hafalan.startSetoran")}
                    </Text>
                  </AnimatedPressable>

                  <AnimatedPressable
                    accessibilityRole="button"
                    accessibilityLabel={t("hafalan.deleteTarget")}
                    onPress={() => void deleteTarget(item.id)}
                    className="h-11 w-11 items-center justify-center rounded-xl border border-border bg-surface-variant"
                  >
                    <Trash2 size={16} color={palette.muted} />
                  </AnimatedPressable>
                </View>
              </View>
            );
          }}
        />
      ) : (
        <FlashList
          data={history}
          keyExtractor={(item) => item.id}
          contentContainerStyle={{ paddingBottom: 112 }}
          ListEmptyComponent={
            <View className="mt-4 items-center rounded-3xl border border-border bg-surface p-6">
              <Text className="text-center font-serif text-lg font-bold text-text">
                {t("hafalan.historyEmptyTitle")}
              </Text>
              <Text className="mt-1.5 text-center text-xs text-muted">
                {t("hafalan.historyEmptySubtitle")}
              </Text>
            </View>
          }
          renderItem={({ item }) => {
            const parent = itemById.get(item.hafalanId);
            const label = parent
              ? resolveSurahLabel(parent.surahNumber)
              : t("hafalan.unknownSurah");
            return (
              <View className="mb-2.5 flex-row items-center justify-between rounded-2xl border border-border bg-surface px-4 py-3.5">
                <View>
                  <Text className="text-sm font-semibold text-text">
                    {label}
                  </Text>
                  <Text className="mt-0.5 text-xs text-muted">
                    {format(new Date(item.createdAt), "dd MMM yyyy, HH:mm")}
                  </Text>
                </View>

                <View
                  className={cn(
                    "rounded-full px-3 py-1",
                    item.passed ? "bg-primary-container" : "bg-error-container",
                  )}
                >
                  <Text
                    className={cn(
                      "text-xs font-bold tabular-nums",
                      item.passed ? "text-primary" : "text-error",
                    )}
                  >
                    {item.score.toFixed(0)}%
                  </Text>
                </View>
              </View>
            );
          }}
        />
      )}

      <SurahPickerModal
        visible={pickerOpen}
        surahs={surahs}
        trackedSurahNumbers={trackedSet}
        onSelect={(surahNumber) => void addTarget(surahNumber)}
        onClose={() => setPickerOpen(false)}
      />

      <SetoranSheet
        item={activeSetoranItem}
        surahLabel={
          activeSetoranItem
            ? resolveSurahLabel(activeSetoranItem.surahNumber)
            : ""
        }
        onClose={() => setActiveSetoranItem(null)}
      />
    </Screen>
  );
};
