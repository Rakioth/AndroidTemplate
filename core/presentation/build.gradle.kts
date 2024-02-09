plugins {
    id(Plugins.MODULE_PRESENTATION)
}

android {
    namespace = "${Apps.APPLICATION_ID}.core.presentation"
}

dependencies {
    implementation(project(":core:data"))
    implementation(project(":core:domain"))
}