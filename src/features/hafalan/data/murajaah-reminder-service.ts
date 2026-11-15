import {
  AndroidImportance,
  cancelScheduledNotificationAsync,
  getPermissionsAsync,
  SchedulableTriggerInputTypes,
  scheduleNotificationAsync,
  setNotificationChannelAsync,
} from "expo-notifications";
import { Platform } from "react-native";
import {
  deleteNotificationRef,
  getNotificationRef,
  upsertNotificationRef,
} from "@/features/hafalan/data/hafalan-repository";
import { err, ok, type Result } from "@/lib/result";

const MURAJAAH_CHANNEL_ID = "murajaah-reminders";

export type MurajaahReminderInput = Readonly<{
  hafalanId: string;
  scheduledFor: Date;
  channelName: string;
  title: string;
  body: string;
}>;

export const cancelMurajaahReminder = async (
  hafalanId: string,
): Promise<void> => {
  const existing = getNotificationRef(hafalanId);
  if (existing) {
    await cancelScheduledNotificationAsync(existing.notification_id).catch(
      () => undefined,
    );
    deleteNotificationRef(hafalanId);
  }
};

export const scheduleMurajaahReminder = async (
  input: MurajaahReminderInput,
): Promise<Result<string>> => {
  try {
    await cancelMurajaahReminder(input.hafalanId);

    const perm = await getPermissionsAsync();
    if (!perm.granted) {
      return err("permission", "Notification permission not granted");
    }

    if (Platform.OS === "android") {
      await setNotificationChannelAsync(MURAJAAH_CHANNEL_ID, {
        name: input.channelName,
        importance: AndroidImportance.HIGH,
      });
    }

    const notificationId = await scheduleNotificationAsync({
      content: {
        title: input.title,
        body: input.body,
        sound: true,
        data: {
          kind: "murajaah_reminder",
          hafalanId: input.hafalanId,
        },
      },
      trigger: {
        type: SchedulableTriggerInputTypes.DATE,
        date: input.scheduledFor,
        ...(Platform.OS === "android"
          ? { channelId: MURAJAAH_CHANNEL_ID }
          : {}),
      },
    });

    upsertNotificationRef({
      hafalanId: input.hafalanId,
      notificationId,
      scheduledFor: input.scheduledFor.getTime(),
    });

    return ok(notificationId);
  } catch (cause) {
    return err("permission", "Failed to schedule murajaah reminder", cause);
  }
};
