import * as Location from "expo-location";
import CompassHeading from "react-native-compass-heading";
import { declinationFromHeadings } from "@/features/qibla/domain/qibla-math";
import { err, ok, type Result } from "@/lib/result";

const DEGREE_UPDATE_RATE = 2;
const DECLINATION_TIMEOUT_MS = 1500;

export type CompassReading = Readonly<{
  heading: number;
}>;

/**
 * Magnetic declination in degrees, read once per compass session.
 *
 * `expo-location` needs a location fix to resolve true north: without permission
 * Android never emits and iOS throws, so both end at 0 ("treat as true north").
 * The subscription is removed explicitly because `getHeadingAsync` would leak it
 * when its promise never settles.
 */
export const readMagneticDeclination = (): Promise<number> =>
  new Promise((resolve) => {
    let settled = false;
    let subscription: Location.LocationSubscription | undefined;
    let timer: ReturnType<typeof setTimeout> | undefined;

    const finish = (value: number) => {
      if (settled) return;
      settled = true;
      if (timer) clearTimeout(timer);
      subscription?.remove();
      resolve(value);
    };

    timer = setTimeout(() => finish(0), DECLINATION_TIMEOUT_MS);

    Location.watchHeadingAsync((heading) => {
      if (heading.trueHeading < 0) return;
      finish(declinationFromHeadings(heading.trueHeading, heading.magHeading));
    }).then(
      (sub) => {
        subscription = sub;
        if (settled) sub.remove();
      },
      () => finish(0),
    );
  });

export const hasCompassSensor = async (): Promise<boolean> => {
  try {
    return await CompassHeading.hasCompass();
  } catch {
    return false;
  }
};

export const startCompassStream = async (
  onReading: (reading: CompassReading) => void,
): Promise<Result<() => void>> => {
  try {
    const supported = await hasCompassSensor();
    if (!supported) {
      return err("notFound", "Device has no magnetometer sensor");
    }

    const started = await CompassHeading.start(DEGREE_UPDATE_RATE, (data) => {
      onReading({ heading: data.heading });
    });

    if (!started) {
      return err("permission", "Failed to start compass heading updates");
    }

    return ok(() => {
      void CompassHeading.stop().catch(() => undefined);
    });
  } catch (cause) {
    return err("permission", "Compass sensor error", cause);
  }
};
