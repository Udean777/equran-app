import { ArrowLeft } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import type { ReactNode } from "react";
import { Text, View } from "react-native";

import { AnimatedPressable } from "@/components/animated-pressable";
import { getThemePalette } from "@/theme/palette";

type Props = Readonly<{
  title: string;
  subtitle?: string;
  showBrandMark?: boolean;
  backLabel?: string;
  onBack?: () => void;
  rightAction?: ReactNode;
}>;

export const LuxuryHeader = ({
  title,
  subtitle,
  showBrandMark = false,
  backLabel,
  onBack,
  rightAction,
}: Props) => {
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);

  return (
    <View className="mb-3 flex-row items-center justify-between gap-3 border-b border-border pb-3">
      <View className="flex-1 flex-row items-center gap-3">
        {onBack ? (
          <AnimatedPressable
            accessibilityRole="button"
            accessibilityLabel={backLabel ?? title}
            onPress={onBack}
            className="h-11 w-11 items-center justify-center rounded-2xl border border-border bg-surface"
          >
            <ArrowLeft color={palette.text} size={20} />
          </AnimatedPressable>
        ) : null}

        {showBrandMark ? (
          <View className="h-11 w-11 items-center justify-center rounded-2xl border border-gold/40 bg-onboarding-bg">
            <Text className="font-arabic text-xl text-gold">ق</Text>
          </View>
        ) : null}

        <View className="flex-1">
          <Text
            numberOfLines={1}
            className="font-serif text-xl font-bold text-text"
          >
            {title}
          </Text>
          <View className="mt-1 flex-row items-center gap-2">
            <View className="h-0.5 w-7 rounded-full bg-gold" />
            {subtitle ? (
              <Text numberOfLines={1} className="text-xs text-muted">
                {subtitle}
              </Text>
            ) : null}
          </View>
        </View>
      </View>

      {rightAction ? (
        <View className="flex-row items-center gap-2">{rightAction}</View>
      ) : null}
    </View>
  );
};
