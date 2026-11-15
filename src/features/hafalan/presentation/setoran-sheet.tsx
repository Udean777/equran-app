import { CheckCircle2, Mic, Square, XCircle } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import { useTranslation } from "react-i18next";
import { ActivityIndicator, ScrollView, Text, View } from "react-native";
import { Button } from "@/components/button";
import { ModalSheet } from "@/components/modal-sheet";
import type { HafalanItem } from "@/features/hafalan/domain/murajaah";
import { useSetoran } from "@/features/hafalan/presentation/use-setoran";
import { useSurahDetail } from "@/features/quran/presentation/use-surah-detail";
import { cn } from "@/lib/cn";
import { BRAND_COLORS, getThemePalette } from "@/theme/palette";

type Props = Readonly<{
  item: HafalanItem | null;
  surahLabel: string;
  onClose: () => void;
}>;

export const SetoranSheet = ({ item, surahLabel, onClose }: Props) => {
  const { t } = useTranslation();
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);
  const { detail, isLoading } = useSurahDetail(item?.surahNumber ?? 1);
  const { phase, result, errorMessage, startRecording, stopAndCompare, reset } =
    useSetoran();

  const targetText =
    detail?.ayat.map((ayah) => ayah.textArabic).join(" ") ?? "";

  const handleClose = () => {
    reset();
    onClose();
  };

  return (
    <ModalSheet
      visible={item !== null}
      title={surahLabel}
      subtitle={t("hafalan.setoranSubtitle")}
      closeLabel={t("hafalan.close")}
      onClose={handleClose}
    >
      <ScrollView
        showsVerticalScrollIndicator={false}
        contentContainerClassName="pb-12 gap-4"
      >
        {isLoading ? (
          <View className="items-center py-8">
            <ActivityIndicator color={palette.primary} />
            <Text className="mt-2 text-xs text-muted">
              {t("hafalan.loadingAyahs")}
            </Text>
          </View>
        ) : (
          <View className="rounded-3xl border border-gold/40 bg-onboarding-bg p-5">
            <Text className="text-xs font-bold uppercase tracking-wider text-gold">
              {t("hafalan.targetPreviewLabel")}
            </Text>
            <Text
              numberOfLines={5}
              className="mt-2 text-right font-arabic text-arabic-ayah leading-loose text-onboarding-text"
            >
              {targetText}
            </Text>
          </View>
        )}

        <View className="items-center rounded-3xl border border-border bg-surface p-6">
          {phase === "comparing" ? (
            <View className="items-center py-2">
              <ActivityIndicator size="large" color={palette.primary} />
              <Text className="mt-3 text-sm font-semibold text-text">
                {t("hafalan.comparingAudio")}
              </Text>
            </View>
          ) : phase === "recording" ? (
            <Button
              variant="danger"
              size="xl"
              label={t("hafalan.stopAndEvaluate")}
              icon={<Square size={18} color={BRAND_COLORS.semantic.onError} />}
              onPress={() => {
                if (!item) return;
                void stopAndCompare({
                  hafalanId: item.id,
                  surahLabel,
                  targetText,
                });
              }}
            />
          ) : (
            <Button
              size="xl"
              label={t("hafalan.startRecording")}
              icon={<Mic size={18} color={palette.onPrimary} />}
              disabled={isLoading || targetText.length === 0}
              onPress={() => void startRecording()}
            />
          )}

          {errorMessage ? (
            <Text className="mt-3 text-center text-xs text-error">
              {errorMessage}
            </Text>
          ) : null}
        </View>

        {result ? (
          <View className="rounded-3xl border border-border bg-surface p-5">
            <View className="flex-row items-center justify-between">
              <View className="flex-row items-center gap-2">
                {result.passed ? (
                  <CheckCircle2 size={20} color={palette.primary} />
                ) : (
                  <XCircle size={20} color={BRAND_COLORS.semantic.error} />
                )}
                <Text
                  className={cn(
                    "text-base font-bold",
                    result.passed ? "text-primary" : "text-error",
                  )}
                >
                  {result.passed
                    ? t("hafalan.resultPassed")
                    : t("hafalan.resultNeedsReview")}
                </Text>
              </View>

              <View className="rounded-full bg-gold px-3.5 py-1">
                <Text className="text-sm font-bold tabular-nums text-on-gold">
                  {result.score.toFixed(0)}%
                </Text>
              </View>
            </View>

            <Text className="mt-3 text-xs font-medium text-muted">
              {t("hafalan.transcribedLabel")}
            </Text>
            <Text className="mt-1 text-right font-arabic text-xl text-text">
              {result.transcribed || "—"}
            </Text>

            {result.word_errors.length > 0 ? (
              <View className="mt-4 border-t border-border pt-3">
                <Text className="mb-2 text-xs font-semibold text-muted">
                  {t("hafalan.wordErrorsLabel", {
                    count: result.word_errors.length,
                  })}
                </Text>
                <View className="flex-row flex-wrap gap-2">
                  {result.word_errors.map((errItem, idx) => (
                    <View
                      key={`${errItem.word}-${idx}`}
                      className="rounded-xl border border-border bg-surface-variant px-3 py-1.5"
                    >
                      <Text className="font-arabic text-sm text-text">
                        {errItem.word}
                      </Text>
                    </View>
                  ))}
                </View>
              </View>
            ) : null}
          </View>
        ) : null}
      </ScrollView>
    </ModalSheet>
  );
};
