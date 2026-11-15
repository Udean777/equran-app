import "../../global.css";
import "@/lib/i18n";

import { QueryClientProvider } from "@tanstack/react-query";
import { Stack } from "expo-router";
import * as SplashScreen from "expo-splash-screen";
import { StatusBar } from "expo-status-bar";
import * as SystemUI from "expo-system-ui";
import {
  colorScheme as nativewindColorScheme,
  useColorScheme,
} from "nativewind";
import { useCallback, useEffect, useRef, useState } from "react";
import { View } from "react-native";
import { SafeAreaProvider } from "react-native-safe-area-context";

import { migrate } from "@/lib/db/client";
import { queryClient } from "@/lib/query-client";
import { STACK_TRANSITIONS } from "@/theme/navigation-transitions";
import { getThemePalette } from "@/theme/palette";
import { useThemeStore } from "@/theme/use-theme-store";

void SplashScreen.preventAutoHideAsync().catch(() => undefined);
try {
  SplashScreen.setOptions({ duration: 400, fade: true });
} catch {
  // Ignore when native splash module is unavailable (e.g. Jest/web).
}

export default function RootLayout() {
  const mode = useThemeStore((state) => state.mode);
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);
  const [isAppReady, setIsAppReady] = useState(false);
  const hasHiddenSplashRef = useRef(false);

  useEffect(() => {
    try {
      migrate();
    } finally {
      setIsAppReady(true);
    }
  }, []);

  useEffect(() => {
    nativewindColorScheme.set(mode);
  }, [mode]);

  useEffect(() => {
    void SystemUI.setBackgroundColorAsync(palette.bg);
  }, [palette.bg]);

  const onLayoutRootView = useCallback(() => {
    if (!isAppReady || hasHiddenSplashRef.current) return;
    hasHiddenSplashRef.current = true;
    void SplashScreen.hideAsync().catch(() => undefined);
  }, [isAppReady]);

  if (!isAppReady) {
    return null;
  }

  return (
    <QueryClientProvider client={queryClient}>
      <SafeAreaProvider>
        <View className="flex-1" onLayout={onLayoutRootView}>
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
        </View>
      </SafeAreaProvider>
    </QueryClientProvider>
  );
}
