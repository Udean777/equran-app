import { useEffect, useMemo, useState } from "react";
import { useSharedValue, type SharedValue } from "react-native-reanimated";
import {
  readMagneticDeclination,
  startCompassStream,
} from "@/features/qibla/data/compass-sensor";
import {
  computeQiblaBearing,
  computeQiblaOffset,
  nextAlignedState,
  smoothHeadingEma,
} from "@/features/qibla/domain/qibla-math";

const STATE_UPDATE_INTERVAL_MS = 200;

export type CompassStatus = "initializing" | "active" | "unsupported";

export type UseQiblaCompassResult = Readonly<{
  status: CompassStatus;
  headingDeg: number;
  qiblaBearingDeg: number;
  offsetDeg: number;
  isAligned: boolean;
  /** Continuous angles in degrees; negative = counter-clockwise. UI-thread only. */
  dialRotation: SharedValue<number>;
  needleRotation: SharedValue<number>;
}>;

export const useQiblaCompass = (
  latitude: number,
  longitude: number,
): UseQiblaCompassResult => {
  const [status, setStatus] = useState<CompassStatus>("initializing");
  const [snapshot, setSnapshot] = useState({
    headingDeg: 0,
    offsetDeg: 0,
    isAligned: false,
  });

  const dialRotation = useSharedValue(0);
  const needleRotation = useSharedValue(0);

  const qiblaBearingDeg = useMemo(
    () => computeQiblaBearing(latitude, longitude),
    [latitude, longitude],
  );

  useEffect(() => {
    let active = true;
    let stopStream: (() => void) | null = null;
    let smoothed: number | null = null;
    let aligned = false;
    let lastUpdate = 0;

    const run = async () => {
      const declination = await readMagneticDeclination();
      if (!active) return;

      const res = await startCompassStream((reading) => {
        if (!active) return;

        smoothed = smoothHeadingEma(smoothed, reading.heading + declination);
        dialRotation.value = -smoothed;
        needleRotation.value = qiblaBearingDeg - smoothed;

        const offsetDeg = computeQiblaOffset(smoothed, qiblaBearingDeg);
        const now = Date.now();
        const nextAligned = nextAlignedState(aligned, offsetDeg);

        // Only touch React state when it changes what is rendered, and at most 5x/s.
        if (
          nextAligned === aligned &&
          now - lastUpdate < STATE_UPDATE_INTERVAL_MS
        ) {
          return;
        }
        aligned = nextAligned;
        lastUpdate = now;
        setSnapshot({
          headingDeg: ((smoothed % 360) + 360) % 360,
          offsetDeg,
          isAligned: aligned,
        });
        setStatus("active");
      });

      if (!active) {
        if (res.ok) res.value();
        return;
      }
      if (res.ok) {
        stopStream = res.value;
        setStatus("active");
      } else {
        setStatus("unsupported");
      }
    };

    void run();

    return () => {
      active = false;
      stopStream?.();
    };
  }, [dialRotation, needleRotation, qiblaBearingDeg]);

  return {
    status,
    headingDeg: snapshot.headingDeg,
    qiblaBearingDeg,
    offsetDeg: snapshot.offsetDeg,
    isAligned: status === "active" && snapshot.isAligned,
    dialRotation,
    needleRotation,
  };
};
