#!/bin/bash
set -e

appId=""
dirname=""
name=""

for arg in "$@"; do
  case $arg in
    --appId=*)
      appId="${arg#*=}"
      ;;
    --dirname=*)
      dirname="${arg#*=}"
      ;;
    --name=*)
      name="${arg#*=}"
      ;;
  esac
done

if [[ -z "$appId" || -z "$dirname" || -z "$name" ]]; then
  echo "Error: All parameters (--appId, --dirname, --name) must be set" >&2
  exit 1
fi

if [ -d "$dirname" ]; then
    echo "Error: Directory '$dirname' already exists. Aborting."
    exit 1
fi

random_suffix=$(printf "%08d" $((RANDOM * RANDOM % 100000000)))
clone_dir="amplify-android-template-tmp-${random_suffix}"

git clone git@github.com:cadivus/amplify-android-template.git "$clone_dir"
cd "$clone_dir"
./customize.sh "$@"
mv "$dirname" "../"
mkdir -p "../.github/workflows"
mv .github/workflows/* ../.github/workflows/
cd ..
rm -R -f "$clone_dir"
