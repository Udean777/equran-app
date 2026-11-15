import type { ExpoConfig } from "expo/config";

const config: ExpoConfig = {
  name: "Qurva RN",
  slug: "qurva-rn",
  scheme: "qurva",
  version: "0.1.0",
  orientation: "portrait",
  icon: "./assets/images/icon.png",
  userInterfaceStyle: "automatic",
  ios: {
    bundleIdentifier: "id.ssajudn.qurva.rn",
    supportsTablet: false,
    icon: "./assets/images/icon.png",
  },
  android: {
    package: "id.ssajudn.qurva.rn",
    adaptiveIcon: {
      foregroundImage: "./assets/images/android-icon-foreground.png",
      backgroundImage: "./assets/images/android-icon-background.png",
      backgroundColor: "#062214",
      monochromeImage: "./assets/images/android-icon-monochrome.png",
    },
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
    [
      "expo-build-properties",
      {
        android: {
          enableMinifyInReleaseBuilds: true,
          enableShrinkResourcesInReleaseBuilds: true,
          enablePngCrunchInReleaseBuilds: true,
          useLegacyPackaging: true,
          gifEnabled: false,
          webpEnabled: false,
          buildArchs: ["arm64-v8a", "armeabi-v7a"],
        },
      },
    ],
    "./plugins/with-android-size-optimization",
    ["expo-audio", { enableBackgroundPlayback: true }],
    [
      "expo-notifications",
      {
        icon: "./assets/images/notification-icon.png",
        color: "#1A5C38",
      },
    ],
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
        imageWidth: 180,
        resizeMode: "contain",
        backgroundColor: "#062214",
      },
    ],
    // Aktifkan saat fase widget:
    // ['expo-widgets', { enableAndroid: true, widgets: [{ name: 'ShalatWidget', displayName: 'Jadwal Shalat' }] }],
  ],
  experiments: { typedRoutes: true },
};

export default config;
