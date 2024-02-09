#!/usr/bin/env bash

set -e

# Arguments
if [ $# -lt 2 ]; then
	\cat <<EOF
Usage:
  customizer <your.package.name> <YourAppName>

EOF
	exit 1
fi

# Script variables
PACKAGE=$1
APPNAME=${@:2}
SUBDIR=${PACKAGE//.//}
NOSPACE_APPNAME=${APPNAME// /}

# Script colors
PURPLE='\033[38;2;206;62;214m'
VIOLET='\033[38;2;198;152;242m'
RESET='\033[0m'

# Script text styles
ITALIC=$(tput sitm)
NORMAL=$(tput ritm)

# Set the script root directory
cd "$(dirname "$0")"

# Move files to the correct package
echo -e "📦 ${VIOLET}Moving${RESET} files to ${PURPLE}./src/main/kotlin/$SUBDIR${RESET}"
for n in $(find . -type d -path '*/src/main' ! -path '*/buildSrc/*'); do
	mkdir -p $n/kotlin/$SUBDIR
	mv $n/kotlin/android/template/* $n/kotlin/$SUBDIR
	rm -rf mv $n/kotlin/android
done

# Replace package and imports
echo -e "🚛 ${VIOLET}Replacing${RESET} package and imports to ${PURPLE}$PACKAGE${RESET}"
find ./ -type f -name "*.kt" -exec sed -i "s/android.template/$PACKAGE/g" {} \;

# Rename app name
echo -e "🧱 ${VIOLET}Renaming${RESET} app to ${PURPLE}$APPNAME${RESET}"
find ./ -type f \( -name "settings.gradle.kts" -or -name "strings.xml" \) -exec sed -i "s/Android Template/$APPNAME/g" {} \;
find ./ -type f -name "*.xml" -exec sed -i "s/AndroidTemplate/$NOSPACE_APPNAME/g" {} \;
find ./ -type f -name "*.kt" -exec sed -i "s/AndroidTemplate/$NOSPACE_APPNAME/g" {} \;
find ./ -name "AndroidTemplateApplication.kt" | sed "p;s/AndroidTemplateApplication.kt/${NOSPACE_APPNAME}Application.kt/" | tr '\n' '\0' | xargs -0 -n 2 mv

# Remove additional files
echo -e "🧹 ${VIOLET}Removing${RESET} additional files"
rm -rf README.md customizer.sh customizer.ps1
rm -rf .git/

echo -e "${PURPLE}╭──────────────────────────────────────────────────╮${RESET}"
echo -e "${PURPLE}│${RESET}                     ${ITALIC}🎉 Done!${NORMAL}                     ${PURPLE}│${RESET}"
echo -e "${PURPLE}╰──────────────────────────────────────────────────╯${RESET}"