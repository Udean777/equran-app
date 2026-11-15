import {
  type GestureResponderEvent,
  Pressable,
  type PressableProps,
} from "react-native";
import Animated, {
  useAnimatedStyle,
  useReducedMotion,
  useSharedValue,
  withSpring,
  withTiming,
} from "react-native-reanimated";

type AnimatedPressableProps = PressableProps &
  Readonly<{
    containerClassName?: string;
    pressScale?: number;
    pressOpacity?: number;
  }>;

export const AnimatedPressable = ({
  containerClassName,
  pressScale = 0.94,
  pressOpacity = 0.88,
  onPressIn,
  onPressOut,
  ...props
}: AnimatedPressableProps) => {
  const reducedMotion = useReducedMotion();
  const scale = useSharedValue(1);
  const opacity = useSharedValue(1);

  const animatedStyle = useAnimatedStyle(() => ({
    transform: [{ scale: scale.value }],
    opacity: opacity.value,
  }));

  const handlePressIn = (event: GestureResponderEvent) => {
    if (!reducedMotion) {
      scale.set(withTiming(pressScale, { duration: 90 }));
      opacity.set(withTiming(pressOpacity, { duration: 90 }));
    }
    onPressIn?.(event);
  };

  const handlePressOut = (event: GestureResponderEvent) => {
    if (!reducedMotion) {
      scale.set(withSpring(1, { damping: 10, stiffness: 320, mass: 0.7 }));
      opacity.set(withTiming(1, { duration: 140 }));
    }
    onPressOut?.(event);
  };

  return (
    <Animated.View className={containerClassName} style={animatedStyle}>
      <Pressable
        {...props}
        onPressIn={handlePressIn}
        onPressOut={handlePressOut}
      />
    </Animated.View>
  );
};
