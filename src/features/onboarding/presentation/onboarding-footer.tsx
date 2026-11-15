import { useEffect } from "react";
import { useTranslation } from "react-i18next";
import { View } from "react-native";
import Animated, {
  useAnimatedStyle,
  useReducedMotion,
  useSharedValue,
  withTiming,
} from "react-native-reanimated";

import { Button } from "@/components/button";
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
          <Button
            containerClassName="flex-1"
            variant="outline"
            size="lg"
            shape="rounded"
            label={t("onboarding.actions.back")}
            onPress={onPrev}
          />
        ) : null}

        {canAdvance ? (
          <Button
            containerClassName="flex-1"
            variant="gold"
            size="lg"
            shape="rounded"
            label={primaryLabel}
            onPress={onNext}
          />
        ) : (
          <Button
            containerClassName="flex-1"
            variant="outline"
            size="lg"
            shape="rounded"
            label={t("onboarding.actions.skip")}
            onPress={onSkip}
          />
        )}
      </View>
    </View>
  );
};
