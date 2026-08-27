# Changelog

All notable changes are documented here. Versions follow semantic versioning.

## [1.1.2] - 2026-08-27

### Changed

- Changed the macOS display and bundle name to `Lean Music App`

## [1.1.1] - 2026-08-27

### Changed

- Changed the application identifier to `io.github.lijuno.lean-music-app`
- Existing installations must sign in again because macOS treats the new identifier as a separate sandbox container

## [1.1.0] - 2026-08-27

### Added

- App Sandbox with outbound-network access only
- Confirmed website-data clearing and sign-out command
- Visible secure origin in the toolbar
- Public privacy, security, contribution, and release documentation
- GitHub CI and protected tag-release workflows
- SHA-256 checksums for published archives

### Changed

- Renamed the public product to `lean-music-app`
- Hardened top-level navigation and external-scheme handling
- Existing users may need to sign in once after upgrading because website data now lives inside the application sandbox
- Existing users should remove the old `YT Music App.app` bundle before installing the renamed application

## [1.0.2] - 2026-08-27

- Added the original cyan-and-amber waveform icon
- Added Safari-compatible WebKit identification
- Published the first universal notarized build
