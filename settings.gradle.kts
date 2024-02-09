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

rootProject.name = "Android Template"
include(":app")

include(":core:data")
include(":core:domain")
include(":core:presentation")

include(":feature:model:data")
include(":feature:model:domain")
include(":feature:model:presentation")