import { FlashList } from "@shopify/flash-list";
import { format } from "date-fns";
import { BookOpen, History, Plus } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import { useState } from "react";
import { useTranslation } from "react-i18next";
import { Text, View } from "react-native";
import { AnimatedPressable } from "@/components/animated-pressable";
import { LuxuryHeader } from "@/components/luxury-header";
import { Screen } from "@/components/screen";
import { SegmentedTabs } from "@/components/segmented-tabs";
import type { HafalanItem } from "@/features/hafalan/domain/murajaah";
import { HafalanStatsCard } from "@/features/hafalan/presentation/hafalan-stats-card";
import { HafalanTargetCard } from "@/features/hafalan/presentation/hafalan-target-card";
import { SetoranSheet } from "@/features/hafalan/presentation/setoran-sheet";
import { SurahPickerModal } from "@/features/hafalan/presentation/surah-picker-modal";
import { useHafalan } from "@/features/hafalan/presentation/use-hafalan";
import { useSurahList } from "@/features/quran/presentation/use-surah-list";
import { cn } from "@/lib/cn";
import { getThemePalette } from "@/theme/palette";

type ActiveTab = "targets" | "history";

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

      <SegmentedTabs<ActiveTab>
        className="mb-3"
        value={activeTab}
        onChange={setActiveTab}
        options={[
          {
            value: "targets",
            label: t("hafalan.tabTargets"),
            renderIcon: (color) => <BookOpen size={15} color={color} />,
          },
          {
            value: "history",
            label: t("hafalan.tabHistory"),
            renderIcon: (color) => <History size={15} color={color} />,
          },
        ]}
      />

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
          renderItem={({ item }) => (
            <HafalanTargetCard
              item={item}
              surah={surahByNumber.get(item.surahNumber)}
              onStartSetoran={setActiveSetoranItem}
              onDelete={(id) => void deleteTarget(id)}
            />
          )}
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
