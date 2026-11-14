import { useColorScheme } from "nativewind";
import { type ReactNode, useEffect, useState } from "react";
import { Text, View } from "react-native";
import Animated, {
  useAnimatedStyle,
  useReducedMotion,
  useSharedValue,
  withSpring,
} from "react-native-reanimated";

import { AnimatedPressable } from "@/components/animated-pressable";
import { cn } from "@/lib/cn";
import { getThemePalette } from "@/theme/palette";

type TabRoute = Readonly<{
  key: string;
  name: string;
  params?: object;
}>;

type TabDescriptor = Readonly<{
  options?: {
    title?: string;
    tabBarAccessibilityLabel?: string;
    tabBarIcon?: (props: {
      focused: boolean;
      color: string;
      size: number;
    }) => ReactNode;
  };
}>;

export type FluidTabBarProps = Readonly<{
  state: {
    index: number;
    routes: readonly TabRoute[];
  };
  descriptors: Record<string, TabDescriptor>;
  emitter: {
    emit: (options: {
      type: "tabPress" | "tabLongPress";
      target: string;
      canPreventDefault?: boolean;
    }) => object;
  };
  navigateToTab: (routeKey: string) => void;
  insets: { bottom: number };
}>;

export const FluidTabBar = ({
  state,
  descriptors,
  emitter,
  navigateToTab,
  insets,
}: FluidTabBarProps) => {
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);
  const reducedMotion = useReducedMotion();
  const [barWidth, setBarWidth] = useState(0);

  const tabCount = state.routes.length;
  const tabWidth = tabCount > 0 ? barWidth / tabCount : 0;
  const indicatorX = useSharedValue(0);

  useEffect(() => {
    if (tabWidth <= 0) return;
    const targetX = state.index * tabWidth;
    if (reducedMotion) {
      indicatorX.set(targetX);
      return;
    }
    indicatorX.set(
      withSpring(targetX, {
        damping: 20,
        stiffness: 240,
        mass: 0.85,
      }),
    );
  }, [indicatorX, reducedMotion, state.index, tabWidth]);

  const indicatorStyle = useAnimatedStyle(() => ({
    width: Math.max(tabWidth - 12, 0),
    transform: [{ translateX: indicatorX.value + 6 }],
  }));

  return (
    <View
      className="bg-bg px-4 pt-1.5"
      style={{ paddingBottom: Math.max(insets.bottom, 10) }}
    >
      <View
        onLayout={(event) => setBarWidth(event.nativeEvent.layout.width)}
        className="relative flex-row items-center rounded-3xl border border-border bg-surface py-1.5"
      >
        {tabWidth > 0 ? (
          <Animated.View
            pointerEvents="none"
            className="absolute bottom-1.5 top-1.5 rounded-2xl border border-gold/30 bg-primary-container"
            style={indicatorStyle}
          />
        ) : null}

        {state.routes.map((route, index) => {
          const descriptor = descriptors[route.key];
          const options = descriptor?.options;
          const isFocused = state.index === index;
          const label =
            typeof options?.title === "string" ? options.title : route.name;
          const iconColor = isFocused
            ? palette.onPrimaryContainer
            : palette.muted;

          const onPress = () => {
            const event = emitter.emit({
              type: "tabPress",
              target: route.key,
              canPreventDefault: true,
            });
            const defaultPrevented =
              "defaultPrevented" in event && event.defaultPrevented === true;
            if (!isFocused && !defaultPrevented) {
              navigateToTab(route.key);
            }
          };

          const onLongPress = () => {
            emitter.emit({
              type: "tabLongPress",
              target: route.key,
            });
          };

          return (
            <AnimatedPressable
              key={route.key}
              containerClassName="flex-1"
              accessibilityRole="tab"
              accessibilityState={{ selected: isFocused }}
              accessibilityLabel={options?.tabBarAccessibilityLabel ?? label}
              onPress={onPress}
              onLongPress={onLongPress}
              className="min-h-12 items-center justify-center gap-1 rounded-2xl px-1 py-1.5"
            >
              {options?.tabBarIcon
                ? options.tabBarIcon({
                    focused: isFocused,
                    color: iconColor,
                    size: 20,
                  })
                : null}
              <Text
                numberOfLines={1}
                className={cn(
                  "text-xs",
                  isFocused
                    ? "font-bold text-on-primary-container"
                    : "font-medium text-muted",
                )}
              >
                {label}
              </Text>
            </AnimatedPressable>
          );
        })}
      </View>
    </View>
  );
};
