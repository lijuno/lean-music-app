#!/bin/zsh
set -euo pipefail

PROJECT_ROOT="${0:A:h:h}"
APP_PATH="${1:-$PROJECT_ROOT/.build/dist/Lean Music App.app}"
INFO_PATH="$APP_PATH/Contents/Info.plist"
BINARY_PATH="$APP_PATH/Contents/MacOS/LeanMusicApp"

if [[ ! -d "$APP_PATH" || ! -f "$INFO_PATH" || ! -x "$BINARY_PATH" ]]; then
  print -u2 "App bundle is incomplete or missing: $APP_PATH"
  exit 1
fi

[[ "$(/usr/bin/plutil -extract CFBundleDisplayName raw "$INFO_PATH")" == "Lean Music App" ]]
[[ "$(/usr/bin/plutil -extract CFBundleIdentifier raw "$INFO_PATH")" == "io.github.lijuno.lean-music-app" ]]
[[ "$(/usr/bin/plutil -extract LSMinimumSystemVersion raw "$INFO_PATH")" == "14.0" ]]

/usr/bin/lipo "$BINARY_PATH" -verify_arch arm64 x86_64
/usr/bin/codesign --verify --deep --strict --verbose=2 "$APP_PATH"

ENTITLEMENTS="$(/usr/bin/codesign -d --entitlements - "$APP_PATH" 2>&1)"
if [[ "$ENTITLEMENTS" != *"[Key] com.apple.security.app-sandbox"*"[Bool] true"*"[Key] com.apple.security.network.client"*"[Bool] true"* \
   || "$ENTITLEMENTS" == *"com.apple.security.network.server"* \
   || "$ENTITLEMENTS" == *"com.apple.security.files."* ]]; then
  print -u2 "Required sandbox entitlements are missing or broader access is present."
  exit 1
fi

print "Verified product identity, universal architectures, signature, and sandbox: $APP_PATH"
