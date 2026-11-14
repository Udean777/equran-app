import { FlashList } from "@shopify/flash-list";
import { useRouter } from "expo-router";
import { BookOpenText, Search, X } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import { useEffect } from "react";
import { useTranslation } from "react-i18next";
import { Pressable, Text, TextInput } from "react-native";
import Animated, {
  FadeIn,
  FadeInUp,
  FadeOutUp,
  LinearTransition,
} from "react-native-reanimated";

import { AnimatedPressable } from "@/components/animated-pressable";
import { LuxuryHeader } from "@/components/luxury-header";
import { Screen } from "@/components/screen";
import { StateView } from "@/components/state-view";
import { MurattalMiniPlayer } from "@/features/audio/presentation/murattal-mini-player";
import { useMurattalPlayer } from "@/features/audio/presentation/use-murattal-player";
import { getThemePalette } from "@/theme/palette";

import { AyahCard } from "./ayah-card";
import { SurahBannerCard } from "./surah-banner-card";
import { useLastReadStore } from "./use-last-read-store";
import { useSurahDetail } from "./use-surah-detail";

type Props = Readonly<{
  surahNumber: number;
}>;

export const SurahDetailScreen = ({ surahNumber }: Props) => {
  const { t } = useTranslation();
  const router = useRouter();
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);
  const recordLastRead = useLastReadStore((state) => state.recordLastRead);
  const {
    detail,
    filteredAyat,
    language,
    searchQuery,
    setSearchQuery,
    isLoading,
    error,
    refetch,
  } = useSurahDetail(surahNumber);
  const {
    activeSurah,
    currentAyah,
    playbackMode,
    isPlaying,
    playAyah,
    playSurah,
  } = useMurattalPlayer();
  const isThisSurahActive = activeSurah?.number === detail?.surah.number;
  const isThisSurahPlaying =
    isThisSurahActive && playbackMode === "surah" && isPlaying;

  useEffect(() => {
    if (!detail) return;
    recordLastRead({
      number: detail.surah.number,
      name: detail.surah.name,
      latin: detail.surah.latin,
      ayatCount: detail.surah.ayatCount,
    });
  }, [detail, recordLastRead]);

  const openTafsir = () => {
    router.push({
      pathname: "/surah/[number]/tafsir",
      params: { number: String(surahNumber) },
    });
  };

  const subtitle = detail
    ? `${t("quran.surahNumberLabel", { number: detail.surah.number })} • ${detail.surah.ayatCount} ${t("quran.ayatUnit")}`
    : undefined;

  return (
    <Screen className="px-4 pt-2">
      <LuxuryHeader
        title={detail ? detail.surah.latin : t("quran.title")}
        subtitle={subtitle}
        backLabel={t("quran.back")}
        onBack={() => router.back()}
        rightAction={
          <AnimatedPressable
            accessibilityRole="button"
            accessibilityLabel={t("quran.tafsirButton")}
            onPress={openTafsir}
            className="min-h-11 min-w-11 flex-row items-center gap-1.5 rounded-2xl border border-gold/40 bg-primary-container px-3.5 py-2"
          >
            <BookOpenText color={palette.onPrimaryContainer} size={16} />
            <Text className="text-xs font-bold text-on-primary-container">
              {t("quran.tafsirButton")}
            </Text>
          </AnimatedPressable>
        }
      />

      {detail ? (
        <Animated.View
          entering={FadeInUp.duration(180)}
          exiting={FadeOutUp.duration(140)}
          className="mb-3 min-h-11 flex-row items-center gap-2.5 rounded-2xl border border-border bg-surface px-3.5"
        >
          <Search color={palette.primary} size={17} />
          <TextInput
            accessibilityLabel={t("quran.searchAyatPlaceholder")}
            placeholder={t("quran.searchAyatPlaceholder")}
            placeholderTextColor={palette.muted}
            value={searchQuery}
            onChangeText={setSearchQuery}
            className="flex-1 py-2 text-sm text-text"
          />
          {searchQuery.length > 0 ? (
            <Pressable
              accessibilityRole="button"
              accessibilityLabel={t("quran.clearSearch")}
              onPress={() => setSearchQuery("")}
              className="min-h-11 min-w-11 items-center justify-center"
            >
              <X color={palette.muted} size={16} />
            </Pressable>
          ) : null}
        </Animated.View>
      ) : null}

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
      {!isLoading && !error && detail && filteredAyat.length === 0 ? (
        <StateView kind="empty" message={t("quran.searchAyatEmpty")} />
      ) : null}
      {!isLoading && !error && detail && filteredAyat.length > 0 ? (
        <Animated.View
          entering={FadeIn.duration(220)}
          layout={LinearTransition.duration(200)}
          className="flex-1"
        >
          <FlashList
            data={filteredAyat}
            keyExtractor={(item) => String(item.number)}
            renderItem={({ item }) => {
              const isActiveAyah =
                isThisSurahActive && currentAyah === item.number;
              return (
                <AyahCard
                  ayah={item}
                  totalAyat={detail.surah.ayatCount}
                  isActiveAyah={isActiveAyah}
                  isPlayingAyah={isActiveAyah && isPlaying}
                  onTogglePlay={() => playAyah(detail.surah, item.number)}
                  onOpenTafsir={openTafsir}
                />
              );
            }}
            ListHeaderComponent={
              searchQuery.trim().length === 0 ? (
                <SurahBannerCard
                  surah={detail.surah}
                  isPlayingSurah={isThisSurahPlaying}
                  onTogglePlaySurah={() => playSurah(detail.surah)}
                />
              ) : null
            }
            ListFooterComponent={
              language === "en" ? (
                <Text className="pb-6 pt-2 text-center text-xs text-muted">
                  {t("quran.englishAttribution")}
                </Text>
              ) : null
            }
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
