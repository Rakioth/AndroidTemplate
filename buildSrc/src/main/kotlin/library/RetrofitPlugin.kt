package library

import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.kotlin.dsl.dependencies
import util.implementation

class RetrofitPlugin : Plugin<Project> {

    override fun apply(project: Project) {
        with(project) {
            dependencies {
                implementation(Libs.RETROFIT)
                implementation(Libs.RETROFIT_CONVERTER)
            }
        }
    }

}
