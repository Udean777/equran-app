const { withAppBuildGradle } = require("expo/config-plugins");

const RESOURCE_CONFIG_LINE = '        resourceConfigurations += ["id", "en"]';

const ABI_SPLITS_BLOCK = `    def isBundleTask = gradle.startParameter.taskNames.any { it.toLowerCase().contains("bundle") }
    splits {
        abi {
            reset()
            enable !isBundleTask
            universalApk false
            include "armeabi-v7a", "arm64-v8a"
        }
    }`;

const withAndroidSizeOptimization = (config) =>
  withAppBuildGradle(config, (mod) => {
    let contents = mod.modResults.contents;

    if (!contents.includes("resourceConfigurations")) {
      contents = contents.replace(
        /(versionName\s+"[^"]+")/,
        `$1\n${RESOURCE_CONFIG_LINE}`,
      );
    }

    if (!contents.includes("splits {")) {
      contents = contents.replace(
        /(\n\s*buildTypes\s*\{)/,
        `\n${ABI_SPLITS_BLOCK}$1`,
      );
    }

    mod.modResults.contents = contents;
    return mod;
  });

module.exports = withAndroidSizeOptimization;
