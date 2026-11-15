import { FlashList } from "@shopify/flash-list";
import { Plus } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import { useState } from "react";
import { useTranslation } from "react-i18next";
import { Text, View } from "react-native";
import { AnimatedPressable } from "@/components/animated-pressable";
import { ModalSheet } from "@/components/modal-sheet";
import { SearchInput } from "@/components/search-input";
import type { SurahSummary } from "@/features/quran/domain/entities";
import { getThemePalette } from "@/theme/palette";

type Props = Readonly<{
  visible: boolean;
  surahs: readonly SurahSummary[];
  trackedSurahNumbers: ReadonlySet<number>;
  onSelect: (surahNumber: number) => void;
  onClose: () => void;
}>;

export const SurahPickerModal = ({
  visible,
  surahs,
  trackedSurahNumbers,
  onSelect,
  onClose,
}: Props) => {
  const { t } = useTranslation();
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);
  const [query, setQuery] = useState("");

  const normalized = query.trim().toLowerCase();
  const filtered = normalized
    ? surahs.filter(
        (s) =>
          s.latin.toLowerCase().includes(normalized) ||
          String(s.number).includes(normalized),
      )
    : surahs;

  return (
    <ModalSheet
      visible={visible}
      title={t("hafalan.pickSurahTitle")}
      closeLabel={t("hafalan.close")}
      onClose={onClose}
    >
      <SearchInput
        className="mb-3"
        value={query}
        onChangeText={setQuery}
        placeholder={t("hafalan.searchSurahPlaceholder")}
        clearLabel={t("quran.clearSearch")}
      />

      <FlashList
        data={filtered}
        keyExtractor={(item) => String(item.number)}
        renderItem={({ item }) => {
          const alreadyAdded = trackedSurahNumbers.has(item.number);
          return (
            <AnimatedPressable
              accessibilityRole="button"
              accessibilityLabel={item.latin}
              disabled={alreadyAdded}
              onPress={() => {
                onSelect(item.number);
                onClose();
              }}
              className="mb-2 flex-row items-center justify-between rounded-2xl border border-border bg-surface px-4 py-3"
            >
              <View className="flex-row items-center gap-3">
                <View className="h-9 w-9 items-center justify-center rounded-xl bg-primary-container">
                  <Text className="text-xs font-bold tabular-nums text-on-primary-container">
                    {item.number}
                  </Text>
                </View>
                <View>
                  <Text className="text-sm font-semibold text-text">
                    {item.latin}
                  </Text>
                  <Text className="text-xs text-muted">
                    {item.ayatCount} {t("quran.ayatUnit")}
                  </Text>
                </View>
              </View>

              <View className="flex-row items-center gap-2">
                <Text className="font-arabic text-base text-primary">
                  {item.name}
                </Text>
                {alreadyAdded ? (
                  <Text className="text-xs font-medium text-muted">
                    {t("hafalan.addedBadge")}
                  </Text>
                ) : (
                  <Plus size={18} color={palette.primary} />
                )}
              </View>
            </AnimatedPressable>
          );
        }}
      />
    </ModalSheet>
  );
};
