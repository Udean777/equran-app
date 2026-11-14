import { useEffect, useRef, useState } from "react";
import { startCompassStream } from "@/features/qibla/data/compass-sensor";
import {
  computeQiblaBearing,
  computeQiblaOffset,
  isAlignedToQibla,
  smoothHeadingEma,
} from "@/features/qibla/domain/qibla-math";

export type CompassStatus = "initializing" | "active" | "unsupported";

export type UseQiblaCompassResult = Readonly<{
  status: CompassStatus;
  headingDeg: number;
  qiblaBearingDeg: number;
  offsetDeg: number;
  isAligned: boolean;
}>;

export const useQiblaCompass = (
  latitude: number,
  longitude: number,
): UseQiblaCompassResult => {
  const [status, setStatus] = useState<CompassStatus>("initializing");
  const [headingDeg, setHeadingDeg] = useState<number>(0);
  const smoothedRef = useRef<number | null>(null);

  useEffect(() => {
    let active = true;
    let stopStream: (() => void) | null = null;

    void startCompassStream((reading) => {
      if (!active) return;
      const next = smoothHeadingEma(smoothedRef.current, reading.heading);
      smoothedRef.current = next;
      setHeadingDeg(next);
      setStatus("active");
    }).then((res) => {
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
    });

    return () => {
      active = false;
      stopStream?.();
    };
  }, []);

  const qiblaBearingDeg = computeQiblaBearing(latitude, longitude);
  const offsetDeg = computeQiblaOffset(headingDeg, qiblaBearingDeg);
  const isAligned = status === "active" && isAlignedToQibla(offsetDeg);

  return { status, headingDeg, qiblaBearingDeg, offsetDeg, isAligned };
};
