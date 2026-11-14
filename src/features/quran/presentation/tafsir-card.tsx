import { useTranslation } from "react-i18next";
import { Text, View } from "react-native";

import { type TafsirEntry } from "../domain/entities";

type Props = Readonly<{
  surahNumber: number;
  entry: TafsirEntry;
}>;

export const TafsirCard = ({ surahNumber, entry }: Props) => {
  const { t } = useTranslation();

  return (
    <View className="mb-3.5 rounded-3xl border border-border bg-surface p-5">
      <View className="mb-3 flex-row items-center gap-2.5">
        <View className="h-9 min-w-9 items-center justify-center rounded-xl border border-gold/40 bg-primary-container px-2.5">
          <Text className="text-xs font-bold text-on-primary-container">
            {surahNumber}:{entry.ayahNumber}
          </Text>
        </View>
        <Text className="text-xs font-semibold text-muted">
          {t("quran.ayahLabel", { number: entry.ayahNumber })}
        </Text>
      </View>
      <Text className="text-base leading-7 text-text">{entry.text}</Text>
    </View>
  );
};
