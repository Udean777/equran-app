import { format } from "date-fns";
import { Mic, Trash2 } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import { useTranslation } from "react-i18next";
import { Text, View } from "react-native";
import { Button } from "@/components/button";
import { IconButton } from "@/components/icon-button";
import type { HafalanItem } from "@/features/hafalan/domain/murajaah";
import type { SurahSummary } from "@/features/quran/domain/entities";
import { cn } from "@/lib/cn";
import { getThemePalette } from "@/theme/palette";

type Props = Readonly<{
  item: HafalanItem;
  surah?: SurahSummary;
  onStartSetoran: (item: HafalanItem) => void;
  onDelete: (id: string) => void;
}>;

export const HafalanTargetCard = ({
  item,
  surah,
  onStartSetoran,
  onDelete,
}: Props) => {
  const { t } = useTranslation();
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);
  const isDue = item.status === "due";

  return (
    <View
      className={cn(
        "mb-3 rounded-2xl border bg-surface p-4",
        isDue ? "border-l-4 border-border border-l-gold" : "border-border",
      )}
    >
      <View className="flex-row items-start justify-between gap-3">
        <View className="flex-1">
          <View className="flex-row items-center gap-2">
            <Text className="font-serif text-lg font-bold text-text">
              {surah?.latin ??
                t("quran.surahNumberLabel", { number: item.surahNumber })}
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
                  isDue ? "text-on-gold" : "text-on-primary-container",
                )}
              >
                {t(`hafalan.status.${item.status}`)}
              </Text>
            </View>
          </View>

          <Text className="mt-1 text-xs text-muted">
            {item.nextMurajaahAt
              ? t("hafalan.nextMurajaahDate", {
                  date: format(new Date(item.nextMurajaahAt), "dd MMM yyyy"),
                })
              : t("hafalan.notTestedYet")}
          </Text>
        </View>

        {surah ? (
          <Text className="font-arabic text-xl text-primary">{surah.name}</Text>
        ) : null}
      </View>

      <View className="mt-3 flex-row items-center justify-between gap-2">
        <Button
          containerClassName="flex-1"
          size="sm"
          shape="soft"
          label={t("hafalan.startSetoran")}
          icon={<Mic size={15} color={palette.onPrimary} />}
          onPress={() => onStartSetoran(item)}
        />

        <IconButton
          variant="tonal"
          label={t("hafalan.deleteTarget")}
          onPress={() => onDelete(item.id)}
        >
          <Trash2 size={16} color={palette.muted} />
        </IconButton>
      </View>
    </View>
  );
};
