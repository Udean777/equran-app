import { useRouter } from "expo-router";
import { useState } from "react";
import { View } from "react-native";

import { Screen } from "@/components/screen";

import { OnboardingFooter } from "./onboarding-footer";
import { OnboardingSlideCard } from "./onboarding-slide-card";
import { useOnboarding } from "./use-onboarding";

export const OnboardingScreen = () => {
  const router = useRouter();
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
