import { Image } from "expo-image";
import { ArrowLeft } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import type { ReactNode } from "react";
import { Text, View } from "react-native";

import { IconButton } from "@/components/icon-button";
import { getThemePalette } from "@/theme/palette";

const BRAND_LOGO = require("../../assets/images/brand-logo.webp");

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
          <IconButton label={backLabel ?? title} onPress={onBack}>
            <ArrowLeft color={palette.text} size={20} />
          </IconButton>
        ) : null}

        {showBrandMark ? (
          <View className="h-11 w-11 items-center justify-center overflow-hidden rounded-2xl border border-gold/40 bg-onboarding-bg">
            <Image
              source={BRAND_LOGO}
              contentFit="cover"
              style={{ width: 42, height: 42 }}
              accessibilityLabel={title}
            />
          </View>
        ) : null}

        <View className="flex-1">
          <Text
            accessibilityRole="header"
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
