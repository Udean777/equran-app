import type { TFunction } from "i18next";
import { useCallback, useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import {
  checkExactAlarmPermission,
  cancelAllPrayerAlarms,
  type PrayerAlarmCopy,
  type PrayerAlarmSyncResult,
  requestExactAlarmPermission,
  schedulePrayerAlarms,
} from "@/features/prayer/data/prayer-alarm-service";
import type { Result } from "@/lib/result";
import {
  getPrayerAlarmsEnabled,
  setPrayerAlarmsEnabled,
} from "@/lib/storage/prefs";

const buildAlarmCopy = (t: TFunction): PrayerAlarmCopy => ({
  channelName: t("prayer.alarmChannelName"),
  titleForPrayer: (prayer) =>
    t("prayer.alarmTitle", { prayer: t(`prayer.names.${prayer}`) }),
  bodyForPrayer: (prayer) =>
    t("prayer.alarmBody", { prayer: t(`prayer.names.${prayer}`) }),
});

export const usePrayerAlarms = (latitude: number, longitude: number) => {
  const { t } = useTranslation();
  const [enabled, setEnabled] = useState<boolean>(() =>
    getPrayerAlarmsEnabled(),
  );
  const [exactAlarmGranted, setExactAlarmGranted] = useState<boolean>(true);
  const [permissionDenied, setPermissionDenied] = useState<boolean>(false);

  const applySyncResult = useCallback((res: Result<PrayerAlarmSyncResult>) => {
    if (res.ok) {
      setExactAlarmGranted(res.value.exactAlarmGranted);
      setPermissionDenied(false);
    } else if (res.error.code === "permission") {
      setPermissionDenied(true);
    }
  }, []);

  useEffect(() => {
    let active = true;
    if (!enabled) {
      void cancelAllPrayerAlarms();
      return () => {
        active = false;
      };
    }

    void schedulePrayerAlarms({ latitude, longitude }, buildAlarmCopy(t), {
      requestPermission: false,
    }).then((res) => {
      if (active) applySyncResult(res);
    });

    return () => {
      active = false;
    };
  }, [applySyncResult, enabled, latitude, longitude, t]);

  const toggleAlarms = async (next: boolean): Promise<void> => {
    setEnabled(next);
    setPrayerAlarmsEnabled(next);
    if (!next) {
      await cancelAllPrayerAlarms();
      return;
    }
    const res = await schedulePrayerAlarms(
      { latitude, longitude },
      buildAlarmCopy(t),
      { requestPermission: true },
    );
    applySyncResult(res);
  };

  const requestExactAlarm = async (): Promise<void> => {
    const granted = await requestExactAlarmPermission();
    const checked = granted || (await checkExactAlarmPermission());
    setExactAlarmGranted(checked);
    if (checked && enabled) {
      await schedulePrayerAlarms({ latitude, longitude }, buildAlarmCopy(t), {
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
