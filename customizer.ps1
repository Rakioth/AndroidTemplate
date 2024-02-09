$ErrorActionPreference = "Stop"

if ($args.Count -lt 2) {
    Write-Host @"
Usage:
  customizer <your.package.name> <YourAppName>

"@
    exit 2
}

$PACKAGE_NAME      = $args[0]
$PACKAGE_NAME_PATH = $PACKAGE_NAME.Replace(".", "\")
$APP_NAME          = $args[1..($args.Count - 1)] -join " "
$APP_NAME_NO_SPACE = $APP_NAME.Replace(" ", "")

$red    = "$( [char]27 )[0;31m"
$green  = "$( [char]27 )[0;32m"
$purple = "$( [char]27 )[38;2;206;62;214m"
$violet = "$( [char]27 )[38;2;198;152;242m"
$normal = "$( [char]27 )[0m"

$italic  = "$( [char]27 )[3m"
$regular = "$( [char]27 )[0m"

function Get-Emoji {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Unicode
    )

    return [System.Char]::ConvertFromUtf32([System.Convert]::toInt32($Unicode, 16))
}

function Write-Error {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Message
    )

    Write-Host "   $( $red )$( Get-Emoji -Unicode "276F" )$( $normal ) $Message"
}

function Write-Success {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Message
    )

    Write-Host "   $( $green )$( Get-Emoji -Unicode "276F" )$( $normal ) $Message"
}

Push-Location -Path $PSScriptRoot

Write-Host "$( $purple )$( Get-Emoji -Unicode "256D" )$( (Get-Emoji -Unicode "2500") * 50 )$( Get-Emoji -Unicode "256E" )$( $normal )"
Write-Host "$( $purple )$( Get-Emoji -Unicode "2502" )$( $normal )          $( Get-Emoji -Unicode "1FAE7" ) $( $italic )Android Template Customizer$( $regular )          $( $purple )$( Get-Emoji -Unicode "2502" )$( $normal )"
Write-Host "$( $purple )$( Get-Emoji -Unicode "2570" )$( (Get-Emoji -Unicode "2500") * 50 )$( Get-Emoji -Unicode "256F" )$( $normal )"

Write-Host "$( Get-Emoji -Unicode "1F4E6" ) $( $violet )Organizing$( $normal ) files under: $( $purple ).\src\main\kotlin\$PACKAGE_NAME_PATH$( $normal )"
Get-ChildItem -Directory -Recurse | Where-Object { $_.FullName -notmatch 'buildSrc' -and $_.FullName -like '*\src\main' } | ForEach-Object {
    $Target = Join-Path -Path $_.FullName -ChildPath "kotlin\$PACKAGE_NAME_PATH"

    try {
        New-Item -ItemType Directory -Path $Target -Force | Out-Null
        $RelativeTarget = Resolve-Path -Relative $Target
        Write-Success "Created directory $RelativeTarget"

        $Src = "$( $_.FullName )\kotlin\android\template"
        if (Test-Path -Path $Src) {
            $RelativeSrc = Resolve-Path -Relative $Src
            Move-Item -Path "$Src\*" -Destination $Target -Force
            Write-Success "Moved files from $RelativeSrc to $RelativeTarget"
            Remove-Item -Path "$( $_.FullName )\kotlin\android" -Recurse -Force
            Write-Success "Removed old $RelativeSrc"
        }
    } catch {
        Write-Error "Error processing $($_.FullName)"
    }
}

Write-Host "$( Get-Emoji -Unicode "1F527" ) $( $violet )Updating$( $normal ) package declarations and imports: $( $purple )$PACKAGE_NAME$( $normal )"
try {
    Get-ChildItem -File -Filter "*.kt" -Recurse | ForEach-Object {
        (Get-Content -Path $_.FullName).Replace("android.template", $PACKAGE_NAME) | Set-Content -Path $_.FullName
    }
    Write-Success "Updated declarations"
} catch {
    Write-Error "Failed to update declarations"
}

Write-Host "$( Get-Emoji -Unicode "1F4DD" ) $( $violet )Renaming$( $normal ) application to: $( $purple )$APP_NAME$( $normal )"
try {
    Get-ChildItem -File -Include "settings.gradle.kts", "strings.xml" -Recurse | ForEach-Object {
        (Get-Content -Path $_.FullName).Replace("Android Template", $APP_NAME) | Set-Content -Path $_.FullName
    }
    Write-Success "Replaced app name in XML and Gradle files"

    Get-ChildItem -File -Include "*.kt", "*.xml" -Recurse | ForEach-Object {
        (Get-Content -Path $_.FullName).Replace("AndroidTemplate", $APP_NAME_NO_SPACE) | Set-Content -Path $_.FullName
    }
    Write-Success "Replaced 'AndroidTemplate' with '$APP_NAME_NO_SPACE'"
} catch {
    Write-Error "Failed to rename strings"
}

try {
    $AppFile = Get-ChildItem -File -Recurse -Filter "AndroidTemplateApplication.kt" | Select-Object -First 1
    if ($AppFile) {
        $NewAppFile = $AppFile.FullName.Replace("AndroidTemplateApplication.kt", "${APP_NAME_NO_SPACE}Application.kt")
        Rename-Item -Path $AppFile.FullName -NewName $NewAppFile
        Write-Success "Renamed main application file to $( Split-Path -Path $NewAppFile -Leaf )"
    } else {
        Write-Error "Main application file not found"
    }
} catch {
    Write-Error "Error renaming application file"
}

Write-Host "$( Get-Emoji -Unicode "1F5D1" )$( Get-Emoji -Unicode "FE0F" ) $( $violet )Cleaning$( $normal ) up template files"
try {
    Remove-Item -Path "README.md" -Force
    Write-Success "Removed README"
} catch {
    Write-Error "Failed to remove README"
}

try {
    Remove-Item -Path "customizer.sh", "customizer.ps1" -Force
    Write-Success "Removed customizer script"
} catch {
    Write-Error "Failed to remove customizer script"
}

try {
    Remove-Item -Path ".git" -Recurse -Force
    Write-Success "Removed .git directory"
} catch {
    Write-Error "Failed to remove .git directory"
}

try {
    Get-ChildItem -File -Include "*.gitkeep" -Recurse | Remove-Item -Force
    Write-Success "Removed .gitkeep files"
} catch {
    Write-Error "Failed to remove .gitkeep files"
}

Pop-Location

Write-Host
Write-Host "$( Get-Emoji -Unicode "1F389" ) Customization complete!"
Write-Host
