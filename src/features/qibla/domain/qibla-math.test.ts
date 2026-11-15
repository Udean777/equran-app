import {
  computeQiblaBearing,
  computeQiblaOffset,
  declinationFromHeadings,
  isAlignedToQibla,
  nextAlignedState,
  signedTurnDeg,
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
    // Unwrapped on purpose: 360 means "same as 0" without the 359-degree spin.
    expect(smoothed).toBeCloseTo(360, 5);
    expect(smoothed % 360).toBeCloseTo(0, 5);
  });

  it("keeps smoothing continuous when crossing north repeatedly", () => {
    let heading = 350;
    heading = smoothHeadingEma(heading, 2, 1);
    heading = smoothHeadingEma(heading, 4, 1);
    heading = smoothHeadingEma(heading, 6, 1);

    expect(heading).toBeCloseTo(366, 5);
  });

  it("detects alignment within tolerance", () => {
    expect(isAlignedToQibla(computeQiblaOffset(293, 295), 5)).toBe(true);
    expect(isAlignedToQibla(computeQiblaOffset(200, 295), 5)).toBe(false);
    expect(isAlignedToQibla(357, 5)).toBe(true);
  });

  it("holds the aligned state inside the leave tolerance and drops it outside", () => {
    expect(nextAlignedState(false, 4)).toBe(true);
    expect(nextAlignedState(false, 6)).toBe(false);
    expect(nextAlignedState(true, 6)).toBe(true);
    expect(nextAlignedState(true, 9)).toBe(false);
  });

  it("signs the turn direction around the origin", () => {
    expect(signedTurnDeg(10)).toBeCloseTo(10, 5);
    expect(signedTurnDeg(350)).toBeCloseTo(-10, 5);
    expect(signedTurnDeg(180)).toBeCloseTo(-180, 5);
  });

  it("treats an unavailable true heading as zero declination", () => {
    expect(declinationFromHeadings(-1, 200)).toBe(0);
    expect(declinationFromHeadings(12, 10)).toBeCloseTo(2, 5);
    expect(declinationFromHeadings(358, 10)).toBeCloseTo(-12, 5);
  });
});
