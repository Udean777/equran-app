import type * as ReactNative from "react-native";

jest.mock("react-native-reanimated", () => {
  const { Image, ScrollView, Text, View } =
    jest.requireActual<typeof ReactNative>("react-native");

  const noopAnimation = {
    duration: () => noopAnimation,
    delay: () => noopAnimation,
    springify: () => noopAnimation,
  };

  return {
    __esModule: true,
    default: {
      View,
      Text,
      Image,
      ScrollView,
      createAnimatedComponent: <T>(component: T) => component,
    },
    FadeIn: noopAnimation,
    FadeInLeft: noopAnimation,
    FadeInRight: noopAnimation,
    FadeInUp: noopAnimation,
    FadeOut: noopAnimation,
    FadeOutLeft: noopAnimation,
    FadeOutRight: noopAnimation,
    FadeOutUp: noopAnimation,
    LinearTransition: noopAnimation,
    ReduceMotion: { System: "system", Always: "always", Never: "never" },
    ReducedMotionConfig: () => null,
    useSharedValue: <T>(initial: T) => ({
      value: initial,
      get: () => initial,
      set: () => undefined,
    }),
    useAnimatedStyle: (fn: () => Record<string, unknown>) => fn(),
    useReducedMotion: () => false,
    withTiming: <T>(toValue: T) => toValue,
    withSpring: <T>(toValue: T) => toValue,
  };
});
