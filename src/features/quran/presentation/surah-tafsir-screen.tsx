import { FlashList } from "@shopify/flash-list";
import { useRouter } from "expo-router";
import { useState } from "react";
import { useTranslation } from "react-i18next";
import Animated, {
  FadeIn,
  FadeInUp,
  FadeOutUp,
  LinearTransition,
} from "react-native-reanimated";

import { LuxuryHeader } from "@/components/luxury-header";
import { Screen } from "@/components/screen";
import { SearchInput } from "@/components/search-input";
import { StateView } from "@/components/state-view";
import { Toast } from "@/components/toast";

import { resolveQuranLanguage } from "../domain/entities";
import { TafsirCard } from "./tafsir-card";
import { useSurahTafsir } from "./use-surah-tafsir";

type Props = Readonly<{
  surahNumber: number;
}>;

export const SurahTafsirScreen = ({ surahNumber }: Props) => {
  const { t, i18n } = useTranslation();
  const router = useRouter();
  const isEnglish = resolveQuranLanguage(i18n.language) === "en";
  const [toastDismissed, setToastDismissed] = useState(false);
  const {
    tafsir,
    filteredEntries,
    searchQuery,
    setSearchQuery,
    isLoading,
    error,
    refetch,
  } = useSurahTafsir(surahNumber);

  const title = tafsir
    ? t("quran.tafsirTitle", { name: tafsir.surah.latin })
    : t("quran.tafsirButton");
  const subtitle = tafsir
    ? `${tafsir.surah.ayatCount} ${t("quran.ayatUnit")}`
    : undefined;

  return (
    <Screen className="px-4 pt-2">
      <LuxuryHeader
        title={title}
        subtitle={subtitle}
        backLabel={t("quran.back")}
        onBack={() => router.back()}
      />

      {tafsir ? (
        <Animated.View
          entering={FadeInUp.duration(180)}
          exiting={FadeOutUp.duration(140)}
          className="mb-3"
        >
          <SearchInput
            value={searchQuery}
            onChangeText={setSearchQuery}
            placeholder={t("quran.searchAyatPlaceholder")}
            clearLabel={t("quran.clearSearch")}
          />
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
      {!isLoading && !error && tafsir && filteredEntries.length === 0 ? (
        <StateView kind="empty" message={t("quran.searchAyatEmpty")} />
      ) : null}
      {!isLoading && !error && tafsir && filteredEntries.length > 0 ? (
        <Animated.View
          entering={FadeIn.duration(220)}
          layout={LinearTransition.duration(200)}
          className="flex-1"
        >
          <FlashList
            data={filteredEntries}
            keyExtractor={(item) => String(item.ayahNumber)}
            renderItem={({ item }) => (
              <TafsirCard surahNumber={surahNumber} entry={item} />
            )}
            keyboardShouldPersistTaps="handled"
            keyboardDismissMode="on-drag"
            showsVerticalScrollIndicator={false}
          />
        </Animated.View>
      ) : null}

      <Toast
        visible={isEnglish && !toastDismissed}
        message={t("quran.tafsirEnUnavailable")}
        dismissLabel={t("quran.dismissToast")}
        onDismiss={() => setToastDismissed(true)}
      />
    </Screen>
  );
};
