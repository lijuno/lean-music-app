#!/bin/zsh
set -euo pipefail

PROJECT_ROOT="${0:A:h:h}"
APP_PATH="$PROJECT_ROOT/.build/dist/Lean Music App.app"
SUBMISSION_ZIP="$PROJECT_ROOT/.build/dist/lean-music-app-notarization.zip"
ENTITLEMENTS_PATH="$PROJECT_ROOT/Packaging/lean-music-app.entitlements"
APP_VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$PROJECT_ROOT/Packaging/Info.plist")"
RELEASE_ZIP="$PROJECT_ROOT/.build/dist/lean-music-app-$APP_VERSION.zip"
CHECKSUM_PATH="$RELEASE_ZIP.sha256"

if [[ -z "${DEVELOPER_ID_APPLICATION:-}" ]]; then
  print -u2 "Set DEVELOPER_ID_APPLICATION to your Developer ID Application certificate name."
  exit 1
fi

typeset -a NOTARY_ARGUMENTS
if [[ -n "${NOTARY_KEYCHAIN_PROFILE:-}" ]]; then
  NOTARY_ARGUMENTS=(--keychain-profile "$NOTARY_KEYCHAIN_PROFILE")
elif [[ -n "${NOTARY_KEY_PATH:-}" && -n "${NOTARY_KEY_ID:-}" && -n "${NOTARY_ISSUER_ID:-}" ]]; then
  NOTARY_ARGUMENTS=(
    --key "$NOTARY_KEY_PATH"
    --key-id "$NOTARY_KEY_ID"
    --issuer "$NOTARY_ISSUER_ID"
  )
else
  print -u2 "Set NOTARY_KEYCHAIN_PROFILE, or set NOTARY_KEY_PATH, NOTARY_KEY_ID, and NOTARY_ISSUER_ID."
  exit 1
fi

SKIP_ADHOC_SIGNING=1 "$PROJECT_ROOT/Scripts/build-app.sh"

codesign \
  --force \
  --options runtime \
  --timestamp \
  --identifier "io.github.lijuno.lean-music-app" \
  --entitlements "$ENTITLEMENTS_PATH" \
  --sign "$DEVELOPER_ID_APPLICATION" \
  "$APP_PATH"

codesign --verify --deep --strict --verbose=2 "$APP_PATH"

rm -f "$SUBMISSION_ZIP" "$RELEASE_ZIP" "$CHECKSUM_PATH"
/usr/bin/ditto -c -k --norsrc --noextattr --keepParent "$APP_PATH" "$SUBMISSION_ZIP"
xcrun notarytool submit \
  "$SUBMISSION_ZIP" \
  "${NOTARY_ARGUMENTS[@]}" \
  --wait
xcrun stapler staple "$APP_PATH"
xcrun stapler validate "$APP_PATH"
/usr/bin/ditto -c -k --norsrc --noextattr --keepParent "$APP_PATH" "$RELEASE_ZIP"
(
  cd "${RELEASE_ZIP:h}"
  /usr/bin/shasum -a 256 "${RELEASE_ZIP:t}" > "${CHECKSUM_PATH:t}"
)
spctl --assess --type execute --verbose=4 "$APP_PATH"

print "Created notarized release: $RELEASE_ZIP"
print "Created checksum: $CHECKSUM_PATH"
