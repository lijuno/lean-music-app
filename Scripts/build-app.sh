#!/bin/zsh
set -euo pipefail

PROJECT_ROOT="${0:A:h:h}"
BUILD_ROOT="$PROJECT_ROOT/.build"
DIST_ROOT="$BUILD_ROOT/dist"
APP_PATH="$DIST_ROOT/YT Music App.app"
CONTENTS_PATH="$APP_PATH/Contents"
MACOS_PATH="$CONTENTS_PATH/MacOS"
RESOURCES_PATH="$CONTENTS_PATH/Resources"
ARM_BUILD_ROOT="$BUILD_ROOT/arm64-release"
INTEL_BUILD_ROOT="$BUILD_ROOT/x86_64-release"
ARM_BINARY="$ARM_BUILD_ROOT/arm64-apple-macosx/release/YTMusicApp"
INTEL_BINARY="$INTEL_BUILD_ROOT/x86_64-apple-macosx/release/YTMusicApp"

swift build \
  --package-path "$PROJECT_ROOT" \
  --configuration release \
  --product YTMusicApp \
  --triple arm64-apple-macosx14.0 \
  --build-path "$ARM_BUILD_ROOT"

swift build \
  --package-path "$PROJECT_ROOT" \
  --configuration release \
  --product YTMusicApp \
  --triple x86_64-apple-macosx14.0 \
  --build-path "$INTEL_BUILD_ROOT"

if [[ ! -x "$ARM_BINARY" || ! -x "$INTEL_BINARY" ]]; then
  print -u2 "One or both architecture-specific executables were not produced."
  exit 1
fi

if [[ "$DIST_ROOT" != "$PROJECT_ROOT/.build/dist" ]]; then
  print -u2 "Refusing to clean unexpected distribution path: $DIST_ROOT"
  exit 1
fi

rm -rf "$APP_PATH"
mkdir -p "$MACOS_PATH" "$RESOURCES_PATH"
/usr/bin/lipo \
  -create \
  "$ARM_BINARY" \
  "$INTEL_BINARY" \
  -output "$MACOS_PATH/YTMusicApp"
cp "$PROJECT_ROOT/Packaging/Info.plist" "$CONTENTS_PATH/Info.plist"

swift \
  "$PROJECT_ROOT/Scripts/generate-icon.swift" \
  "$PROJECT_ROOT/Assets/AppIconSource.png" \
  "$RESOURCES_PATH/AppIcon.icns"

if [[ "${SKIP_ADHOC_SIGNING:-0}" != "1" ]]; then
  codesign \
    --force \
    --sign - \
    --identifier "io.github.lijuno.yt-music-app" \
    "$APP_PATH"
fi

/usr/bin/plutil -lint "$CONTENTS_PATH/Info.plist"
/usr/bin/lipo -info "$MACOS_PATH/YTMusicApp"
print "Built $APP_PATH"
