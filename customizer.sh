#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 2 ]]; then
	cat <<EOF
Usage:
  customizer <your.package.name> <YourAppName>

EOF
	exit 2
fi

PACKAGE_NAME=$1
PACKAGE_NAME_PATH=${PACKAGE_NAME//.//}
APP_NAME="${*:2}"
APP_NAME_NO_SPACE=${APP_NAME// /}

red='\033[0;31m'
green='\033[0;32m'
purple='\033[38;2;206;62;214m'
violet='\033[38;2;198;152;242m'
normal='\033[0m'

italic=$(tput sitm)
regular=$(tput ritm)

_log() {
	local -r text="${1-}"
	echo -e "$text"
}
_error() { _log "   ${red}❯${normal} $1"; }
_success() { _log "   ${green}❯${normal} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || {
	_error "Failed to change directory to script dir"
	exit 1
}

_log "${purple}╭──────────────────────────────────────────────────╮${normal}"
_log "${purple}│${normal}          🫧 ${italic}Android Template Customizer${regular}          ${purple}│${normal}"
_log "${purple}╰──────────────────────────────────────────────────╯${normal}"

_log "📦 ${violet}Organizing${normal} files under: ${purple}./src/main/kotlin/$PACKAGE_NAME_PATH${normal}"
find . -type d -path '*/src/main' ! -path '*/buildSrc/*' -print0 |
	while IFS= read -r -d '' dir; do
		target="$dir/kotlin/$PACKAGE_NAME_PATH"
		if mkdir -p "$target"; then
			_success "Created directory $target"
		else
			_error "Failed to create $target"
		fi

		src="$dir/kotlin/android/template"
		if [[ -d "$src" ]]; then
			if mv "$src/"* "$target/"; then
				_success "Moved files from $src to $target"
			else
				_error "Failed to move files from $src"
			fi

			if rm -rf "$dir/kotlin/android"; then
				_success "Removed old $src"
			else
				_error "Failed to remove $src"
			fi
		fi
	done

_log "🔧 ${violet}Updating${normal} package declarations and imports: ${purple}$PACKAGE_NAME${normal}"
if find . -type f -name "*.kt" -exec sed -i.bak "s/android.template/$PACKAGE_NAME/g" {} +; then
	_success "Updated declarations"
else
	_error "Failed to update declarations"
fi

_log "📝 ${violet}Renaming${normal} application to: ${purple}$APP_NAME${normal}"
if find . -type f \( -name "settings.gradle.kts" -o -name "strings.xml" \) -exec sed -i.bak "s/Android Template/$APP_NAME/g" {} +; then
	_success "Replaced app name in XML and Gradle files"
else
	_error "Failed to replace app name text"
fi

if find . -type f \( -name "*.xml" -o -name "*.kt" \) -exec sed -i.bak "s/AndroidTemplate/$APP_NAME_NO_SPACE/g" {} +; then
	_success "Replaced 'AndroidTemplate' with '$APP_NAME_NO_SPACE'"
else
	_error "Failed to rename AndroidTemplate strings"
fi

app_file=$(find . -name "AndroidTemplateApplication.kt" -print -quit)
if [[ -n "$app_file" ]]; then
	new_app_file="${app_file/AndroidTemplateApplication.kt/${APP_NAME_NO_SPACE}Application.kt}"
	if mv "$app_file" "$new_app_file"; then
		_success "Renamed main application file to $(basename "$new_app_file")"
	else
		_error "Failed to rename application file"
	fi
else
	_error "Main application file not found"
fi

if find . -name "*.bak" -type f -delete; then
	_success "Removed .bak files"
else
	_error "Failed to delete .bak files"
fi

_log "🗑️ ${violet}Cleaning${normal} up template files"
if rm -f README.md; then
	_success "Removed README"
else
	_error "Failed to remove README"
fi

if rm -f customizer.sh customizer.ps1; then
	_success "Removing customizer script"
else
	_error "Failed to remove customizer script"
fi

if rm -rf .git; then
	_success "Removing .git directory"
else
	_error "Failed to remove .git directory"
fi

if find . -name "*.gitkeep" -type f -delete; then
	_success "Removing .gitkeep files"
else
	_error "Failed to remove .gitkeep files"
fi

_log
_log "🎉 Customization complete!"
_log
