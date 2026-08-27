# YT Music App

A small, independent macOS wrapper around the official YouTube Music website. It keeps WebKit's persistent website data so your Google login survives relaunches, and it keeps the same web view alive when the window is closed so audio can continue playing.

The app uses an original cyan-and-amber waveform icon stored in `Assets/AppIconSource.png`. The build script generates all required macOS icon sizes from that source.

The app does not scrape, extract, convert, intercept, or independently download YouTube media. If YouTube exposes official Premium downloads to its web client, those downloads remain managed by YouTube. Otherwise, offline playback is unavailable and the app displays an explanatory warning after an offline navigation failure.

## Requirements

- macOS 14 or later
- Apple Swift 6.1 or later
- A Developer ID Application certificate and Apple notarization credentials only when creating a release for other Macs

## Develop and verify

```sh
swift run YTMusicAppChecks
swift build
swift run YTMusicApp
```

The check executable is used because the standalone Apple Command Line Tools installation does not ship XCTest or Swift Testing. It tests the actual shared module without adding a third-party dependency.

## Build a local app

```sh
./Scripts/build-app.sh
open ".build/dist/YT Music App.app"
```

The resulting universal app is ad-hoc signed for local use.

## Sign and notarize a private release

Create a `notarytool` Keychain profile once, then provide the certificate name and profile to the release script:

```sh
xcrun notarytool store-credentials "yt-music-notary"
DEVELOPER_ID_APPLICATION="Developer ID Application: Your Name (TEAMID)" \
NOTARY_KEYCHAIN_PROFILE="yt-music-notary" \
./Scripts/release.sh
```

The versioned notarized ZIP is written to `.build/dist`. Credentials are read from Keychain and the environment and are never stored in this repository.

## Privacy and storage

Google authentication is performed directly in WebKit. The app does not receive or separately store passwords. Cookies and website storage belong to the stable bundle identifier `io.github.lijuno.yt-music-app`; deleting the app's WebKit data will sign the user out and may remove website-managed offline data.

YouTube and YouTube Music are trademarks of Google LLC. This project is not affiliated with or endorsed by Google.
