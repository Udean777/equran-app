import "../../global.css";
import "@/lib/i18n";

import { QueryClientProvider } from "@tanstack/react-query";
import { Stack } from "expo-router";
import { StatusBar } from "expo-status-bar";
import * as SystemUI from "expo-system-ui";
import {
  colorScheme as nativewindColorScheme,
  useColorScheme,
} from "nativewind";
import { useEffect } from "react";
import { SafeAreaProvider } from "react-native-safe-area-context";

import { migrate } from "@/lib/db/client";
import { queryClient } from "@/lib/query-client";
import { STACK_TRANSITIONS } from "@/theme/navigation-transitions";
import { getThemePalette } from "@/theme/palette";
import { useThemeStore } from "@/theme/use-theme-store";

export default function RootLayout() {
  const mode = useThemeStore((state) => state.mode);
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);

  useEffect(() => {
    migrate();
  }, []);

  useEffect(() => {
    nativewindColorScheme.set(mode);
  }, [mode]);

  useEffect(() => {
    void SystemUI.setBackgroundColorAsync(palette.bg);
  }, [palette.bg]);

  return (
    <QueryClientProvider client={queryClient}>
      <SafeAreaProvider>
        <StatusBar style={colorScheme === "light" ? "dark" : "light"} />
        <Stack
          screenOptions={{
            headerShown: false,
            ...STACK_TRANSITIONS.push,
            contentStyle: { backgroundColor: palette.bg },
          }}
        >
          <Stack.Screen
            name="(onboarding)/index"
            options={STACK_TRANSITIONS.fade}
          />
          <Stack.Screen name="(tabs)" options={STACK_TRANSITIONS.fade} />
        </Stack>
      </SafeAreaProvider>
    </QueryClientProvider>
  );
}
