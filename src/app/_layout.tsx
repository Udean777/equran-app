import "../../global.css";
import "@/lib/i18n";

import { QueryClientProvider } from "@tanstack/react-query";
import { Stack } from "expo-router";
import { StatusBar } from "expo-status-bar";
import { useColorScheme } from "nativewind";
import { useEffect } from "react";
import { SafeAreaProvider } from "react-native-safe-area-context";

import { migrate } from "@/lib/db/client";
import { queryClient } from "@/lib/query-client";
import { useThemeStore } from "@/theme/use-theme-store";

export default function RootLayout() {
  const mode = useThemeStore((state) => state.mode);
  const { colorScheme, setColorScheme } = useColorScheme();

  useEffect(() => {
    migrate();
  }, []);

  useEffect(() => {
    setColorScheme(mode);
  }, [mode, setColorScheme]);

  return (
    <QueryClientProvider client={queryClient}>
      <SafeAreaProvider>
        <StatusBar style={colorScheme === "light" ? "dark" : "light"} />
        <Stack screenOptions={{ headerShown: false }} />
      </SafeAreaProvider>
    </QueryClientProvider>
  );
}
