package module

import com.android.build.gradle.LibraryExtension
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.kotlin.dsl.getByType
import util.configAndroid
import util.configBuildTypes
import util.configCompose

class PresentationPlugin : Plugin<Project> {

    override fun apply(project: Project) {
        with(project) {
            pluginManager.apply {
                apply(Plugins.ANDROID_LIBRARY)
                apply(Plugins.KOTLIN_ANDROID)
                apply(Plugins.COMPOSE)
                apply(Plugins.HILT)
                apply(Plugins.ANDROID_JUNIT)
            }

            extensions.getByType<LibraryExtension>().apply {
                this.configAndroid()
                this.configBuildTypes()
                this.configCompose()
            }
        }
    }

}