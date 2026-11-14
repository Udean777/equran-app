import { Info, X } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import { useEffect } from "react";
import { Pressable, Text } from "react-native";
import Animated, { FadeIn, FadeOut } from "react-native-reanimated";

import { getThemePalette } from "@/theme/palette";

type Props = Readonly<{
  visible: boolean;
  message: string;
  dismissLabel: string;
  onDismiss: () => void;
  durationMs?: number;
}>;

export const Toast = ({
  visible,
  message,
  dismissLabel,
  onDismiss,
  durationMs = 5000,
}: Props) => {
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);

  useEffect(() => {
    if (!visible || durationMs <= 0) return;
    const timer = setTimeout(onDismiss, durationMs);
    return () => clearTimeout(timer);
  }, [durationMs, onDismiss, visible]);

  if (!visible) return null;

  return (
    <Animated.View
      entering={FadeIn.duration(200)}
      exiting={FadeOut.duration(160)}
      accessibilityRole="alert"
      accessibilityLiveRegion="polite"
      className="absolute bottom-5 left-4 right-4 z-50 flex-row items-center gap-3 rounded-2xl border border-gold/50 bg-surface px-4 py-3 shadow-lg"
    >
      <Info color={palette.primary} size={18} />
      <Text className="flex-1 text-xs font-medium leading-5 text-text">
        {message}
      </Text>
      <Pressable
        accessibilityRole="button"
        accessibilityLabel={dismissLabel}
        onPress={onDismiss}
        className="min-h-11 min-w-11 items-center justify-center"
      >
        <X color={palette.muted} size={16} />
      </Pressable>
    </Animated.View>
  );
};
