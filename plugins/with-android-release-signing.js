const { withAppBuildGradle } = require("expo/config-plugins");

const RELEASE_SIGNING_CONFIG = `        release {
            def storeFilePath = findProperty('QURVA_UPLOAD_STORE_FILE')
            if (storeFilePath) {
                storeFile file(storeFilePath)
                storePassword findProperty('QURVA_UPLOAD_STORE_PASSWORD')
                keyAlias findProperty('QURVA_UPLOAD_KEY_ALIAS')
                keyPassword findProperty('QURVA_UPLOAD_KEY_PASSWORD')
            }
        }`;

const RELEASE_SIGNING_SELECTION =
  "signingConfig findProperty('QURVA_UPLOAD_STORE_FILE') ? signingConfigs.release : signingConfigs.debug";

/**
 * Release builds are signed with the upload keystore when its properties are
 * passed (`-PQURVA_UPLOAD_STORE_FILE=...`), so CI produces a Play-ready AAB.
 * Without them the build falls back to the debug keystore, keeping local
 * `assembleRelease` usable.
 */
const withAndroidReleaseSigning = (config) =>
  withAppBuildGradle(config, (mod) => {
    if (mod.modResults.contents.includes("QURVA_UPLOAD_STORE_FILE")) {
      return mod;
    }

    let contents = mod.modResults.contents;

    contents = contents.replace(
      /(\n\s*keyPassword 'android'\n\s*\})/,
      `$1\n${RELEASE_SIGNING_CONFIG}`,
    );

    contents = contents.replace(
      /\/\/ Caution! In production, you need to generate your own keystore file\.\n\s*\/\/ see https:\/\/reactnative\.dev\/docs\/signed-apk-android\.\n\s*signingConfig signingConfigs\.debug/,
      RELEASE_SIGNING_SELECTION,
    );

    mod.modResults.contents = contents;
    return mod;
  });

module.exports = withAndroidReleaseSigning;
