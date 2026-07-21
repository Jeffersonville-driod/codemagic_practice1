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

// CI-Safe way to get flutter sdk
val flutterSdkPath = System.getenv("FLUTTER_ROOT") 
    ?: throw GradleException("FLUTTER_ROOT not found. Did you set up flutter-action?")

apply(from = "$flutterSdkPath/packages/flutter_tools/gradle/app_plugin_loader.gradle")
