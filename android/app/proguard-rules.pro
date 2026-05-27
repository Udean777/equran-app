##############################################
# ProGuard Rules — equran-app
# Pastikan R8 tidak strip class yang diakses
# via reflection oleh Flutter dan plugin-plugin.
##############################################

# ─── Flutter Core ─────────────────────────
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.util.** { *; }
-dontwarn io.flutter.**

# ─── Dart VM Entrypoints ──────────────────
# Jangan obfuscate nama class yang dipanggil dari Dart
-keep class * extends io.flutter.embedding.engine.plugins.FlutterPlugin { *; }
-keep class * implements io.flutter.plugin.common.MethodCallHandler { *; }
-keep class * implements io.flutter.plugin.common.EventChannel$StreamHandler { *; }

# ─── Kotlin ───────────────────────────────
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings {
    <fields>;
}
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}

# ─── Hive CE ──────────────────────────────
# Hive menggunakan reflection untuk membaca TypeAdapters
-keep class com.hivedb.** { *; }
-keep class * extends com.hivece.** { *; }
# Jaga semua class yang di-annotate @HiveType dan @HiveField
-keepclassmembers class * {
    @com.hivedb.annotations.HiveField *;
    @com.hivedb.annotations.HiveType *;
}
-dontwarn com.hivedb.**

# ─── android_alarm_manager_plus ──────────
-keep class dev.fluttercommunity.plus.androidalarmmanager.** { *; }
-dontwarn dev.fluttercommunity.plus.androidalarmmanager.**

# ─── just_audio ───────────────────────────
-keep class com.ryanheise.just_audio.** { *; }
-dontwarn com.ryanheise.**

# ─── audio_service ────────────────────────
-keep class com.ryanheise.audio_service.** { *; }
-dontwarn com.ryanheise.audio_service.**

# ─── audio_session ────────────────────────
-keep class com.ryanheise.audio_session.** { *; }
-dontwarn com.ryanheise.audio_session.**

# ─── flutter_local_notifications ──────────
-keep class com.dexterous.** { *; }
-dontwarn com.dexterous.**

# ─── Gson TypeToken (dipakai flutter_local_notifications) ─────────────────
# R8 strip generic type parameter dari TypeToken anonymous subclass → crash
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken { *; }
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# ─── geolocator ───────────────────────────
-keep class com.baseflow.geolocator.** { *; }
-dontwarn com.baseflow.geolocator.**

# ─── geocoding ────────────────────────────
-keep class com.baseflow.geocoding.** { *; }
-dontwarn com.baseflow.geocoding.**

# ─── flutter_compass ──────────────────────
-keep class com.hemanthraj.fluttercompass.** { *; }
-dontwarn com.hemanthraj.**

# ─── timezone ─────────────────────────────
# timezone package membaca database dari assets
-keep class org.joda.** { *; }
-dontwarn org.joda.**

# ─── Dio (HTTP client) ────────────────────
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# ─── JSON Serialization ───────────────────
# Freezed & json_serializable generate code yang diakses via reflection
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# ─── Google Play Core (App Bundles) ───────
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# ─── AndroidX ────────────────────────────
-keep class androidx.** { *; }
-dontwarn androidx.**

# ─── Hapus log di release build ───────────
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int d(...);
    public static int i(...);
}

# ─── Optimasi umum ───────────────────────
-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-verbose
