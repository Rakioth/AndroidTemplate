$ErrorActionPreference = "Stop"

# Arguments
if ($args.Count -lt 2) {
    Write-Host @"
Usage:
  customizer <your.package.name> <YourAppName>

"@
    exit 1
}

# Script variables
$PACKAGE         = $args[0]
$APPNAME         = $args[1..($args.Count - 1)] -join " "
$SUBDIR          = $PACKAGE.Replace(".", "\")
$NOSPACE_APPNAME = $APPNAME.Replace(" ", "")

# Script colors
$PURPLE = "$( [char]27 )[38;2;206;62;214m"
$VIOLET = "$( [char]27 )[38;2;198;152;242m"
$RESET  = "$( [char]27 )[0m"

# Script text styles
$ITALIC = "$( [char]27 )[3m"
$NORMAL = "$( [char]27 )[0m"

# Helper
function Get-Emoji {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Unicode
    )

    return [System.Char]::ConvertFromUtf32([System.Convert]::toInt32($Unicode, 16))
}

# Set the script root directory
Set-Location -Path $PSScriptRoot

# Move files to the correct package
Write-Host "$( Get-Emoji -Unicode "1F4E6" ) $( $VIOLET )Moving$( $RESET ) files to $( $PURPLE ).\src\main\kotlin\$SUBDIR$( $RESET )"
Get-ChildItem -Directory -Recurse | Where-Object { $_.FullName -notmatch 'buildSrc' -and $_.FullName -like '*\src\main' } | ForEach-Object {
    $destDir = Join-Path -Path $_.FullName -ChildPath "kotlin\$SUBDIR"
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    Move-Item -Path "$( $_.FullName )\kotlin\android\template\*" -Destination $destDir -Force
    Remove-Item -Path "$( $_.FullName )\kotlin\android" -Recurse -Force
}

# Replace package and imports
Write-Host "$( Get-Emoji -Unicode "1F69B" ) $( $VIOLET )Replacing$( $RESET ) package and imports to $( $PURPLE )$PACKAGE$( $RESET )"
Get-ChildItem -File -Filter "*.kt" -Recurse | ForEach-Object {
    (Get-Content -Path $_.FullName).Replace("android.template", $PACKAGE) | Set-Content -Path $_.FullName
}

# Rename app name
Write-Host "$( Get-Emoji -Unicode "1F9F1" ) $( $VIOLET )Renaming$( $RESET ) app to $( $PURPLE )$APPNAME$( $RESET )"
Get-ChildItem -File -Include "settings.gradle.kts", "strings.xml" -Recurse | ForEach-Object {
    (Get-Content -Path $_.FullName).Replace("Android Template", $APPNAME) | Set-Content -Path $_.FullName
}
Get-ChildItem -File -Filter "*.xml" -Recurse | ForEach-Object {
    (Get-Content -Path $_.FullName).Replace("AndroidTemplate", $NOSPACE_APPNAME) | Set-Content -Path $_.FullName
}
Get-ChildItem -File -Filter "*.kt" -Recurse | ForEach-Object {
    (Get-Content -Path $_.FullName).Replace("AndroidTemplate", $NOSPACE_APPNAME) | Set-Content -Path $_.FullName
}
Get-ChildItem -File -Filter "AndroidTemplateApplication.kt" -Recurse | ForEach-Object {
    $newName = $_.FullName.Replace("AndroidTemplateApplication.kt", "${NOSPACE_APPNAME}Application.kt")
    Rename-Item -Path $_.FullName -NewName $newName
}

# Remove additional files
Write-Host "$( Get-Emoji -Unicode "1F9F9" ) $( $VIOLET )Removing$( $RESET ) additional files"
Remove-Item -Path "README.md", "customizer.sh", "customizer.ps1" -Force
Remove-Item -Path ".git" -Recurse -Force

Write-Host "$( $PURPLE )╭──────────────────────────────────────────────────╮$( $RESET )"
Write-Host "$( $PURPLE )│$( $RESET )                     $( $ITALIC )$( Get-Emoji -Unicode "1F389" ) Done!$( $NORMAL )                     $( $PURPLE )│$( $RESET )"
Write-Host "$( $PURPLE )╰──────────────────────────────────────────────────╯$( $RESET )"