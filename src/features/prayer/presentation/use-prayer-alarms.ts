import { useCallback, useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import {
  cancelAllPrayerAlarms,
  checkExactAlarmPermission,
  requestExactAlarmPermission,
  schedulePrayerAlarms,
} from "@/features/prayer/data/prayer-alarm-service";
import {
  getPrayerAlarmsEnabled,
  setPrayerAlarmsEnabled,
} from "@/lib/storage/prefs";

export const usePrayerAlarms = (latitude: number, longitude: number) => {
  const { t } = useTranslation();
  const [enabled, setEnabled] = useState<boolean>(() =>
    getPrayerAlarmsEnabled(),
  );
  const [exactAlarmGranted, setExactAlarmGranted] = useState<boolean>(true);
  const [permissionDenied, setPermissionDenied] = useState<boolean>(false);

  const buildCopy = useCallback(
    () => ({
      channelName: t("prayer.alarmChannelName"),
      titleForPrayer: (prayer: "fajr" | "dhuhr" | "asr" | "maghrib" | "isha") =>
        t("prayer.alarmTitle", { prayer: t(`prayer.names.${prayer}`) }),
      bodyForPrayer: (prayer: "fajr" | "dhuhr" | "asr" | "maghrib" | "isha") =>
        t("prayer.alarmBody", { prayer: t(`prayer.names.${prayer}`) }),
    }),
    [t],
  );

  useEffect(() => {
    let active = true;
    if (!enabled) {
      void cancelAllPrayerAlarms();
      return () => {
        active = false;
      };
    }

    void schedulePrayerAlarms({ latitude, longitude }, buildCopy(), {
      requestPermission: false,
    }).then((res) => {
      if (!active) return;
      if (res.ok) {
        setExactAlarmGranted(res.value.exactAlarmGranted);
        setPermissionDenied(false);
      } else if (res.error.code === "permission") {
        setPermissionDenied(true);
      }
    });

    return () => {
      active = false;
    };
  }, [buildCopy, enabled, latitude, longitude]);

  const toggleAlarms = async (next: boolean): Promise<void> => {
    setEnabled(next);
    setPrayerAlarmsEnabled(next);
    if (!next) {
      await cancelAllPrayerAlarms();
      return;
    }
    const res = await schedulePrayerAlarms(
      { latitude, longitude },
      buildCopy(),
      {
        requestPermission: true,
      },
    );
    if (res.ok) {
      setExactAlarmGranted(res.value.exactAlarmGranted);
      setPermissionDenied(false);
    } else if (res.error.code === "permission") {
      setPermissionDenied(true);
    }
  };

  const requestExactAlarm = async (): Promise<void> => {
    const granted = await requestExactAlarmPermission();
    const checked = granted || (await checkExactAlarmPermission());
    setExactAlarmGranted(checked);
    if (checked && enabled) {
      await schedulePrayerAlarms({ latitude, longitude }, buildCopy(), {
        requestPermission: false,
      });
    }
  };

  return {
    alarmsEnabled: enabled,
    exactAlarmGranted,
    permissionDenied,
    toggleAlarms,
    requestExactAlarm,
  };
};
