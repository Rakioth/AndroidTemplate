import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

object BuildConfig {
    const val ANDROID_GRADLE = "8.2.0"
    const val KOTLIN         = "1.9.0"
    const val JVM_TARGET     = "17"
}

plugins {
    `kotlin-dsl`
}

repositories {
    google()
    mavenCentral()
}

dependencies {
    implementation("com.android.tools.build:gradle:${BuildConfig.ANDROID_GRADLE}")
    implementation("org.jetbrains.kotlin:kotlin-gradle-plugin:${BuildConfig.KOTLIN}")
    implementation("com.squareup:javapoet:1.13.0")
}

tasks.withType<KotlinCompile> {
    kotlinOptions {
        jvmTarget = BuildConfig.JVM_TARGET
    }
}

gradlePlugin {
    plugins {
        register("library.android-junit") {
            id                  = "library.android-junit"
            implementationClass = "library.AndroidJUnitPlugin"
        }
        register("library.junit") {
            id                  = "library.junit"
            implementationClass = "library.JUnitPlugin"
        }
        register("library.compose") {
            id                  = "library.compose"
            implementationClass = "library.ComposePlugin"
        }
        register("library.hilt") {
            id                  = "library.hilt"
            implementationClass = "library.HiltPlugin"
        }
        register("library.retrofit") {
            id                  = "library.retrofit"
            implementationClass = "library.RetrofitPlugin"
        }
        register("library.room") {
            id                  = "library.room"
            implementationClass = "library.RoomPlugin"
        }
        register("module.app") {
            id                  = "module.app"
            implementationClass = "module.AppPlugin"
        }
        register("module.data") {
            id                  = "module.data"
            implementationClass = "module.DataPlugin"
        }
        register("module.domain") {
            id                  = "module.domain"
            implementationClass = "module.DomainPlugin"
        }
    }
}