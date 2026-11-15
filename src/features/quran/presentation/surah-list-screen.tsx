import { FlashList } from "@shopify/flash-list";
import { useRouter } from "expo-router";
import { Moon, Sun } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import { useTranslation } from "react-i18next";
import { Text, View } from "react-native";
import Animated, { FadeIn, LinearTransition } from "react-native-reanimated";

import { AnimatedPressable } from "@/components/animated-pressable";
import { IconButton } from "@/components/icon-button";
import { LuxuryHeader } from "@/components/luxury-header";
import { Screen } from "@/components/screen";
import { SearchInput } from "@/components/search-input";
import { SectionHeader } from "@/components/section-header";
import { StateView } from "@/components/state-view";
import { MurattalMiniPlayer } from "@/features/audio/presentation/murattal-mini-player";
import { cn } from "@/lib/cn";
import { getThemePalette } from "@/theme/palette";
import { useThemeStore } from "@/theme/use-theme-store";

import { type RevelationFilter, type SurahSummary } from "../domain/entities";
import { QuranHeroCard } from "./quran-hero-card";
import { SurahCard } from "./surah-card";
import { useLastReadStore } from "./use-last-read-store";
import { useSurahList } from "./use-surah-list";

const FILTER_OPTIONS: readonly {
  readonly value: RevelationFilter;
  readonly labelKey: string;
}[] = [
  { value: "all", labelKey: "quran.filterAll" },
  { value: "Mekah", labelKey: "quran.revelationMekah" },
  { value: "Madinah", labelKey: "quran.revelationMadinah" },
];

export const SurahListScreen = () => {
  const { t } = useTranslation();
  const router = useRouter();
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);
  const setThemeMode = useThemeStore((state) => state.setMode);
  const lastRead = useLastReadStore((state) => state.lastRead);
  const recordLastRead = useLastReadStore((state) => state.recordLastRead);
  const {
    surahs,
    searchQuery,
    setSearchQuery,
    revelationFilter,
    setRevelationFilter,
    isLoading,
    error,
    refetch,
  } = useSurahList();

  const toggleTheme = () => {
    setThemeMode(colorScheme === "dark" ? "light" : "dark");
  };

  const openSurahByNumber = (surahNumber: number) => {
    router.push({
      pathname: "/surah/[number]",
      params: { number: String(surahNumber) },
    });
  };

  const openSurah = (surah: SurahSummary) => {
    recordLastRead({
      number: surah.number,
      name: surah.name,
      latin: surah.latin,
      ayatCount: surah.ayatCount,
    });
    openSurahByNumber(surah.number);
  };

  return (
    <Screen edges={["top", "left", "right"]} className="px-4 pt-3">
      <LuxuryHeader
        title="Qurva"
        subtitle={t("quran.title")}
        showBrandMark
        rightAction={
          <IconButton label={t("settings.theme")} onPress={toggleTheme}>
            {colorScheme === "dark" ? (
              <Sun color={palette.primary} size={19} />
            ) : (
              <Moon color={palette.primary} size={19} />
            )}
          </IconButton>
        }
      />

      <SearchInput
        className="mb-2.5"
        value={searchQuery}
        onChangeText={setSearchQuery}
        placeholder={t("quran.searchPlaceholder")}
        clearLabel={t("quran.clearSearch")}
      />

      <View className="mb-3 flex-row items-center gap-2">
        {FILTER_OPTIONS.map((item) => {
          const active = revelationFilter === item.value;
          return (
            <AnimatedPressable
              key={item.value}
              containerClassName="flex-1"
              accessibilityRole="button"
              accessibilityLabel={t(item.labelKey)}
              onPress={() => setRevelationFilter(item.value)}
              className={cn(
                "min-h-11 items-center justify-center rounded-xl border px-3 py-2",
                active
                  ? "border-primary bg-primary"
                  : "border-border bg-surface",
              )}
            >
              <Text
                className={cn(
                  "text-xs font-bold",
                  active ? "text-on-primary" : "text-muted",
                )}
              >
                {t(item.labelKey)}
              </Text>
            </AnimatedPressable>
          );
        })}
      </View>

      {isLoading ? <StateView kind="loading" /> : null}
      {!isLoading && error ? (
        <StateView
          kind="error"
          errorCode={error.code}
          onRetry={() => {
            void refetch();
          }}
        />
      ) : null}
      {!isLoading && !error && surahs.length === 0 ? (
        <StateView kind="empty" message={t("quran.searchEmpty")} />
      ) : null}
      {!isLoading && !error && surahs.length > 0 ? (
        <Animated.View
          entering={FadeIn.duration(220)}
          layout={LinearTransition.duration(200)}
          className="flex-1"
        >
          <FlashList
            data={surahs}
            keyExtractor={(item) => String(item.number)}
            ListHeaderComponent={
              <View>
                <QuranHeroCard
                  lastRead={lastRead}
                  onOpenSurah={openSurahByNumber}
                />
                <SectionHeader
                  title={t("quran.surahListHeader")}
                  trailingText={t("quran.surahCountBadge", {
                    count: surahs.length,
                  })}
                />
              </View>
            }
            renderItem={({ item }) => (
              <SurahCard surah={item} onPress={openSurah} />
            )}
            keyboardShouldPersistTaps="handled"
            keyboardDismissMode="on-drag"
            showsVerticalScrollIndicator={false}
          />
        </Animated.View>
      ) : null}

      <MurattalMiniPlayer />
    </Screen>
  );
};
