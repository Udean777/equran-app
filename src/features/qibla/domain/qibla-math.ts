import { Coordinates, Qibla } from "adhan";

const normalizeAngle = (deg: number): number => ((deg % 360) + 360) % 360;

export const computeQiblaBearing = (
  latitude: number,
  longitude: number,
): number => normalizeAngle(Qibla(new Coordinates(latitude, longitude)));

export const smoothHeadingEma = (
  previousDeg: number | null,
  nextDeg: number,
  alpha = 0.2,
): number => {
  const normalizedNext = normalizeAngle(nextDeg);
  if (previousDeg === null) return normalizedNext;

  const normalizedPrev = normalizeAngle(previousDeg);
  const shortestDelta = ((normalizedNext - normalizedPrev + 540) % 360) - 180;
  return normalizeAngle(normalizedPrev + alpha * shortestDelta);
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
