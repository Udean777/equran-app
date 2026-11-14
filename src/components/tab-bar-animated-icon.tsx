import { type ReactNode, useEffect } from "react";
import Animated, {
  useAnimatedStyle,
  useReducedMotion,
  useSharedValue,
  withSpring,
  withTiming,
} from "react-native-reanimated";

type Props = Readonly<{
  focused: boolean;
  children: ReactNode;
}>;

export const TabBarAnimatedIcon = ({ focused, children }: Props) => {
  const reducedMotion = useReducedMotion();
  const scale = useSharedValue(focused ? 1.05 : 1);

  useEffect(() => {
    const target = focused ? 1.05 : 1;
    if (reducedMotion) {
      scale.set(target);
      return;
    }
    if (focused) {
      scale.set(
        withSpring(target, {
          damping: 16,
          stiffness: 260,
          mass: 0.75,
        }),
      );
      return;
    }
    scale.set(withTiming(target, { duration: 140 }));
  }, [focused, reducedMotion, scale]);

  const animatedStyle = useAnimatedStyle(() => ({
    transform: [{ scale: scale.value }],
  }));

  return <Animated.View style={animatedStyle}>{children}</Animated.View>;
};
