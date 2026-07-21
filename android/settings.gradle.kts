import java.util.Properties
import java.io.FileInputStream

pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "shorebirdpractice"
include(":app")

val flutterSdkPath = run {
    val properties = Properties()
    val localPropertiesFile = File(rootDir, "local.properties")
    if (localPropertiesFile.exists()) {
        properties.load(FileInputStream(localPropertiesFile))
    }
    properties.getProperty("flutter.sdk")
        ?: throw FileNotFoundException("flutter.sdk not set in local.properties")
}

apply(from = "$flutterSdkPath/packages/flutter_tools/gradle/flutter.gradle")
