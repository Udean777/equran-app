const { getDefaultConfig } = require("expo/metro-config");
const { withNativeWind } = require("nativewind/metro");

const config = getDefaultConfig(__dirname);

config.transformer = {
  ...config.transformer,
  getTransformOptions: async () => ({
    transform: {
      experimentalImportSupport: false,
      inlineRequires: true,
    },
  }),
  minifierConfig: {
    ...config.transformer?.minifierConfig,
    compress: {
      ...config.transformer?.minifierConfig?.compress,
      drop_console: true,
      passes: 2,
    },
  },
};

module.exports = withNativeWind(config, { input: "./global.css" });
