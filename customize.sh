#!/bin/bash

for arg in "$@"; do
    case $arg in
        --appId=*) appId="${arg#*=}" ;;
        --name=*) name="${arg#*=}" ;;
        --dirname=*) dirname="${arg#*=}" ;;
    esac
done

if [ -z "$appId" ]; then
    read -p "Enter appId: " appId
fi

if [ -z "$name" ]; then
    read -p "Enter name: " name
fi

if [ -z "$dirname" ]; then
    read -p "Enter dirname: " dirname
fi

if [ -d "$dirname" ]; then
    echo "Error: Directory '$dirname' already exists. Aborting."
    exit 1
fi

export LC_ALL=C
find amplify-android .github -type f | while read -r file; do
    if grep -q "com\.example\.androidamplify" "$file" 2>/dev/null; then
        sed -i '' "s/com\.example\.androidamplify/$appId/g" "$file"
    fi
    if grep -q "AndroidAmplify" "$file" 2>/dev/null; then
        sed -i '' "s/AndroidAmplify/$name/g" "$file"
    fi
    if grep -q "amplify-android" "$file" 2>/dev/null; then
        sed -i '' "s/amplify-android/$dirname/g" "$file"
    fi
done

appIdDirPath="${appId//.//}"

mkdir -p "amplify-android/app/src/main/java/$appIdDirPath"
mv "amplify-android/app/src/main/java/com/example/androidamplify"/* "amplify-android/app/src/main/java/$appIdDirPath/"
rmdir -p "amplify-android/app/src/main/java/com/example/androidamplify" 2>/dev/null || true

mkdir -p "amplify-android/app/src/test/java/$appIdDirPath"
mv "amplify-android/app/src/test/java/com/example/androidamplify"/* "amplify-android/app/src/test/java/$appIdDirPath/"
rmdir -p "amplify-android/app/src/test/java/com/example/androidamplify" 2>/dev/null || true

mkdir -p "amplify-android/app/src/androidTest/java/$appIdDirPath"
mv "amplify-android/app/src/androidTest/java/com/example/androidamplify"/* "amplify-android/app/src/androidTest/java/$appIdDirPath/"
rmdir -p "amplify-android/app/src/androidTest/java/com/example/androidamplify" 2>/dev/null || true

mv amplify-android "$dirname"

mv ".github/workflows/amplify-android-build.yml" ".github/workflows/$dirname-build.yml"

echo "Customization complete."
