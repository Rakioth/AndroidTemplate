plugins {
    id(Plugins.MODULE_APP)
}

dependencies {
    implementation(project(":core:domain"))
    implementation(project(":core:presentation"))
    implementation(project(":feature:model:presentation"))
}