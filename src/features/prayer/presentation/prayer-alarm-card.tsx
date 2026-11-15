import { Bell, BellOff } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import { useTranslation } from "react-i18next";
import { Switch, Text, View } from "react-native";
import { Button } from "@/components/button";
import { getThemePalette } from "@/theme/palette";

type Props = Readonly<{
  alarmsEnabled: boolean;
  exactAlarmGranted: boolean;
  permissionDenied: boolean;
  onToggle: (next: boolean) => void;
  onRequestExactAlarm: () => void;
}>;

export const PrayerAlarmCard = ({
  alarmsEnabled,
  exactAlarmGranted,
  permissionDenied,
  onToggle,
  onRequestExactAlarm,
}: Props) => {
  const { t } = useTranslation();
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);

  return (
    <View className="rounded-2xl border border-border bg-surface p-4">
      <View className="flex-row items-center justify-between gap-3">
        <View className="flex-1 flex-row items-center gap-3">
          {alarmsEnabled ? (
            <Bell size={18} color={palette.primary} />
          ) : (
            <BellOff size={18} color={palette.muted} />
          )}
          <View className="flex-1">
            <Text className="text-sm font-semibold text-text">
              {t("prayer.alarmsTitle")}
            </Text>
            <Text className="text-xs text-muted">
              {t("prayer.alarmsSubtitle")}
            </Text>
          </View>
        </View>
        <Switch
          value={alarmsEnabled}
          onValueChange={onToggle}
          accessibilityLabel={t("prayer.alarmsTitle")}
        />
      </View>

      {alarmsEnabled && !exactAlarmGranted ? (
        <View className="mt-3 rounded-xl bg-warning-container p-3">
          <Text className="text-xs leading-4 text-text">
            {t("prayer.exactAlarmWarning")}
          </Text>
          <Button
            containerClassName="mt-2"
            size="sm"
            shape="soft"
            label={t("prayer.enableExactAlarm")}
            onPress={onRequestExactAlarm}
          />
        </View>
      ) : null}

      {permissionDenied ? (
        <Text className="mt-2 text-xs text-error">
          {t("prayer.notificationPermissionDenied")}
        </Text>
      ) : null}
    </View>
  );
};
