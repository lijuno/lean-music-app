#!/bin/zsh
set -euo pipefail

PROJECT_ROOT="${0:A:h:h}"
APP_PATH="$PROJECT_ROOT/.build/dist/YT Music App.app"
SUBMISSION_ZIP="$PROJECT_ROOT/.build/dist/YT-Music-App-notarization.zip"
APP_VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$PROJECT_ROOT/Packaging/Info.plist")"
RELEASE_ZIP="$PROJECT_ROOT/.build/dist/YT-Music-App-$APP_VERSION.zip"

if [[ -z "${DEVELOPER_ID_APPLICATION:-}" ]]; then
  print -u2 "Set DEVELOPER_ID_APPLICATION to your Developer ID Application certificate name."
  exit 1
fi

if [[ -z "${NOTARY_KEYCHAIN_PROFILE:-}" ]]; then
  print -u2 "Set NOTARY_KEYCHAIN_PROFILE to a profile created with 'xcrun notarytool store-credentials'."
  exit 1
fi

SKIP_ADHOC_SIGNING=1 "$PROJECT_ROOT/Scripts/build-app.sh"

codesign \
  --force \
  --options runtime \
  --timestamp \
  --identifier "io.github.lijuno.yt-music-app" \
  --sign "$DEVELOPER_ID_APPLICATION" \
  "$APP_PATH"

codesign --verify --deep --strict --verbose=2 "$APP_PATH"

rm -f "$SUBMISSION_ZIP" "$RELEASE_ZIP"
/usr/bin/ditto -c -k --keepParent "$APP_PATH" "$SUBMISSION_ZIP"
xcrun notarytool submit \
  "$SUBMISSION_ZIP" \
  --keychain-profile "$NOTARY_KEYCHAIN_PROFILE" \
  --wait
xcrun stapler staple "$APP_PATH"
xcrun stapler validate "$APP_PATH"
/usr/bin/ditto -c -k --keepParent "$APP_PATH" "$RELEASE_ZIP"
spctl --assess --type execute --verbose=4 "$APP_PATH"

print "Created notarized release: $RELEASE_ZIP"
