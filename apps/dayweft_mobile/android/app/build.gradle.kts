import java.util.Properties
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val signingFile = rootProject.file("key.properties")
val releaseRequested = gradle.startParameter.taskNames.any { it.contains("release", ignoreCase = true) }
val uploadKey = Properties().apply {
    if (signingFile.isFile) signingFile.inputStream().use { load(it) }
}
if (releaseRequested) {
    require(signingFile.isFile) { "Release signing is not configured. See docs/RELEASE.md; debug signing is forbidden." }
    for (name in listOf("storeFile", "storePassword", "keyAlias", "keyPassword")) {
        require(!uploadKey.getProperty(name).isNullOrBlank()) { "Release signing configuration is incomplete." }
    }
    require(rootProject.file(uploadKey.getProperty("storeFile")).isFile) { "Release upload keystore was not found." }
    require(uploadKey.getProperty("keyAlias") != "androiddebugkey") { "The Android debug key cannot sign a production release." }
}

android {
    namespace = "app.dayweft.dayweft_mobile"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // Provisional existing identity; owner confirmation is required before Play registration.
        applicationId = "app.dayweft.dayweft_mobile"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (signingFile.isFile) {
            create("upload") {
                storeFile = uploadKey.getProperty("storeFile")?.let { rootProject.file(it) }
                storePassword = uploadKey.getProperty("storePassword")
                keyAlias = uploadKey.getProperty("keyAlias")
                keyPassword = uploadKey.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.findByName("upload")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_17)
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
