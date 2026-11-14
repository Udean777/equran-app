export type OnboardingSlideId =
  "welcome" | "permissions" | "quran" | "prayer" | "hafalan" | "ready";

export type OnboardingSlideKind =
  "welcome" | "permissions" | "feature" | "ready";

export type OnboardingSlide = Readonly<{
  id: OnboardingSlideId;
  kind: OnboardingSlideKind;
  titleKey: string;
  subtitleKey: string;
  descriptionKey: string;
  pointKeys: readonly string[];
}>;

export const ONBOARDING_SLIDES: readonly OnboardingSlide[] = [
  {
    id: "welcome",
    kind: "welcome",
    titleKey: "onboarding.slides.welcome.title",
    subtitleKey: "onboarding.slides.welcome.subtitle",
    descriptionKey: "onboarding.slides.welcome.description",
    pointKeys: [],
  },
  {
    id: "permissions",
    kind: "permissions",
    titleKey: "onboarding.slides.permissions.title",
    subtitleKey: "onboarding.slides.permissions.subtitle",
    descriptionKey: "onboarding.slides.permissions.description",
    pointKeys: [],
  },
  {
    id: "quran",
    kind: "feature",
    titleKey: "onboarding.slides.quran.title",
    subtitleKey: "onboarding.slides.quran.subtitle",
    descriptionKey: "onboarding.slides.quran.description",
    pointKeys: [
      "onboarding.slides.quran.point1",
      "onboarding.slides.quran.point2",
      "onboarding.slides.quran.point3",
    ],
  },
  {
    id: "prayer",
    kind: "feature",
    titleKey: "onboarding.slides.prayer.title",
    subtitleKey: "onboarding.slides.prayer.subtitle",
    descriptionKey: "onboarding.slides.prayer.description",
    pointKeys: [
      "onboarding.slides.prayer.point1",
      "onboarding.slides.prayer.point2",
      "onboarding.slides.prayer.point3",
    ],
  },
  {
    id: "hafalan",
    kind: "feature",
    titleKey: "onboarding.slides.hafalan.title",
    subtitleKey: "onboarding.slides.hafalan.subtitle",
    descriptionKey: "onboarding.slides.hafalan.description",
    pointKeys: [
      "onboarding.slides.hafalan.point1",
      "onboarding.slides.hafalan.point2",
      "onboarding.slides.hafalan.point3",
    ],
  },
  {
    id: "ready",
    kind: "ready",
    titleKey: "onboarding.slides.ready.title",
    subtitleKey: "onboarding.slides.ready.subtitle",
    descriptionKey: "onboarding.slides.ready.description",
    pointKeys: [],
  },
];

export const PERMISSION_SLIDE_INDEX = 1;

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
