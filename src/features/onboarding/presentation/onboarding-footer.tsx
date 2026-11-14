import { useTranslation } from "react-i18next";
import { Pressable, Text, View } from "react-native";

import { cn } from "@/lib/cn";

type Props = Readonly<{
  currentIndex: number;
  totalSlides: number;
  canAdvance: boolean;
  isLast: boolean;
  onPrev: () => void;
  onNext: () => void;
  onSkip: () => void;
}>;

export const OnboardingFooter = ({
  currentIndex,
  totalSlides,
  canAdvance,
  isLast,
  onPrev,
  onNext,
  onSkip,
}: Props) => {
  const { t } = useTranslation();
  const primaryLabel = isLast
    ? t("onboarding.actions.start")
    : t("onboarding.actions.next");

  return (
    <View className="gap-5 px-6 pb-6 pt-3">
      <View className="flex-row items-center justify-center gap-2">
        {Array.from({ length: totalSlides }, (_, index) => (
          <View
            key={index}
            className={cn(
              "h-2 rounded-full",
              index === currentIndex ? "w-6 bg-gold" : "w-2 bg-gold/30",
            )}
          />
        ))}
      </View>

      <View className="flex-row items-center gap-3">
        {currentIndex > 0 ? (
          <Pressable
            accessibilityRole="button"
            accessibilityLabel={t("onboarding.actions.back")}
            onPress={onPrev}
            className="min-h-11 min-w-11 flex-1 items-center justify-center rounded-full border border-gold/30 bg-onboarding-surface px-5 py-3"
          >
            <Text className="text-sm font-semibold text-onboarding-text">
              {t("onboarding.actions.back")}
            </Text>
          </Pressable>
        ) : null}

        {canAdvance ? (
          <Pressable
            accessibilityRole="button"
            accessibilityLabel={primaryLabel}
            onPress={onNext}
            className="min-h-11 min-w-11 flex-1 items-center justify-center rounded-full bg-gold px-5 py-3"
          >
            <Text className="text-sm font-bold text-on-gold">
              {primaryLabel}
            </Text>
          </Pressable>
        ) : (
          <Pressable
            accessibilityRole="button"
            accessibilityLabel={t("onboarding.actions.skip")}
            onPress={onSkip}
            className="min-h-11 min-w-11 flex-1 items-center justify-center rounded-full border border-gold/30 bg-onboarding-surface px-5 py-3"
          >
            <Text className="text-sm font-semibold text-onboarding-muted">
              {t("onboarding.actions.skip")}
            </Text>
          </Pressable>
        )}
      </View>
    </View>
  );
};
