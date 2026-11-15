# Release

Releases are a deliberate manual dispatch of `.github/workflows/release.yml`. There is no
`eas build` path.

## Run a release

1. GitHub, Actions, **Release**, Run workflow, from `main`.
2. Choose `bump_type`: `patch`, `minor`, `major`, or `custom` (with `custom_version`).
3. The workflow publishes a GitHub Release with:
   - a signed **AAB** for Google Play
   - two signed split **APKs**: `arm64-v8a` and `armeabi-v7a`

## Versioning

- The version is derived from the latest `v*` tag and must be newer than it.
- Flutter-era metadata such as `v0.6.0+7` is stripped, so the RN line continues at `0.7.0`.
- `versionCode = major*10000 + minor*100 + patch`.
- The version is written to `android/app/build.gradle` during the run.

## Signing

- `plugins/with-android-release-signing.js` reads keystore values from `-PQURVA_UPLOAD_*`
  Gradle properties and enables the v2 and v3 APK signature schemes.
- The keystore only exists in four repository secrets, all prefixed `ANDROID_`.
- A release task without those properties is **refused**. It never falls back to the debug keystore.
- CI then checks every artifact: zipalign, absence of the debug certificate, and v2/v3 signatures.

## Size optimisation

`plugins/with-android-size-optimization.js` applies the shrinking settings. Rerun
`bunx expo prebuild` after editing either plugin.
