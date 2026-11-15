import java.io.File
import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Prefer external protected location E:\DevTools\Signing\key.properties
val externalKeyProps = File("E:/DevTools/Signing/key.properties")
val localKeyProps = rootProject.file("key.properties")
val keystorePropertiesFile = if (externalKeyProps.exists()) externalKeyProps else localKeyProps

val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use { stream ->
        keystoreProperties.load(stream)
    }
}

android {
    namespace = "com.expensetracker.expense_tracker"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.expensetracker.expense_tracker"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val keyAliasProp = keystoreProperties["keyAlias"] as String?
            val keyPasswordProp = keystoreProperties["keyPassword"] as String?
            val storeFileProp = keystoreProperties["storeFile"] as String?
            val storePasswordProp = keystoreProperties["storePassword"] as String?

            if (storeFileProp.isNullOrBlank() || keyAliasProp.isNullOrBlank() || 
                storePasswordProp.isNullOrBlank() || keyPasswordProp.isNullOrBlank()) {
                throw GradleException(
                    "Release signing credentials missing. Expected key.properties at " +
                    "E:/DevTools/Signing/key.properties with storeFile, keyAlias, storePassword, and keyPassword."
                )
            }

            val storeFileObj = File(storeFileProp)
            val resolvedStoreFile = if (storeFileObj.isAbsolute) storeFileObj else rootProject.file(storeFileProp)

            if (!resolvedStoreFile.exists()) {
                throw GradleException("Release keystore file not found at: ${resolvedStoreFile.absolutePath}")
            }

            keyAlias = keyAliasProp
            keyPassword = keyPasswordProp
            storeFile = resolvedStoreFile
            storePassword = storePasswordProp
            enableV2Signing = true
            enableV3Signing = true
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
