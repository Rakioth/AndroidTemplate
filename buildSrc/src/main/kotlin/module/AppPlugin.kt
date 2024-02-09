package module

import com.android.build.gradle.internal.dsl.BaseAppModuleExtension
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.kotlin.dsl.dependencies
import org.gradle.kotlin.dsl.getByType
import util.configAndroid
import util.configCompose
import util.implementation

class AppPlugin : Plugin<Project> {

    override fun apply(project: Project) {
        with(project) {
            pluginManager.apply {
                apply(Plugins.ANDROID_APPLICATION)
                apply(Plugins.KOTLIN_ANDROID)
                apply(Plugins.COMPOSE)
                apply(Plugins.HILT)
                apply(Plugins.ANDROID_JUNIT)
            }

            extensions.getByType<BaseAppModuleExtension>().apply {
                namespace = Apps.APPLICATION_ID

                defaultConfig {
                    applicationId             = Apps.APPLICATION_ID
                    targetSdk                 = Apps.TARGET_SDK
                    versionCode               = Apps.VERSION_CODE
                    versionName               = Apps.VERSION_NAME
                    testInstrumentationRunner = Apps.JUNIT_INSTRUMENTATION_RUNNER

                    vectorDrawables {
                        useSupportLibrary = true
                    }
                }

                buildTypes {
                    release {
                        isMinifyEnabled   = Apps.IS_MINIFY_ENABLED
                        isShrinkResources = Apps.IS_SHRINK_RESOURCES
                        proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"))
                    }
                }

                this.configAndroid()
                this.configCompose()
            }

            dependencies {
                implementation(Libs.COMPOSE_ACTIVITY)
                implementation(Libs.SPLASH_SCREEN)
            }
        }
    }

}