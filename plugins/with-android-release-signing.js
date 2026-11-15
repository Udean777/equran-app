const { withAppBuildGradle } = require("expo/config-plugins");

const RELEASE_SIGNING_GUARD = `def qurvaReleaseTaskRequested = gradle.startParameter.taskNames.any { it.toLowerCase().contains("release") }
if (qurvaReleaseTaskRequested && !findProperty('QURVA_UPLOAD_STORE_FILE')) {
    throw new GradleException('Release build refused: pass -PQURVA_UPLOAD_STORE_FILE, -PQURVA_UPLOAD_STORE_PASSWORD, -PQURVA_UPLOAD_KEY_ALIAS and -PQURVA_UPLOAD_KEY_PASSWORD. A debug-signed APK/AAB cannot be installed reliably or uploaded to Play.')
}

android {`;

const RELEASE_SIGNING_CONFIG = `        release {
            def storeFilePath = findProperty('QURVA_UPLOAD_STORE_FILE')
            if (storeFilePath) {
                storeFile file(storeFilePath)
                storePassword findProperty('QURVA_UPLOAD_STORE_PASSWORD')
                keyAlias findProperty('QURVA_UPLOAD_KEY_ALIAS')
                keyPassword findProperty('QURVA_UPLOAD_KEY_PASSWORD')
            }
            // Explicit on purpose: v1 keeps old Android installs working, v2/v3 are
            // required from Android 11, v4 enables incremental adb installs.
            enableV1Signing true
            enableV2Signing true
            enableV3Signing true
            enableV4Signing true
        }`;

/**
 * Release builds are signed with the upload keystore passed as
 * `-PQURVA_UPLOAD_*` properties, and refused when it is missing — a
 * debug-signed artifact installs poorly outside Play and cannot be uploaded.
 */
const withAndroidReleaseSigning = (config) =>
  withAppBuildGradle(config, (mod) => {
    if (mod.modResults.contents.includes("QURVA_UPLOAD_STORE_FILE")) {
      return mod;
    }

    let contents = mod.modResults.contents;

    contents = contents.replace(/^android \{$/m, RELEASE_SIGNING_GUARD);

    contents = contents.replace(
      /(\n\s*keyPassword 'android'\n\s*\})/,
      `$1\n${RELEASE_SIGNING_CONFIG}`,
    );

    contents = contents.replace(
      /\/\/ Caution! In production, you need to generate your own keystore file\.\n\s*\/\/ see https:\/\/reactnative\.dev\/docs\/signed-apk-android\.\n\s*signingConfig signingConfigs\.debug/,
      "signingConfig signingConfigs.release",
    );

    mod.modResults.contents = contents;
    return mod;
  });

module.exports = withAndroidReleaseSigning;
