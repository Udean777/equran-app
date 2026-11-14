import {
  canAdvanceFromSlide,
  clampSlideIndex,
  isLastSlide,
  isPermissionSlide,
  ONBOARDING_SLIDES,
  PERMISSION_SLIDE_INDEX,
} from "./slides";

describe("onboarding slides", () => {
  it("defines 6 slides in the expected order", () => {
    expect(ONBOARDING_SLIDES.map((s) => s.id)).toEqual([
      "welcome",
      "permissions",
      "quran",
      "prayer",
      "hafalan",
      "ready",
    ]);
  });

  it("clamps indices within 0..5", () => {
    expect(clampSlideIndex(-3)).toBe(0);
    expect(clampSlideIndex(0)).toBe(0);
    expect(clampSlideIndex(2.8)).toBe(2);
    expect(clampSlideIndex(99)).toBe(5);
  });

  it("detects the permission slide and last slide", () => {
    expect(isPermissionSlide(PERMISSION_SLIDE_INDEX)).toBe(true);
    expect(isPermissionSlide(0)).toBe(false);
    expect(isLastSlide(5)).toBe(true);
    expect(isLastSlide(4)).toBe(false);
  });

  it("blocks advancing past the permission slide until permissions are requested", () => {
    expect(canAdvanceFromSlide(0, false)).toBe(true);
    expect(canAdvanceFromSlide(PERMISSION_SLIDE_INDEX, false)).toBe(false);
    expect(canAdvanceFromSlide(PERMISSION_SLIDE_INDEX, true)).toBe(true);
    expect(canAdvanceFromSlide(2, false)).toBe(true);
  });
});
