import { Coordinates, Qibla } from "adhan";

const normalizeAngle = (deg: number): number => ((deg % 360) + 360) % 360;

/** Shortest signed rotation from `from` to `to`, in (-180, 180]. */
const shortestDelta = (from: number, to: number): number =>
  ((normalizeAngle(to) - normalizeAngle(from) + 540) % 360) - 180;

export const computeQiblaBearing = (
  latitude: number,
  longitude: number,
): number => normalizeAngle(Qibla(new Coordinates(latitude, longitude)));

/**
 * Keeps the smoothed heading continuous instead of wrapping at 360, so a rotation
 * never takes the long way round. Input may be an already unwrapped value.
 */
export const smoothHeadingEma = (
  previousDeg: number | null,
  nextDeg: number,
  alpha = 0.2,
): number => {
  if (previousDeg === null) return normalizeAngle(nextDeg);
  return previousDeg + alpha * shortestDelta(previousDeg, nextDeg);
};

export const computeQiblaOffset = (
  headingDeg: number,
  qiblaBearingDeg: number,
): number => normalizeAngle(qiblaBearingDeg - headingDeg);

export const isAlignedToQibla = (
  offsetDeg: number,
  toleranceDeg = 5,
): boolean => {
  const normalized = normalizeAngle(offsetDeg);
  const distanceFromZero = Math.min(normalized, 360 - normalized);
  return distanceFromZero <= toleranceDeg;
};

const ALIGNED_ENTER_DEG = 5;
const ALIGNED_LEAVE_DEG = 8;

/** Wider tolerance to leave than to enter, so the "aligned" badge does not flicker. */
export const nextAlignedState = (
  wasAligned: boolean,
  offsetDeg: number,
): boolean =>
  isAlignedToQibla(
    offsetDeg,
    wasAligned ? ALIGNED_LEAVE_DEG : ALIGNED_ENTER_DEG,
  );

/** Positive = turn right (clockwise), negative = turn left. */
export const signedTurnDeg = (offsetDeg: number): number =>
  shortestDelta(0, offsetDeg);

/**
 * Compass libraries report magnetic north, `adhan` returns a true-north bearing.
 * Returns the declination to add to a magnetic heading, or 0 when `expo-location`
 * could not resolve true north (it reports -1 without a usable location fix).
 */
export const declinationFromHeadings = (
  trueHeadingDeg: number,
  magneticHeadingDeg: number,
): number =>
  trueHeadingDeg < 0 ? 0 : shortestDelta(magneticHeadingDeg, trueHeadingDeg);
