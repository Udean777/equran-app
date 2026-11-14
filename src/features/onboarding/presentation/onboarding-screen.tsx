import { useRouter } from "expo-router";
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

  const navigateHome = () => {
    router.replace("/(tabs)");
  };

  if (!slide) return null;

  return (
    <Screen>
      <View className="flex-1 justify-between">
        <OnboardingSlideCard
          slide={slide}
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
          onPrev={prev}
          onNext={() => next(navigateHome)}
          onSkip={() => skip(navigateHome)}
        />
      </View>
    </Screen>
  );
};
