plugins {
    id("com.android.application")
}

android {
    namespace = "com.oldgl4es.plugin"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.oldgl4es.plugin"
        minSdk = 26
        targetSdk = 34
        versionCode = 1
        versionName = "0.1.0"

        ndk {
            abiFilters += listOf("arm64-v8a", "armeabi-v7a")
        }
    }

    // The launcher loads the renderer from nativeLibraryDir, so the .so files
    // must be extracted to disk instead of being mapped from inside the APK.
    packaging {
        jniLibs {
            useLegacyPackaging = true
            keepDebugSymbols += "**/*.so"
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = false
        }
    }
}
