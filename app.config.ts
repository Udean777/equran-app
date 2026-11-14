import type { ExpoConfig } from "expo/config";

const config: ExpoConfig = {
  name: "Qurva RN",
  slug: "qurva-rn",
  scheme: "qurva",
  version: "0.1.0",
  orientation: "portrait",
  userInterfaceStyle: "automatic",
  ios: {
    bundleIdentifier: "id.ssajudn.qurva.rn",
    supportsTablet: false,
  },
  android: {
    package: "id.ssajudn.qurva.rn",
    permissions: [
      "android.permission.SCHEDULE_EXACT_ALARM",
      "android.permission.USE_EXACT_ALARM",
      "android.permission.USE_FULL_SCREEN_INTENT",
      "android.permission.RECEIVE_BOOT_COMPLETED",
    ],
  },
  plugins: [
    "expo-router",
    "expo-localization",
    ["expo-audio", { enableBackgroundPlayback: true }],
    ["expo-notifications", { color: "#2DD4BF" }],
    [
      "expo-location",
      {
        locationWhenInUsePermission:
          "Qurva memakai lokasi untuk arah kiblat dan jadwal shalat.",
      },
    ],
    [
      "expo-font",
      {
        fonts: [
          "./assets/fonts/Amiri-Regular.ttf",
          "./assets/fonts/Amiri-Bold.ttf",
          "./assets/fonts/KFGQPCUthmanicScriptHAFS.otf",
        ],
      },
    ],
    [
      "expo-splash-screen",
      {
        image: "./assets/images/splash-icon.png",
        imageWidth: 160,
        resizeMode: "contain",
        backgroundColor: "#0B1215",
      },
    ],
    // Aktifkan saat fase widget:
    // ['expo-widgets', { enableAndroid: true, widgets: [{ name: 'ShalatWidget', displayName: 'Jadwal Shalat' }] }],
  ],
  experiments: { typedRoutes: true },
};

export default config;
