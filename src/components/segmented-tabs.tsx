import { useColorScheme } from "nativewind";
import type { ReactNode } from "react";
import { Text, View } from "react-native";
import { AnimatedPressable } from "@/components/animated-pressable";
import { cn } from "@/lib/cn";
import { BRAND_COLORS, getThemePalette } from "@/theme/palette";

export type SegmentedTabOption<T extends string> = Readonly<{
  value: T;
  label: string;
  renderIcon: (color: string) => ReactNode;
}>;

type Props<T extends string> = Readonly<{
  options: readonly SegmentedTabOption<T>[];
  value: T;
  onChange: (value: T) => void;
  className?: string;
}>;

const goldColor = BRAND_COLORS.gold.DEFAULT;

export const SegmentedTabs = <T extends string>({
  options,
  value,
  onChange,
  className,
}: Props<T>) => {
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);

  return (
    <View
      className={cn(
        "flex-row rounded-2xl border border-border bg-surface p-1",
        className,
      )}
    >
      {options.map((option) => {
        const selected = option.value === value;
        return (
          <AnimatedPressable
            key={option.value}
            accessibilityRole="tab"
            accessibilityState={{ selected }}
            accessibilityLabel={option.label}
            onPress={() => onChange(option.value)}
            className={cn(
              "min-h-11 flex-1 flex-row items-center justify-center gap-2 rounded-xl px-3",
              selected ? "bg-onboarding-bg" : "bg-transparent",
            )}
          >
            {option.renderIcon(selected ? goldColor : palette.muted)}
            <Text
              className={cn(
                "text-sm font-semibold",
                selected ? "text-onboarding-text" : "text-muted",
              )}
            >
              {option.label}
            </Text>
          </AnimatedPressable>
        );
      })}
    </View>
  );
};
