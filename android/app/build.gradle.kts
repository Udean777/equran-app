import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "id.ssajudn.equran_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "id.ssajudn.equran_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    val keystorePropertiesFile = rootProject.file("key.properties")
    val keystoreProperties = Properties()
    if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    }

    signingConfigs {
        if (keystorePropertiesFile.exists()) {
            create("release") {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }

            // --- OPTIMASI: Aktifkan R8 code shrinking ---
            // isShrinkResources dimatikan karena R8 me-rename res/raw/*.ogg
            // sehingga custom notification sound tidak bisa di-resolve Android
            isMinifyEnabled = true
            isShrinkResources = false

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            // Debug build: matikan minify agar hot-reload tetap cepat
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    // --- OPTIMASI: Hapus resource language yang tidak diperlukan ---
    // Hanya simpan resource untuk locale yang dipakai app (id, en, ar)
    androidResources {
        localeFilters += listOf("id", "en", "ar", "in")
    }
}

flutter {
    source = "../.."
}

dependencies {
    // --- OPTIMASI: Gunakan desugar_jdk_libs_nio yang lebih ringan ---
    // Hanya tambahkan NIO APIs yang dibutuhkan just_audio, lebih kecil dari versi full
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs_nio:2.1.4")
}
