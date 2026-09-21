import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// La clave con la que se firma lo que va a Google Play. Vive fuera del repo y
// las contraseñas quedan en android/key.properties, que está ignorado en dos
// .gitignore: no se sube nunca. Cómo generarla está en PUBLICAR_ANDROID.md.
val clavesDeFirma = Properties().apply {
    val archivo = rootProject.file("key.properties")
    if (archivo.exists()) archivo.inputStream().use { load(it) }
}
val hayClavePropia = clavesDeFirma.getProperty("storeFile") != null

android {
    namespace = "com.sebastianperez.guardian_templo"
    // Clavados, no heredados de la version de Flutter que haya instalada. El
    // targetSdk es lo que Play audita: no puede moverse solo porque alguien
    // actualizo Flutter.
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.sebastianperez.guardian_templo"
        // Fijo, no heredado: google_mobile_ads pide 23 o mas y
        // flutter.minSdkVersion cambia con la version del SDK de Flutter.
        minSdk = maxOf(23, flutter.minSdkVersion)
        targetSdk = 36
        // Salen de la linea `version:` de pubspec.yaml, que es la unica
        // fuente. Android lleva su propia cuenta de builds: se le pasa
        // --build-number al armar el AAB.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hayClavePropia) {
            create("subida") {
                storeFile = file(clavesDeFirma.getProperty("storeFile"))
                storePassword = clavesDeFirma.getProperty("storePassword")
                keyAlias = clavesDeFirma.getProperty("keyAlias")
                keyPassword = clavesDeFirma.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            if (hayClavePropia) {
                signingConfig = signingConfigs.getByName("subida")
            } else {
                // Sin key.properties se firma con las claves de debug, para que
                // `flutter run --release` ande en cualquier maquina. Google Play
                // rechaza un AAB asi, y ese es justamente el punto: que falle en
                // la subida y no que salga publicado sin firmar como corresponde.
                logger.warn(
                    "AVISO: no hay android/key.properties, se firma con las " +
                    "claves de debug. Esto NO sirve para Google Play. " +
                    "Ver PUBLICAR_ANDROID.md.")
                signingConfig = signingConfigs.getByName("debug")
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}
