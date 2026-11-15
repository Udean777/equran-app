import {
  AndroidImportance,
  cancelScheduledNotificationAsync,
  type DateTriggerInput,
  getExactAlarmPermissionsAsync,
  getPermissionsAsync,
  requestExactAlarmPermissionsAsync,
  requestPermissionsAsync,
  SchedulableTriggerInputTypes,
  scheduleNotificationAsync,
  setNotificationChannelAsync,
} from "expo-notifications";
import { Platform } from "react-native";
import {
  buildAlarmScheduleEntries,
  type FardhPrayerName,
  type GeoCoordinates,
  type PrayerCalculationMethodId,
} from "@/features/prayer/domain/prayer-times";
import { err, ok, type Result } from "@/lib/result";
import {
  getPrayerNotificationIds,
  setPrayerNotificationIds,
} from "@/lib/storage/prefs";

const PRAYER_CHANNEL_ID = "prayer-alarms";

export type PrayerAlarmSyncResult = Readonly<{
  scheduledCount: number;
  exactAlarmGranted: boolean;
}>;

export type PrayerAlarmCopy = Readonly<{
  channelName: string;
  titleForPrayer: (prayer: FardhPrayerName) => string;
  bodyForPrayer: (prayer: FardhPrayerName) => string;
}>;

const ensureNotificationChannel = async (
  channelName: string,
): Promise<void> => {
  if (Platform.OS !== "android") return;
  await setNotificationChannelAsync(PRAYER_CHANNEL_ID, {
    name: channelName,
    importance: AndroidImportance.MAX,
    vibrationPattern: [0, 300, 150, 300],
  });
};

export const checkExactAlarmPermission = async (): Promise<boolean> => {
  if (Platform.OS !== "android") return true;
  try {
    const perm = await getExactAlarmPermissionsAsync();
    return perm.granted;
  } catch {
    return false;
  }
};

export const requestExactAlarmPermission = async (): Promise<boolean> => {
  if (Platform.OS !== "android") return true;
  try {
    const perm = await requestExactAlarmPermissionsAsync();
    return perm.granted;
  } catch {
    return false;
  }
};

export const cancelAllPrayerAlarms = async (): Promise<Result<void>> => {
  try {
    const existingIds = getPrayerNotificationIds();
    await Promise.all(
      existingIds.map((id) =>
        cancelScheduledNotificationAsync(id).catch(() => undefined),
      ),
    );
    setPrayerNotificationIds([]);
    return ok(undefined);
  } catch (cause) {
    return err("permission", "Failed to cancel prayer alarms", cause);
  }
};

export const schedulePrayerAlarms = async (
  coords: GeoCoordinates,
  copy: PrayerAlarmCopy,
  options?: Readonly<{
    now?: Date;
    method?: PrayerCalculationMethodId;
    requestPermission?: boolean;
  }>,
): Promise<Result<PrayerAlarmSyncResult>> => {
  try {
    const existingPerm = await getPermissionsAsync();
    let granted = existingPerm.granted;

    if (!granted && options?.requestPermission) {
      const requested = await requestPermissionsAsync();
      granted = requested.granted;
    }

    if (!granted) {
      return err("permission", "Notification permission not granted");
    }

    await ensureNotificationChannel(copy.channelName);

    let exactAlarmGranted = await checkExactAlarmPermission();
    if (!exactAlarmGranted && options?.requestPermission) {
      exactAlarmGranted = await requestExactAlarmPermission();
    }

    const cancelRes = await cancelAllPrayerAlarms();
    if (!cancelRes.ok) {
      return cancelRes;
    }

    const entries = buildAlarmScheduleEntries(
      coords,
      options?.now,
      options?.method,
    );

    const scheduledIds: string[] = [];
    for (const entry of entries) {
      const trigger: DateTriggerInput = {
        type: SchedulableTriggerInputTypes.DATE,
        date: entry.triggerAt,
        ...(Platform.OS === "android"
          ? {
              channelId: PRAYER_CHANNEL_ID,
              delivery: "alarmClock",
            }
          : {}),
      };

      const id = await scheduleNotificationAsync({
        content: {
          title: copy.titleForPrayer(entry.prayer),
          body: copy.bodyForPrayer(entry.prayer),
          sound: true,
          data: {
            kind: "prayer_alarm",
            prayer: entry.prayer,
          },
        },
        trigger,
      });
      scheduledIds.push(id);
    }

    setPrayerNotificationIds(scheduledIds);

    return ok({
      scheduledCount: scheduledIds.length,
      exactAlarmGranted,
    });
  } catch (cause) {
    return err("permission", "Failed to schedule prayer alarms", cause);
  }
};
