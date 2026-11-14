import { FlashList } from "@shopify/flash-list";
import { Plus, Search, X } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import { useState } from "react";
import { useTranslation } from "react-i18next";
import { Modal, Text, TextInput, View } from "react-native";
import { AnimatedPressable } from "@/components/animated-pressable";
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
    <Modal
      visible={visible}
      animationType="slide"
      presentationStyle="pageSheet"
      onRequestClose={onClose}
    >
      <View className="flex-1 bg-bg px-4 pt-4">
        <View className="mb-3 flex-row items-center justify-between">
          <Text className="font-serif text-xl font-bold text-text">
            {t("hafalan.pickSurahTitle")}
          </Text>
          <AnimatedPressable
            accessibilityRole="button"
            accessibilityLabel={t("hafalan.close")}
            onPress={onClose}
            className="h-11 w-11 items-center justify-center rounded-2xl border border-border bg-surface"
          >
            <X size={18} color={palette.text} />
          </AnimatedPressable>
        </View>

        <View className="mb-3 flex-row items-center gap-2 rounded-2xl border border-border bg-surface px-3.5 py-2.5">
          <Search size={16} color={palette.muted} />
          <TextInput
            value={query}
            onChangeText={setQuery}
            placeholder={t("hafalan.searchSurahPlaceholder")}
            placeholderTextColor={palette.muted}
            className="flex-1 text-sm text-text"
          />
        </View>

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
      </View>
    </Modal>
  );
};
