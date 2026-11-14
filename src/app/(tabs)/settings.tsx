import { useRouter } from "expo-router";
import { ChevronRight, RotateCcw } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import { useTranslation } from "react-i18next";
import { Pressable, Text, View } from "react-native";

import { Screen } from "@/components/screen";
import { cn } from "@/lib/cn";
import { type ThemeMode } from "@/lib/storage/prefs";
import { getThemePalette } from "@/theme/palette";
import { useThemeStore } from "@/theme/use-theme-store";

const THEME_OPTIONS: readonly {
  readonly mode: ThemeMode;
  readonly labelKey: string;
}[] = [
  { mode: "light", labelKey: "settings.themeLight" },
  { mode: "dark", labelKey: "settings.themeDark" },
  { mode: "system", labelKey: "settings.themeSystem" },
];

export default function SettingsScreen() {
  const { t } = useTranslation();
  const router = useRouter();
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);
  const mode = useThemeStore((state) => state.mode);
  const setMode = useThemeStore((state) => state.setMode);

  return (
    <Screen className="px-5 pt-4">
      <Text className="font-serif text-2xl font-bold text-text">
        {t("settings.title")}
      </Text>

      <View className="mt-5 rounded-2xl border border-border bg-surface p-4">
        <Text className="text-base font-semibold text-text">
          {t("settings.theme")}
        </Text>
        <View className="mt-3 flex-row gap-2">
          {THEME_OPTIONS.map((option) => {
            const active = mode === option.mode;
            return (
              <Pressable
                key={option.mode}
                accessibilityRole="button"
                accessibilityLabel={t(option.labelKey)}
                onPress={() => setMode(option.mode)}
                className={cn(
                  "min-h-11 min-w-11 flex-1 items-center justify-center rounded-xl border px-3 py-2",
                  active
                    ? "border-primary bg-primary"
                    : "border-border bg-surface-variant",
                )}
              >
                <Text
                  className={cn(
                    "text-sm font-semibold",
                    active ? "text-on-primary" : "text-text",
                  )}
                >
                  {t(option.labelKey)}
                </Text>
              </Pressable>
            );
          })}
        </View>
      </View>

      <View className="mt-4">
        <Pressable
          accessibilityRole="button"
          accessibilityLabel={t("settings.rerunOnboarding")}
          onPress={() => router.push("/(onboarding)")}
          className="min-h-11 min-w-11 flex-row items-center gap-3 rounded-2xl border border-border bg-surface p-4"
        >
          <RotateCcw color={palette.primary} size={20} />
          <View className="flex-1">
            <Text className="text-base font-semibold text-text">
              {t("settings.rerunOnboarding")}
            </Text>
            <Text className="mt-1 text-sm leading-5 text-muted">
              {t("settings.rerunOnboardingDesc")}
            </Text>
          </View>
          <ChevronRight color={palette.muted} size={20} />
        </Pressable>
      </View>
    </Screen>
  );
}
