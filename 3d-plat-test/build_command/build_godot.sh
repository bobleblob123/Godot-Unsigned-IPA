#!/bin/zsh
set -e

read "FEATURE?add what was added (or press Enter to skip): "

# Clean feature text
FEATURE_CLEAN=$(echo "$FEATURE" | tr ' ' '_' | tr -cd '[:alnum:]_-')

DATE=$(date +%F)
ROOT="/Volumes/Mac Main/Godot/Builds/3D_Test"
BASE="$ROOT/$DATE"

# If base date folder exists, start numbering at _02
if [[ -d "$BASE" ]]; then
    COUNT=2
    while [[ -d "${ROOT}/${DATE}_$(printf "%02d" $COUNT)" ]]; do
        ((COUNT++))
    done
    BASE="${ROOT}/${DATE}_$(printf "%02d" $COUNT)"
fi

PROJECT="/Volumes/Mac Main/Godot/3D_Plat_Test/3d-plat-test"
GODOT="/Applications/Godot.app/Contents/MacOS/Godot"

# Create root + images folder
mkdir -p "$BASE/images"

# Build name
if [[ -n "$FEATURE_CLEAN" ]]; then
    BUILD_NAME="3D_Plat_test_${DATE}_${FEATURE_CLEAN}"
else
    BUILD_NAME="3D_Plat_test_${DATE}"
fi

build() {
    PRESET="$1"
    PLATFORM="$2"
    EXT="$3"

    OUTDIR="$BASE/$PLATFORM"
    mkdir -p "$OUTDIR"

    echo "Building $PRESET..."

    "$GODOT" --headless \
        --path "$PROJECT" \
        --export-debug "$PRESET" \
        "$OUTDIR/${BUILD_NAME}.${EXT}"
}

# macOS
build "macOS" "macOS" "app"

# Android
build "Android" "Android" "apk"

# Windows
build "Windows ARM64" "Windows/ARM64" "exe"
build "Windows X86_64" "Windows/x86_64" "exe"
build "Windows X86_32" "Windows/x86_32" "exe"

# Linux
build "Linux ARM64" "Linux/ARM64" "x86_64"
build "Linux X86_64" "Linux/x86_64" "x86_64"
build "Linux X86_32" "Linux/x86_32" "x86_32"

# Web
build "Web" "Web" "zip"

echo "All debug builds complete in: $BASE"