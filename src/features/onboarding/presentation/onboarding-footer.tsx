import { useEffect } from "react";
import { useTranslation } from "react-i18next";
import { Text, View } from "react-native";
import Animated, {
  useAnimatedStyle,
  useReducedMotion,
  useSharedValue,
  withTiming,
} from "react-native-reanimated";

import { AnimatedPressable } from "@/components/animated-pressable";
import { BRAND_COLORS } from "@/theme/palette";

type DotProps = Readonly<{
  active: boolean;
}>;

const PaginationDot = ({ active }: DotProps) => {
  const reducedMotion = useReducedMotion();
  const width = useSharedValue(active ? 24 : 8);
  const opacity = useSharedValue(active ? 1 : 0.45);

  useEffect(() => {
    const targetWidth = active ? 24 : 8;
    const targetOpacity = active ? 1 : 0.45;
    if (reducedMotion) {
      width.set(targetWidth);
      opacity.set(targetOpacity);
      return;
    }
    width.set(withTiming(targetWidth, { duration: 220 }));
    opacity.set(withTiming(targetOpacity, { duration: 220 }));
  }, [active, opacity, reducedMotion, width]);

  const animatedStyle = useAnimatedStyle(() => ({
    width: width.value,
    opacity: opacity.value,
    backgroundColor: BRAND_COLORS.gold.DEFAULT,
  }));

  return <Animated.View className="h-2 rounded-full" style={animatedStyle} />;
};

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
    <View className="gap-4 border-t border-gold/15 px-6 pb-6 pt-4">
      <View className="flex-row items-center justify-center gap-2">
        {Array.from({ length: totalSlides }, (_, index) => (
          <PaginationDot key={index} active={index === currentIndex} />
        ))}
      </View>

      <View className="flex-row items-center gap-3">
        {currentIndex > 0 ? (
          <AnimatedPressable
            containerClassName="flex-1"
            accessibilityRole="button"
            accessibilityLabel={t("onboarding.actions.back")}
            onPress={onPrev}
            className="min-h-12 min-w-11 items-center justify-center rounded-2xl border border-gold/40 bg-onboarding-surface px-5 py-3"
          >
            <Text className="text-sm font-semibold text-onboarding-text">
              {t("onboarding.actions.back")}
            </Text>
          </AnimatedPressable>
        ) : null}

        {canAdvance ? (
          <AnimatedPressable
            containerClassName="flex-1"
            accessibilityRole="button"
            accessibilityLabel={primaryLabel}
            onPress={onNext}
            className="min-h-12 min-w-11 items-center justify-center rounded-2xl bg-gold px-5 py-3"
          >
            <Text className="text-sm font-bold text-on-gold">
              {primaryLabel}
            </Text>
          </AnimatedPressable>
        ) : (
          <AnimatedPressable
            containerClassName="flex-1"
            accessibilityRole="button"
            accessibilityLabel={t("onboarding.actions.skip")}
            onPress={onSkip}
            className="min-h-12 min-w-11 items-center justify-center rounded-2xl border border-gold/40 bg-onboarding-surface px-5 py-3"
          >
            <Text className="text-sm font-semibold text-onboarding-text">
              {t("onboarding.actions.skip")}
            </Text>
          </AnimatedPressable>
        )}
      </View>
    </View>
  );
};
