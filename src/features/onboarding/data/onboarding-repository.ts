import { requestForegroundPermissionsAsync } from "expo-location";
import {
  IosAuthorizationStatus,
  requestPermissionsAsync,
} from "expo-notifications";

import { err, ok, type Result } from "@/lib/result";
import { getOnboardingDone, setOnboardingDone } from "@/lib/storage/prefs";

export type OnboardingPermissions = Readonly<{
  locationGranted: boolean;
  notificationGranted: boolean;
}>;

export const readOnboardingCompleted = (): boolean => getOnboardingDone();

export const markOnboardingCompleted = (): void => {
  setOnboardingDone(true);
};

export const requestOnboardingPermissions = async (): Promise<
  Result<OnboardingPermissions>
> => {
  try {
    const locationStatus = await requestForegroundPermissionsAsync();
    const notificationStatus = await requestPermissionsAsync();
    const notificationGranted =
      notificationStatus.granted ||
      notificationStatus.ios?.status === IosAuthorizationStatus.PROVISIONAL;

    return ok({
      locationGranted: locationStatus.granted,
      notificationGranted,
    });
  } catch (cause) {
    return err("permission", "Failed to request onboarding permissions", cause);
  }
};
