import * as Location from "expo-location";
import { DEFAULT_COORDINATES } from "@/features/prayer/domain/prayer-times";
import { err, ok, type Result } from "@/lib/result";
import { getLastLocation, setLastLocation } from "@/lib/storage/prefs";

export type LocationSource = "gps" | "cached" | "fallback";

export type LocationSnapshot = Readonly<{
  latitude: number;
  longitude: number;
  city?: string;
  source: LocationSource;
  permissionGranted: boolean;
}>;

const formatCityName = (
  place: Location.LocationGeocodedAddress | undefined,
): string | undefined => {
  if (!place) return undefined;
  return (
    place.city ?? place.subregion ?? place.district ?? place.region ?? undefined
  );
};

export const getCachedOrFallbackLocation = (): LocationSnapshot => {
  const cached = getLastLocation();
  if (cached) {
    return {
      latitude: cached.latitude,
      longitude: cached.longitude,
      city: cached.city,
      source: "cached",
      permissionGranted: false,
    };
  }
  return {
    latitude: DEFAULT_COORDINATES.latitude,
    longitude: DEFAULT_COORDINATES.longitude,
    source: "fallback",
    permissionGranted: false,
  };
};

export const resolveDeviceLocation = async (
  requestPermission: boolean,
): Promise<Result<LocationSnapshot>> => {
  try {
    const existing = await Location.getForegroundPermissionsAsync();
    let granted = existing.status === Location.PermissionStatus.GRANTED;

    if (!granted && requestPermission) {
      const requested = await Location.requestForegroundPermissionsAsync();
      granted = requested.status === Location.PermissionStatus.GRANTED;
    }

    if (!granted) {
      return ok(getCachedOrFallbackLocation());
    }

    const position = await Location.getCurrentPositionAsync({
      accuracy: Location.Accuracy.Balanced,
    });
    const { latitude, longitude } = position.coords;

    let city: string | undefined;
    try {
      const places = await Location.reverseGeocodeAsync({
        latitude,
        longitude,
      });
      city = formatCityName(places[0]);
    } catch {
      city = undefined;
    }

    setLastLocation({
      latitude,
      longitude,
      city,
      updatedAt: Date.now(),
    });

    return ok({
      latitude,
      longitude,
      city,
      source: "gps",
      permissionGranted: true,
    });
  } catch (cause) {
    return err("permission", "Failed to read device location", cause);
  }
};
