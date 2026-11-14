import { Tabs } from "expo-router";
import { useTranslation } from "react-i18next";

import colors from "@/theme/colors.json";

export default function TabsLayout() {
  const { t } = useTranslation();

  return (
    <Tabs
      screenOptions={{
        headerShown: false,
        tabBarActiveTintColor: colors.primary,
        tabBarInactiveTintColor: colors.muted,
        tabBarStyle: {
          backgroundColor: colors.surface,
          borderTopColor: colors.border,
        },
      }}
    >
      <Tabs.Screen name="index" options={{ title: t("tabs.quran") }} />
      <Tabs.Screen name="prayer" options={{ title: t("tabs.prayer") }} />
      <Tabs.Screen name="hafalan" options={{ title: t("tabs.hafalan") }} />
      <Tabs.Screen name="settings" options={{ title: t("tabs.settings") }} />
    </Tabs>
  );
}
