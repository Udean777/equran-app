import * as Notifications from "expo-notifications";
import { Platform } from "react-native";
import {
  getNotificationRef,
  upsertNotificationRef,
} from "./hafalan-repository";
import { scheduleMurajaahReminder } from "./murajaah-reminder-service";

jest.mock("./hafalan-repository", () => {
  const refs = new Map<
    string,
    {
      id: string;
      hafalan_id: string;
      notification_id: string;
      scheduled_for: number;
    }
  >();
  return {
    getNotificationRef: jest.fn((id: string) => refs.get(id) ?? null),
    upsertNotificationRef: jest.fn(
      (params: {
        hafalanId: string;
        notificationId: string;
        scheduledFor: number;
      }) => {
        refs.set(params.hafalanId, {
          id: `notif-ref-${params.hafalanId}`,
          hafalan_id: params.hafalanId,
          notification_id: params.notificationId,
          scheduled_for: params.scheduledFor,
        });
      },
    ),
    deleteNotificationRef: jest.fn((id: string) => {
      refs.delete(id);
    }),
  };
});

jest.mock("expo-notifications", () => ({
  AndroidImportance: { HIGH: 4 },
  SchedulableTriggerInputTypes: { DATE: "date" },
  getPermissionsAsync: jest.fn(),
  setNotificationChannelAsync: jest.fn(),
  cancelScheduledNotificationAsync: jest.fn(),
  scheduleNotificationAsync: jest.fn(),
}));

const mockedNotifications = jest.mocked(Notifications);

describe("murajaah-reminder-service", () => {
  beforeEach(() => {
    jest.clearAllMocks();
    Platform.OS = "android";
    mockedNotifications.getPermissionsAsync.mockResolvedValue({
      granted: true,
      canAskAgain: true,
      expires: "never",
      status: "granted" as Notifications.PermissionStatus,
    });
    mockedNotifications.setNotificationChannelAsync.mockResolvedValue(null);
    mockedNotifications.cancelScheduledNotificationAsync.mockResolvedValue(
      undefined,
    );
    mockedNotifications.scheduleNotificationAsync.mockResolvedValue(
      "new-notif-id",
    );
  });

  it("cancels prior notification_ref before scheduling a new reminder", async () => {
    upsertNotificationRef({
      hafalanId: "h-1",
      notificationId: "old-notif-id",
      scheduledFor: Date.now() + 10_000,
    });

    const targetDate = new Date(Date.now() + 86_400_000);
    const res = await scheduleMurajaahReminder({
      hafalanId: "h-1",
      scheduledFor: targetDate,
      channelName: "Muraja'ah",
      title: "Time for Muraja'ah",
      body: "Review Al-Fatihah",
    });

    expect(res.ok).toBe(true);
    expect(
      mockedNotifications.cancelScheduledNotificationAsync,
    ).toHaveBeenCalledWith("old-notif-id");
    expect(mockedNotifications.scheduleNotificationAsync).toHaveBeenCalledWith(
      expect.objectContaining({
        content: expect.objectContaining({ sound: true }),
      }),
    );
    expect(getNotificationRef("h-1")?.notification_id).toBe("new-notif-id");
  });
});
