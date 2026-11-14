import { useRouter } from "expo-router";
import { ChevronRight, RotateCcw } from "lucide-react-native";
import { useTranslation } from "react-i18next";
import { Pressable, Text, View } from "react-native";

import { Screen } from "@/components/screen";
import colors from "@/theme/colors.json";

export default function SettingsScreen() {
  const { t } = useTranslation();
  const router = useRouter();

  return (
    <Screen className="px-5 pt-4">
      <Text className="font-serif text-2xl font-bold text-text">
        {t("settings.title")}
      </Text>

      <View className="mt-5">
        <Pressable
          accessibilityRole="button"
          accessibilityLabel={t("settings.rerunOnboarding")}
          onPress={() => router.push("/(onboarding)")}
          className="min-h-11 min-w-11 flex-row items-center gap-3 rounded-2xl border border-border bg-surface p-4"
        >
          <RotateCcw color={colors.primary} size={20} />
          <View className="flex-1">
            <Text className="text-base font-semibold text-text">
              {t("settings.rerunOnboarding")}
            </Text>
            <Text className="mt-1 text-sm leading-5 text-muted">
              {t("settings.rerunOnboardingDesc")}
            </Text>
          </View>
          <ChevronRight color={colors.muted} size={20} />
        </Pressable>
      </View>
    </Screen>
  );
}
