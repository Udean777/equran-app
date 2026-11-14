import { Redirect, Tabs } from "expo-router";
import { BookOpen, Brain, Clock, Settings } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import { useTranslation } from "react-i18next";

import { FluidTabBar } from "@/components/fluid-tab-bar";
import { TabBarAnimatedIcon } from "@/components/tab-bar-animated-icon";
import { useOnboardingStore } from "@/features/onboarding/presentation/use-onboarding-store";
import { TAB_TRANSITIONS } from "@/theme/navigation-transitions";
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
      tabBar={(props) => <FluidTabBar {...props} />}
      screenOptions={{
        headerShown: false,
        ...TAB_TRANSITIONS.shift,
        sceneStyle: { backgroundColor: palette.bg },
      }}
    >
      <Tabs.Screen
        name="index"
        options={{
          title: t("tabs.quran"),
          tabBarIcon: ({ color, size, focused }) => (
            <TabBarAnimatedIcon focused={focused}>
              <BookOpen color={color} size={size} />
            </TabBarAnimatedIcon>
          ),
        }}
      />
      <Tabs.Screen
        name="prayer"
        options={{
          title: t("tabs.prayer"),
          tabBarIcon: ({ color, size, focused }) => (
            <TabBarAnimatedIcon focused={focused}>
              <Clock color={color} size={size} />
            </TabBarAnimatedIcon>
          ),
        }}
      />
      <Tabs.Screen
        name="hafalan"
        options={{
          title: t("tabs.hafalan"),
          tabBarIcon: ({ color, size, focused }) => (
            <TabBarAnimatedIcon focused={focused}>
              <Brain color={color} size={size} />
            </TabBarAnimatedIcon>
          ),
        }}
      />
      <Tabs.Screen
        name="settings"
        options={{
          title: t("tabs.settings"),
          tabBarIcon: ({ color, size, focused }) => (
            <TabBarAnimatedIcon focused={focused}>
              <Settings color={color} size={size} />
            </TabBarAnimatedIcon>
          ),
        }}
      />
    </Tabs>
  );
}
