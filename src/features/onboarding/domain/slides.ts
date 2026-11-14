export type OnboardingSlideId =
  "welcome" | "features" | "permissions" | "ready";

export type OnboardingSlideKind = OnboardingSlideId;

export type OnboardingFeatureItem = Readonly<{
  id: "quran" | "prayer" | "hafalan";
  titleKey: string;
  descriptionKey: string;
}>;

export type OnboardingSlide = Readonly<{
  id: OnboardingSlideId;
  kind: OnboardingSlideKind;
  titleKey: string;
  subtitleKey: string;
  descriptionKey: string;
  features: readonly OnboardingFeatureItem[];
}>;

export const ONBOARDING_SLIDES: readonly OnboardingSlide[] = [
  {
    id: "welcome",
    kind: "welcome",
    titleKey: "onboarding.slides.welcome.title",
    subtitleKey: "onboarding.slides.welcome.subtitle",
    descriptionKey: "onboarding.slides.welcome.description",
    features: [],
  },
  {
    id: "features",
    kind: "features",
    titleKey: "onboarding.slides.features.title",
    subtitleKey: "onboarding.slides.features.subtitle",
    descriptionKey: "onboarding.slides.features.description",
    features: [
      {
        id: "quran",
        titleKey: "onboarding.slides.features.quranTitle",
        descriptionKey: "onboarding.slides.features.quranDesc",
      },
      {
        id: "prayer",
        titleKey: "onboarding.slides.features.prayerTitle",
        descriptionKey: "onboarding.slides.features.prayerDesc",
      },
      {
        id: "hafalan",
        titleKey: "onboarding.slides.features.hafalanTitle",
        descriptionKey: "onboarding.slides.features.hafalanDesc",
      },
    ],
  },
  {
    id: "permissions",
    kind: "permissions",
    titleKey: "onboarding.slides.permissions.title",
    subtitleKey: "onboarding.slides.permissions.subtitle",
    descriptionKey: "onboarding.slides.permissions.description",
    features: [],
  },
  {
    id: "ready",
    kind: "ready",
    titleKey: "onboarding.slides.ready.title",
    subtitleKey: "onboarding.slides.ready.subtitle",
    descriptionKey: "onboarding.slides.ready.description",
    features: [],
  },
];

export const PERMISSION_SLIDE_INDEX = 2;

export const clampSlideIndex = (index: number): number => {
  const maxIndex = ONBOARDING_SLIDES.length - 1;
  if (index < 0) return 0;
  if (index > maxIndex) return maxIndex;
  return Math.trunc(index);
};

export const isLastSlide = (index: number): boolean =>
  clampSlideIndex(index) === ONBOARDING_SLIDES.length - 1;

export const isPermissionSlide = (index: number): boolean =>
  clampSlideIndex(index) === PERMISSION_SLIDE_INDEX;

export const canAdvanceFromSlide = (
  index: number,
  permissionRequested: boolean,
): boolean => {
  if (isPermissionSlide(index)) return permissionRequested;
  return true;
};
