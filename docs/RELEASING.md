# Releasing

Releases are built from version tags matching `v<CFBundleShortVersionString>`, such as `v1.1.2`.

## Before tagging

1. Update `CFBundleShortVersionString` and increment `CFBundleVersion` in `Packaging/Info.plist`.
2. Update `CHANGELOG.md`.
3. Run `swift run LeanMusicAppChecks`, `swift build`, and `./Scripts/build-app.sh`.
4. Test sign-in, playback, hide-on-close, relaunch persistence, external links, origin display, and website-data deletion on a clean macOS account.
5. Confirm the working tree is clean and the release commit is on the default branch.

## Local notarized release

Create a `notarytool` Keychain profile once, then run:

```sh
xcrun notarytool store-credentials "lean-music-notary"
DEVELOPER_ID_APPLICATION="Developer ID Application: Your Name (TEAMID)" \
NOTARY_KEYCHAIN_PROFILE="lean-music-notary" \
./Scripts/release.sh
```

The script creates a notarized ZIP and matching `.sha256` file in `.build/dist`.

## GitHub tag release

The release workflow requires a protected `release` environment and these repository secrets:

- `DEVELOPER_ID_APPLICATION`
- `DEVELOPER_ID_P12_BASE64`
- `DEVELOPER_ID_P12_PASSWORD`
- `NOTARY_KEY_BASE64`
- `NOTARY_KEY_ID`
- `NOTARY_ISSUER_ID`

Export the Developer ID certificate and private key as a password-protected `.p12`, base64-encode it, and store only the encoded value as a GitHub secret. Store the base64-encoded App Store Connect API `.p8` key the same way. Restrict the `release` environment to trusted maintainers and require approval.

Push an annotated version tag only after the release commit is merged:

```sh
git tag -a v1.1.2 -m "lean-music-app 1.1.2"
git push origin v1.1.2
```

Then run the **Release** workflow from GitHub Actions and enter the existing tag. The workflow is deliberately manual so merely pushing a tag cannot start a signing job before protected credentials and an environment approval are available.

The workflow checks that the requested tag matches `Info.plist`, imports credentials into an ephemeral Keychain, runs tests, signs and notarizes the universal app, publishes the ZIP and checksum, and removes temporary credentials.
