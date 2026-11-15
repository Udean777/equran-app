import * as Notifications from "expo-notifications";
import { Platform } from "react-native";
import {
  cancelAllPrayerAlarms,
  schedulePrayerAlarms,
} from "./prayer-alarm-service";
import {
  clearAllPrefs,
  getPrayerNotificationIds,
  setPrayerNotificationIds,
} from "@/lib/storage/prefs";

jest.mock("expo-notifications", () => ({
  PermissionStatus: {
    GRANTED: "granted",
    DENIED: "denied",
  },
  SchedulableTriggerInputTypes: {
    DATE: "date",
  },
  AndroidImportance: {
    MAX: 5,
  },
  getPermissionsAsync: jest.fn(),
  requestPermissionsAsync: jest.fn(),
  getExactAlarmPermissionsAsync: jest.fn(),
  requestExactAlarmPermissionsAsync: jest.fn(),
  setNotificationChannelAsync: jest.fn(),
  cancelScheduledNotificationAsync: jest.fn(),
  scheduleNotificationAsync: jest.fn(),
}));

const mockedNotifications = jest.mocked(Notifications);

const testCopy = {
  channelName: "Adzan & Prayer Times",
  titleForPrayer: (prayer: string) => `Time for ${prayer}`,
  bodyForPrayer: (prayer: string) => `Enter ${prayer} time`,
};

describe("prayer-alarm-service", () => {
  beforeEach(() => {
    jest.clearAllMocks();
    clearAllPrefs();
    Platform.OS = "android";
    mockedNotifications.getPermissionsAsync.mockResolvedValue({
      granted: true,
      canAskAgain: true,
      expires: "never",
      status: Notifications.PermissionStatus.GRANTED,
    });
    mockedNotifications.getExactAlarmPermissionsAsync.mockResolvedValue({
      granted: true,
      canAskAgain: true,
      expires: "never",
      status: Notifications.PermissionStatus.GRANTED,
    });
    mockedNotifications.setNotificationChannelAsync.mockResolvedValue(null);
    mockedNotifications.cancelScheduledNotificationAsync.mockResolvedValue(
      undefined,
    );
    let seq = 0;
    mockedNotifications.scheduleNotificationAsync.mockImplementation(
      async () => {
        seq += 1;
        return `notif-${seq}`;
      },
    );
  });

  it("cancels previously persisted notification IDs before scheduling new ones", async () => {
    setPrayerNotificationIds(["old-1", "old-2"]);

    const res = await schedulePrayerAlarms(
      { latitude: -6.2088, longitude: 106.8456 },
      testCopy,
      { now: new Date(2026, 4, 15, 3, 0, 0) },
    );

    expect(res.ok).toBe(true);
    expect(
      mockedNotifications.cancelScheduledNotificationAsync,
    ).toHaveBeenCalledTimes(2);
    expect(
      mockedNotifications.cancelScheduledNotificationAsync,
    ).toHaveBeenCalledWith("old-1");
    expect(
      mockedNotifications.cancelScheduledNotificationAsync,
    ).toHaveBeenCalledWith("old-2");
    expect(getPrayerNotificationIds()).toHaveLength(10);
  });

  it("uses alarmClock delivery and system default sound on Android", async () => {
    const res = await schedulePrayerAlarms(
      { latitude: -6.2088, longitude: 106.8456 },
      testCopy,
      { now: new Date(2026, 4, 15, 3, 0, 0) },
    );

    expect(res.ok).toBe(true);
    expect(
      mockedNotifications.setNotificationChannelAsync,
    ).toHaveBeenCalledWith(
      "prayer-alarms",
      expect.not.objectContaining({ sound: "default" }),
    );
    expect(mockedNotifications.scheduleNotificationAsync).toHaveBeenCalledWith(
      expect.objectContaining({
        content: expect.objectContaining({
          sound: true,
        }),
        trigger: expect.objectContaining({
          type: "date",
          delivery: "alarmClock",
          channelId: "prayer-alarms",
        }),
      }),
    );
  });

  it("returns permission error when notification permission is denied", async () => {
    mockedNotifications.getPermissionsAsync.mockResolvedValue({
      granted: false,
      canAskAgain: false,
      expires: "never",
      status: Notifications.PermissionStatus.DENIED,
    });

    const res = await schedulePrayerAlarms(
      { latitude: -6.2088, longitude: 106.8456 },
      testCopy,
      { requestPermission: false },
    );

    expect(res.ok).toBe(false);
    if (!res.ok) {
      expect(res.error.code).toBe("permission");
    }
    expect(
      mockedNotifications.scheduleNotificationAsync,
    ).not.toHaveBeenCalled();
  });

  it("clears persisted IDs on cancelAllPrayerAlarms", async () => {
    setPrayerNotificationIds(["id-a", "id-b"]);
    const res = await cancelAllPrayerAlarms();
    expect(res.ok).toBe(true);
    expect(getPrayerNotificationIds()).toEqual([]);
  });
});
