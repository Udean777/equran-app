import { useRouter } from "expo-router";
import {
  ChevronRight,
  Globe,
  Moon,
  RotateCcw,
  Smartphone,
  Sun,
  Volume2,
} from "lucide-react-native";
import { useColorScheme } from "nativewind";
import { useTranslation } from "react-i18next";
import { ScrollView, Text, View } from "react-native";

import { AnimatedPressable } from "@/components/animated-pressable";
import { LuxuryHeader } from "@/components/luxury-header";
import { Screen } from "@/components/screen";
import { SectionHeader } from "@/components/section-header";
import { QARI_PROFILES } from "@/features/audio/domain/audio-url";
import { useMurattalPlayer } from "@/features/audio/presentation/use-murattal-player";
import { cn } from "@/lib/cn";
import {
  type AppLanguage,
  setLanguage,
  type ThemeMode,
} from "@/lib/storage/prefs";
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

const LANGUAGE_OPTIONS: readonly {
  readonly code: AppLanguage;
  readonly labelKey: string;
}[] = [
  { code: "id", labelKey: "settings.languageId" },
  { code: "en", labelKey: "settings.languageEn" },
];

export const SettingsScreen = () => {
  const { t, i18n } = useTranslation();
  const router = useRouter();
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);
  const mode = useThemeStore((state) => state.mode);
  const setMode = useThemeStore((state) => state.setMode);
  const { qariId, selectQari } = useMurattalPlayer();
  const currentLang: AppLanguage = i18n.language === "en" ? "en" : "id";

  const handleLanguageChange = (lang: AppLanguage) => {
    setLanguage(lang);
    void i18n.changeLanguage(lang);
  };

  const renderThemeIcon = (optionMode: ThemeMode, active: boolean) => {
    const color = active ? palette.onPrimary : palette.primary;
    if (optionMode === "light") return <Sun color={color} size={18} />;
    if (optionMode === "dark") return <Moon color={color} size={18} />;
    return <Smartphone color={color} size={18} />;
  };

  return (
    <Screen edges={["top", "left", "right"]} className="px-4 pt-3">
      <LuxuryHeader title={t("settings.title")} />

      <ScrollView
        showsVerticalScrollIndicator={false}
        contentContainerClassName="pb-6"
      >
        <View className="items-center overflow-hidden rounded-3xl border border-gold/40 bg-onboarding-bg p-6">
          <View className="mb-3 h-16 w-16 items-center justify-center rounded-3xl border border-gold/45 bg-onboarding-surface">
            <Text className="font-arabic text-3xl text-gold">ق</Text>
          </View>
          <Text className="font-serif text-2xl font-bold text-onboarding-text">
            Qurva
          </Text>
          <Text className="mt-1 text-xs text-onboarding-muted">
            {t("onboarding.slides.welcome.subtitle")}
          </Text>
          <View className="mt-3 flex-row items-center gap-1.5 rounded-full border border-gold/35 bg-onboarding-surface px-3 py-1">
            <View className="h-2 w-2 rounded-full bg-gold" />
            <Text className="text-xs font-bold text-gold">v0.1.0</Text>
          </View>
        </View>

        <SectionHeader title={t("settings.sectionAppearance")} />

        <View className="rounded-3xl border border-border bg-surface p-4">
          <Text className="text-sm font-bold text-text">
            {t("settings.theme")}
          </Text>
          <View className="mt-3 flex-row gap-2.5">
            {THEME_OPTIONS.map((option) => {
              const active = mode === option.mode;
              return (
                <AnimatedPressable
                  key={option.mode}
                  containerClassName="flex-1"
                  accessibilityRole="button"
                  accessibilityLabel={t(option.labelKey)}
                  onPress={() => setMode(option.mode)}
                  className={cn(
                    "min-h-11 min-w-11 items-center justify-center gap-1.5 rounded-2xl border px-3 py-3",
                    active
                      ? "border-primary bg-primary"
                      : "border-border bg-surface-variant",
                  )}
                >
                  {renderThemeIcon(option.mode, active)}
                  <Text
                    className={cn(
                      "text-xs font-bold",
                      active ? "text-on-primary" : "text-text",
                    )}
                  >
                    {t(option.labelKey)}
                  </Text>
                </AnimatedPressable>
              );
            })}
          </View>

          <View className="my-4 h-px bg-border" />

          <View className="flex-row items-center gap-2">
            <Globe color={palette.primary} size={16} />
            <Text className="text-sm font-bold text-text">
              {t("settings.language")}
            </Text>
          </View>
          <View className="mt-3 flex-row gap-2.5">
            {LANGUAGE_OPTIONS.map((option) => {
              const active = currentLang === option.code;
              return (
                <AnimatedPressable
                  key={option.code}
                  containerClassName="flex-1"
                  accessibilityRole="button"
                  accessibilityLabel={t(option.labelKey)}
                  onPress={() => handleLanguageChange(option.code)}
                  className={cn(
                    "min-h-11 min-w-11 items-center justify-center rounded-2xl border px-3 py-2.5",
                    active
                      ? "border-primary bg-primary"
                      : "border-border bg-surface-variant",
                  )}
                >
                  <Text
                    className={cn(
                      "text-xs font-bold",
                      active ? "text-on-primary" : "text-text",
                    )}
                  >
                    {t(option.labelKey)}
                  </Text>
                </AnimatedPressable>
              );
            })}
          </View>

          <View className="my-4 h-px bg-border" />

          <View className="flex-row items-center gap-2">
            <Volume2 color={palette.primary} size={16} />
            <Text className="text-sm font-bold text-text">
              {t("settings.qari")}
            </Text>
          </View>
          <View className="mt-3 gap-2">
            {QARI_PROFILES.map((qari) => {
              const active = qariId === qari.id;
              return (
                <AnimatedPressable
                  key={qari.id}
                  accessibilityRole="button"
                  accessibilityLabel={t(qari.labelKey)}
                  onPress={() => selectQari(qari.id)}
                  className={cn(
                    "min-h-11 flex-row items-center justify-between rounded-2xl border px-3.5 py-2.5",
                    active
                      ? "border-primary bg-primary"
                      : "border-border bg-surface-variant",
                  )}
                >
                  <Text
                    className={cn(
                      "text-xs font-bold",
                      active ? "text-on-primary" : "text-text",
                    )}
                  >
                    {t(qari.labelKey)}
                  </Text>
                  <Text
                    className={cn(
                      "text-xs",
                      active ? "text-on-primary" : "text-muted",
                    )}
                  >
                    {qari.bitrate} kbps
                  </Text>
                </AnimatedPressable>
              );
            })}
          </View>
        </View>

        <SectionHeader title={t("settings.sectionGuide")} />

        <AnimatedPressable
          accessibilityRole="button"
          accessibilityLabel={t("settings.rerunOnboarding")}
          onPress={() => router.push("/(onboarding)")}
          className="min-h-11 min-w-11 flex-row items-center gap-3.5 rounded-3xl border border-border bg-surface p-4"
        >
          <View className="h-11 w-11 items-center justify-center rounded-2xl border border-gold/40 bg-primary-container">
            <RotateCcw color={palette.onPrimaryContainer} size={20} />
          </View>
          <View className="flex-1">
            <Text className="text-base font-bold text-text">
              {t("settings.rerunOnboarding")}
            </Text>
            <Text className="mt-1 text-xs leading-5 text-muted">
              {t("settings.rerunOnboardingDesc")}
            </Text>
          </View>
          <View className="h-8 w-8 items-center justify-center rounded-full bg-surface-variant">
            <ChevronRight color={palette.muted} size={16} />
          </View>
        </AnimatedPressable>
      </ScrollView>
    </Screen>
  );
};
