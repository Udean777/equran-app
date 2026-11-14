import { Redirect, Tabs } from "expo-router";
import { BookOpen, Brain, Clock, Settings } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import { useTranslation } from "react-i18next";

import { useOnboardingStore } from "@/features/onboarding/presentation/use-onboarding-store";
import { getThemePalette } from "@/theme/palette";

export default function TabsLayout() {
  const { t } = useTranslation();
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);
  const completed = useOnboardingStore((state) => state.completed);

  if (!completed) {
    return <Redirect href="/(onboarding)" />;
  }

  return (
    <Tabs
      screenOptions={{
        headerShown: false,
        tabBarActiveTintColor: palette.primary,
        tabBarInactiveTintColor: palette.muted,
        tabBarStyle: {
          backgroundColor: palette.surface,
          borderTopColor: palette.border,
        },
      }}
    >
      <Tabs.Screen
        name="index"
        options={{
          title: t("tabs.quran"),
          tabBarIcon: ({ color, size }) => (
            <BookOpen color={color} size={size} />
          ),
        }}
      />
      <Tabs.Screen
        name="prayer"
        options={{
          title: t("tabs.prayer"),
          tabBarIcon: ({ color, size }) => <Clock color={color} size={size} />,
        }}
      />
      <Tabs.Screen
        name="hafalan"
        options={{
          title: t("tabs.hafalan"),
          tabBarIcon: ({ color, size }) => <Brain color={color} size={size} />,
        }}
      />
      <Tabs.Screen
        name="settings"
        options={{
          title: t("tabs.settings"),
          tabBarIcon: ({ color, size }) => (
            <Settings color={color} size={size} />
          ),
        }}
      />
    </Tabs>
  );
}
