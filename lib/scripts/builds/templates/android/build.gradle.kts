plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.rfOnline.white_label"
    compileSdk = flutter.compileSdkVersion
    // ndkVersion = flutter.ndkVersion
    ndkVersion = "29.0.13113456"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "{{namespace}}"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        resValue("string", "application_name", "{{appName}}")
    }

    signingConfigs {
        {{#signingConfigs}}
        {{name}} {
            keyAlias '{{keyAlias}}'
            keyPassword '{{keyPassword}}'
            storeFile file('{{storeFile}}')
            storePassword '{{storePassword}}'
        }
        {{/signingConfigs}}
    }

    buildTypes {
      {{#buildTypes}}
        {{name}} {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            // signingConfig = signingConfigs.debug
            isMinifyEnabled = {{isMinifyEnabled}}
            isShrinkResources = {{isShrinkResources}}
            {{resValue}}
            signingConfig = {{signingConfig}}
        }
      {{/buildTypes}}
    }
}

flutter {
    source = "../.."
}

dependencies {
    {{#dependencies}}
    {{name}} '{{value}}'
    {{/dependencies}}
}
