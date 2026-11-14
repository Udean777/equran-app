import { CheckCircle2, Mic, Square, X, XCircle } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import { useTranslation } from "react-i18next";
import { ActivityIndicator, Modal, ScrollView, Text, View } from "react-native";
import { AnimatedPressable } from "@/components/animated-pressable";
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
    <Modal
      visible={item !== null}
      animationType="slide"
      presentationStyle="pageSheet"
      onRequestClose={handleClose}
    >
      <View className="flex-1 bg-bg px-4 pt-4">
        <View className="mb-4 flex-row items-center justify-between border-b border-border pb-3">
          <View>
            <Text className="font-serif text-xl font-bold text-text">
              {surahLabel}
            </Text>
            <Text className="text-xs text-muted">
              {t("hafalan.setoranSubtitle")}
            </Text>
          </View>
          <AnimatedPressable
            accessibilityRole="button"
            accessibilityLabel={t("hafalan.close")}
            onPress={handleClose}
            className="h-11 w-11 items-center justify-center rounded-2xl border border-border bg-surface"
          >
            <X size={18} color={palette.text} />
          </AnimatedPressable>
        </View>

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

          {/* Recording CTA */}
          <View className="items-center rounded-3xl border border-border bg-surface p-6">
            {phase === "comparing" ? (
              <View className="items-center py-2">
                <ActivityIndicator size="large" color={palette.primary} />
                <Text className="mt-3 text-sm font-semibold text-text">
                  {t("hafalan.comparingAudio")}
                </Text>
              </View>
            ) : phase === "recording" ? (
              <AnimatedPressable
                accessibilityRole="button"
                accessibilityLabel={t("hafalan.stopAndEvaluate")}
                onPress={() => {
                  if (!item) return;
                  void stopAndCompare({
                    hafalanId: item.id,
                    surahLabel,
                    targetText,
                  });
                }}
                className="min-h-14 flex-row items-center gap-3 rounded-full bg-error px-6 py-3.5"
              >
                <Square size={18} color={BRAND_COLORS.semantic.onError} />
                <Text className="text-sm font-bold text-on-error">
                  {t("hafalan.stopAndEvaluate")}
                </Text>
              </AnimatedPressable>
            ) : (
              <AnimatedPressable
                accessibilityRole="button"
                accessibilityLabel={t("hafalan.startRecording")}
                disabled={isLoading || targetText.length === 0}
                onPress={() => void startRecording()}
                className="min-h-14 flex-row items-center gap-3 rounded-full bg-primary px-6 py-3.5"
              >
                <Mic size={18} color={palette.onPrimary} />
                <Text className="text-sm font-bold text-on-primary">
                  {t("hafalan.startRecording")}
                </Text>
              </AnimatedPressable>
            )}

            {errorMessage ? (
              <Text className="mt-3 text-center text-xs text-error">
                {errorMessage}
              </Text>
            ) : null}
          </View>

          {/* AI Comparison Result */}
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
      </View>
    </Modal>
  );
};
