plugins {
    id(Plugins.MODULE_DOMAIN)
}

android {
    namespace = "${Apps.APPLICATION_ID}.feature.model.domain"
}

dependencies {
    implementation(project(":core:domain"))
}