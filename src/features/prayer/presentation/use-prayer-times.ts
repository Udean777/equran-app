import { useEffect, useState } from "react";
import {
  getCachedOrFallbackLocation,
  resolveDeviceLocation,
  type LocationSnapshot,
} from "@/features/prayer/data/location-service";
import {
  computeDailyPrayerTimes,
  type DailyPrayerSchedule,
} from "@/features/prayer/domain/prayer-times";

export type UsePrayerTimesResult = Readonly<{
  location: LocationSnapshot;
  schedule: DailyPrayerSchedule;
  isLocating: boolean;
  refreshLocation: () => Promise<void>;
}>;

export const usePrayerTimes = (): UsePrayerTimesResult => {
  const [location, setLocation] = useState<LocationSnapshot>(() =>
    getCachedOrFallbackLocation(),
  );
  const [now, setNow] = useState<Date>(() => new Date());
  const [isLocating, setIsLocating] = useState(false);

  useEffect(() => {
    let active = true;
    void resolveDeviceLocation(false).then((res) => {
      if (active && res.ok) {
        setLocation(res.value);
      }
    });
    return () => {
      active = false;
    };
  }, []);

  useEffect(() => {
    const timer = setInterval(() => {
      setNow(new Date());
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  const refreshLocation = async (): Promise<void> => {
    setIsLocating(true);
    try {
      const res = await resolveDeviceLocation(true);
      if (res.ok) {
        setLocation(res.value);
      }
    } finally {
      setIsLocating(false);
    }
  };

  const schedule = computeDailyPrayerTimes(
    { latitude: location.latitude, longitude: location.longitude },
    now,
    "kemenag",
  );

  return { location, schedule, isLocating, refreshLocation };
};
