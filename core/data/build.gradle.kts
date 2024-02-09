plugins {
    id(Plugins.MODULE_DATA)
}

android {
    namespace = "${Apps.APPLICATION_ID}.core.data"
}

dependencies {
    implementation(project(":core:domain"))
}