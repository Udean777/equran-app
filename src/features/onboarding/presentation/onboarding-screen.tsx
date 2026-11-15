import { useRouter } from "expo-router";
import { useState } from "react";
import { useTranslation } from "react-i18next";
import { Text, View } from "react-native";

import { AnimatedPressable } from "@/components/animated-pressable";
import { Screen } from "@/components/screen";

import { OnboardingFooter } from "./onboarding-footer";
import { OnboardingSlideCard } from "./onboarding-slide-card";
import { useOnboarding } from "./use-onboarding";

export const OnboardingScreen = () => {
  const router = useRouter();
  const { t } = useTranslation();
  const {
    currentIndex,
    totalSlides,
    slide,
    permissionRequested,
    isRequesting,
    permissions,
    canAdvance,
    isLast,
    next,
    prev,
    skip,
    requestPermissions,
  } = useOnboarding();

  const [direction, setDirection] = useState<1 | -1>(1);

  const navigateHome = () => {
    router.replace("/(tabs)");
  };

  if (!slide) return null;

  return (
    <Screen className="bg-onboarding-bg">
      <View className="flex-1 justify-between">
        <View className="flex-row items-center justify-between px-6 pb-2 pt-3">
          <View className="rounded-full border border-gold/35 bg-onboarding-surface px-3 py-1">
            <Text className="text-xs font-semibold text-onboarding-muted">
              {t("onboarding.stepLabel", {
                current: currentIndex + 1,
                total: totalSlides,
              })}
            </Text>
          </View>

          {!isLast ? (
            <AnimatedPressable
              accessibilityRole="button"
              accessibilityLabel={t("onboarding.actions.skip")}
              onPress={() => skip(navigateHome)}
              className="min-h-11 min-w-11 items-end justify-center px-2"
            >
              <Text className="text-sm font-semibold text-onboarding-muted">
                {t("onboarding.actions.skip")}
              </Text>
            </AnimatedPressable>
          ) : (
            <View className="min-h-11" />
          )}
        </View>

        <OnboardingSlideCard
          slide={slide}
          direction={direction}
          permissions={permissions}
          permissionRequested={permissionRequested}
          isRequesting={isRequesting}
          onRequestPermissions={() => {
            void requestPermissions();
          }}
        />

        <OnboardingFooter
          currentIndex={currentIndex}
          totalSlides={totalSlides}
          canAdvance={canAdvance}
          isLast={isLast}
          onPrev={() => {
            setDirection(-1);
            prev();
          }}
          onNext={() => {
            setDirection(1);
            next(navigateHome);
          }}
          onSkip={() => skip(navigateHome)}
        />
      </View>
    </Screen>
  );
};
