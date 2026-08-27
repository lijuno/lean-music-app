# lean-music-app

A lightweight, unofficial macOS wrapper for the official YouTube Music website. It uses the system WebKit engine, keeps website data between launches, and keeps playback alive when its window is closed.

This project is independent and is not affiliated with or endorsed by Google or YouTube. YouTube and YouTube Music are trademarks of Google LLC.

## Features

- Persistent Google and YouTube website session
- Background playback through a retained web view
- Back, forward, reload, home, and visible-origin controls
- App Sandbox with outbound-network access only
- Confirmed **Clear Website Data and Sign Out** command
- Universal Apple silicon and Intel build
- Developer ID signing, Apple notarization, and SHA-256 release checksums

The app does not scrape, extract, convert, intercept, or independently download YouTube media. YouTube controls all playback and any website-managed Premium functionality. Google may change embedded-browser or sign-in support at any time.

## Install

Download the latest notarized ZIP from [GitHub Releases](https://github.com/lijuno/lean-music-app/releases), verify its `.sha256` file, unzip it, and move `Lean Music App.app` to `/Applications`.

When upgrading from an earlier build, quit and remove any old `YT Music App.app` or `lean-music-app.app` bundle before installing `Lean Music App.app`. Keeping multiple bundles can confuse macOS Launch Services.

Closing the window hides it so playback can continue. Use **Lean Music App → Quit Lean Music App** or <kbd>⌘Q</kbd> to stop the app completely.

## Privacy and account data

Google authentication happens directly in WebKit. The app has no telemetry, analytics, advertising, backend, or JavaScript bridge, and it does not separately receive or store passwords. Website cookies, caches, and local storage remain in the app's sandbox on the Mac.

Use **Lean Music App → Clear Website Data and Sign Out…** to erase all WebKit website data held by the app. See [PRIVACY.md](PRIVACY.md) for the complete policy.

Version 1.1.0 enables App Sandbox. Version 1.1.1 also changes the application identifier to `io.github.lijuno.lean-music-app`. Existing installations must sign in again because macOS treats it as a new sandbox container.

## Develop and verify

Requirements: macOS 14 or later and Apple Swift 6.1 or later.

```sh
swift run LeanMusicAppChecks
swift build
swift run LeanMusicApp
```

The dependency-free check executable tests the shared routing and identity logic without requiring XCTest.

To assemble a universal, locally signed app:

```sh
./Scripts/build-app.sh
open ".build/dist/Lean Music App.app"
```

Public release instructions are in [docs/RELEASING.md](docs/RELEASING.md). Please read [CONTRIBUTING.md](CONTRIBUTING.md) before submitting changes and [SECURITY.md](SECURITY.md) before reporting a vulnerability.

## License

Source code and project artwork are available under the [MIT License](LICENSE).
