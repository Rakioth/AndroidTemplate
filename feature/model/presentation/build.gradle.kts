plugins {
    id(Plugins.MODULE_PRESENTATION)
}

android {
    namespace = "${Apps.APPLICATION_ID}.feature.model.presentation"
}

dependencies {
    implementation(project(":core:data"))
    implementation(project(":core:domain"))
    implementation(project(":core:presentation"))
    implementation(project(":feature:model:data"))
    implementation(project(":feature:model:domain"))
}