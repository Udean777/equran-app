import CompassHeading from "react-native-compass-heading";
import { err, ok, type Result } from "@/lib/result";

export type CompassReading = Readonly<{
  heading: number;
  accuracy: number;
}>;

export const hasCompassSensor = async (): Promise<boolean> => {
  try {
    return await CompassHeading.hasCompass();
  } catch {
    return false;
  }
};

export const startCompassStream = async (
  onReading: (reading: CompassReading) => void,
  degreeUpdateRate = 1,
): Promise<Result<() => void>> => {
  try {
    const supported = await hasCompassSensor();
    if (!supported) {
      return err("notFound", "Device has no magnetometer sensor");
    }

    const started = await CompassHeading.start(degreeUpdateRate, (data) => {
      onReading({
        heading: data.heading,
        accuracy: data.accuracy,
      });
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
