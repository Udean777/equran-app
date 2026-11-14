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

jest.mock("expo-audio", () => ({
  setAudioModeAsync: jest.fn().mockResolvedValue(undefined),
  createAudioPlaylist: jest.fn(() => ({
    addListener: jest.fn(),
    play: jest.fn(),
    pause: jest.fn(),
    next: jest.fn(),
    previous: jest.fn(),
    skipTo: jest.fn(),
    clear: jest.fn(),
    add: jest.fn(),
    setActiveForLockScreen: jest.fn(),
    updateLockScreenMetadata: jest.fn(),
    clearLockScreenControls: jest.fn(),
  })),
}));

jest.mock("react-native-compass-heading", () => ({
  __esModule: true,
  default: {
    start: jest.fn(async () => true),
    stop: jest.fn(async () => undefined),
    hasCompass: jest.fn(async () => true),
  },
}));
