import { useState } from "react";

import {
  type OnboardingPermissions,
  requestOnboardingPermissions,
} from "../data/onboarding-repository";
import {
  canAdvanceFromSlide,
  clampSlideIndex,
  isLastSlide,
  ONBOARDING_SLIDES,
} from "../domain/slides";
import { useOnboardingStore } from "./use-onboarding-store";

export const useOnboarding = () => {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [permissionRequested, setPermissionRequested] = useState(false);
  const [isRequesting, setIsRequesting] = useState(false);
  const [permissions, setPermissions] = useState<OnboardingPermissions>({
    locationGranted: false,
    notificationGranted: false,
  });
  const complete = useOnboardingStore((state) => state.complete);

  const slide = ONBOARDING_SLIDES[currentIndex] ?? ONBOARDING_SLIDES[0];

  const next = (onDone: () => void) => {
    if (!canAdvanceFromSlide(currentIndex, permissionRequested)) return;
    if (isLastSlide(currentIndex)) {
      complete();
      onDone();
      return;
    }
    setCurrentIndex((prevIndex) => clampSlideIndex(prevIndex + 1));
  };

  const prev = () => {
    setCurrentIndex((prevIndex) => clampSlideIndex(prevIndex - 1));
  };

  const skip = (onDone: () => void) => {
    complete();
    onDone();
  };

  const requestPermissions = async () => {
    if (isRequesting) return;
    setIsRequesting(true);
    const result = await requestOnboardingPermissions();
    if (result.ok) {
      setPermissions(result.value);
    }
    setPermissionRequested(true);
    setIsRequesting(false);
  };

  return {
    currentIndex,
    totalSlides: ONBOARDING_SLIDES.length,
    slide,
    permissionRequested,
    isRequesting,
    permissions,
    canAdvance: canAdvanceFromSlide(currentIndex, permissionRequested),
    isLast: isLastSlide(currentIndex),
    next,
    prev,
    skip,
    requestPermissions,
  };
};
