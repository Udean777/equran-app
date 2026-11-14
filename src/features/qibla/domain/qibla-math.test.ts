import {
  computeQiblaBearing,
  computeQiblaOffset,
  isAlignedToQibla,
  smoothHeadingEma,
} from "./qibla-math";

describe("qibla-math domain", () => {
  it("computes Jakarta qibla bearing around 295 degrees", () => {
    const bearing = computeQiblaBearing(-6.2088, 106.8456);
    expect(bearing).toBeGreaterThan(294);
    expect(bearing).toBeLessThan(296);
  });

  it("smooths heading across 355 -> 5 wrap-around via shortest arc", () => {
    const smoothed = smoothHeadingEma(355, 5, 0.5);
    expect(smoothed).toBeCloseTo(0, 5);
  });

  it("detects alignment within tolerance", () => {
    expect(isAlignedToQibla(computeQiblaOffset(293, 295), 5)).toBe(true);
    expect(isAlignedToQibla(computeQiblaOffset(200, 295), 5)).toBe(false);
    expect(isAlignedToQibla(357, 5)).toBe(true);
  });
});
