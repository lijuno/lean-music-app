# Agent Operating Guide

This file is the canonical instruction set for automated coding agents working in this repository. Read it together with `docs/ARCHITECTURE.md`, `docs/TESTING.md`, and `docs/DECISIONS.md` before changing code.

## Mission

Maintain a small, dependency-free macOS wrapper around the unmodified YouTube Music website. Preserve user trust, login persistence, background playback, and a clear boundary between this app and Google or YouTube.

## Non-goals and prohibited changes

Do not add media extraction, custom downloads, scraping, ad blocking, telemetry, analytics, undocumented YouTube APIs, a local music library, injected page modifications, or a JavaScript bridge. Do not present the app as an official Google or YouTube product.

Never commit credentials, cookies, account identifiers, signing certificates, API keys, provisioning profiles, notarization material, or generated `.app` and release archives.

## Stable invariants

- Product name: `Lean Music App`
- Bundle identifier: `io.github.lijuno.lean-music-app`
- Minimum system: macOS 14
- Home URL: `https://music.youtube.com/`
- Website storage: persistent `WKWebsiteDataStore.default()` in the app sandbox
- Sandbox access: outbound network only
- Trusted in-app origins: HTTPS subdomains of `youtube.com` and `google.com`
- Unrelated links: open externally only after an explicit user action
- Window close: hide the window without destroying the retained web view or stopping playback
- Explicit Quit: terminate the process and playback

Changing an invariant requires an explicit owner decision recorded in `docs/DECISIONS.md`. Treat bundle-identifier changes as data migrations because they move users to a new sandbox container.

## Repository map

- `Sources/LeanMusicApp`: SwiftUI/AppKit/WebKit lifecycle and UI
- `Sources/LeanMusicCore`: deterministic identity and navigation policy
- `Tests/LeanMusicCoreTests`: Swift Testing coverage for core invariants
- `Packaging`: bundle metadata and sandbox entitlements
- `Scripts`: universal build, icon generation, signing, notarization, and packaging
- `docs`: architecture, testing, decisions, roadmap, and release operations
- `.github`: CI, release workflow, contribution intake, and ownership

## Required workflow

1. Inspect the working tree and preserve unrelated user changes.
2. Keep each change narrowly scoped and update tests for deterministic behavior.
3. Run `./Scripts/test.sh`, `swift build`, and `./Scripts/build-app.sh`.
4. For packaging changes, verify the bundle using the commands in `docs/TESTING.md`.
5. For WebKit, authentication, storage, playback, or window-lifecycle changes, report the applicable manual tests from `docs/TESTING.md`; do not claim they passed unless they were actually performed.
6. Update `CHANGELOG.md` under `Unreleased` for user-visible behavior.
7. Summarize risks, verification, and remaining human checks in the pull request.

## Definition of done

A change is complete only when source and documentation agree, automated checks pass, no secrets or generated artifacts are staged, relevant security boundaries are preserved, and outstanding manual verification is stated explicitly.

## Release boundary

Agents may prepare version changes, changelog entries, release notes, and a pull request. They must not create or push a release tag, access signing credentials, sign or notarize a public build, run the protected Release workflow, publish a GitHub release, or modify release secrets without the repository owner's explicit instruction for that release.

Releases must follow `docs/RELEASING.md`. A human-controlled GitHub `release` environment is the final authorization boundary.
