plugins {
    id(Plugins.MODULE_DATA)
    id(Plugins.RETROFIT)
}

android {
    namespace = "${Apps.APPLICATION_ID}.feature.model.data"
}

dependencies {
    implementation(project(":core:data"))
    implementation(project(":core:domain"))
    implementation(project(":feature:model:domain"))
}