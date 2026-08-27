# Contributing

Thank you for helping improve lean-music-app.

## Before opening a change

- Search existing issues and pull requests.
- Keep the app dependency-free unless a dependency has a clear security and maintenance benefit.
- Do not add scraping, media extraction, ad blocking, telemetry, undocumented YouTube APIs, or custom download behavior.
- Preserve the unmodified YouTube Music page and the visible source attribution it provides.
- Never commit credentials, cookies, signing certificates, provisioning data, or generated release bundles.

## Verify locally

```sh
swift run LeanMusicAppChecks
swift build
./Scripts/build-app.sh
codesign --verify --deep --strict --verbose=2 ".build/dist/Lean Music App.app"
```

For WebKit changes, manually test a fresh login, relaunch persistence, account logout, external links, window close/reopen, playback, and **Clear Website Data and Sign Out**.

## Pull requests

Explain the user-visible change, risks, and verification performed. Keep unrelated changes separate. By contributing, you agree that your contribution is licensed under the MIT License.
