# Architecture

## Overview

Lean Music App is a native macOS shell around the official YouTube Music website. It deliberately has no backend, custom media API, injected page code, or application database.

```text
SwiftUI scene
  ├─ AppDelegate ─ window lifetime, reopen, help, destructive-data confirmation
  ├─ BrowserModel ─ one retained WKWebView and navigation delegates
  │    ├─ WKWebsiteDataStore.default() ─ cookies, cache, local storage, IndexedDB
  │    └─ NavigationPolicy ─ trusted-origin boundary
  ├─ ConnectivityMonitor ─ network reachability signal
  └─ ContentView / BrowserView ─ toolbar, web content, offline failure overlay
```

## Modules

### LeanMusicCore

`AppConstants` owns the stable public identity, home URL, and limitation copy. `BrowserIdentity` adds Safari's identifying user-agent suffix because YouTube Music otherwise rejects an ordinary `WKWebView`. `NavigationPolicy` is pure and testable: it decides whether a URL stays in the web view, opens in the default browser, or is blocked.

Core must remain independent of SwiftUI, AppKit, and WebKit so trust decisions can be unit tested without launching the application.

### LeanMusicApp

`LeanMusicApp` creates one `BrowserModel` for the SwiftUI scene lifetime. `BrowserModel` creates one `WKWebView`, configures persistent website data, and owns both navigation delegates. Replacing this model or web view during ordinary window operations would risk stopping playback or changing session behavior.

`AppDelegate` retains and hides the main window when the close button is pressed. It handles Dock reopening and requires explicit confirmation before all WebKit website data is erased.

`ConnectivityMonitor` does not decide whether media is playable. It only allows `ContentView` to replace a failed page with the native offline warning when the network is unavailable.

## Trust boundaries

Only HTTPS pages at `youtube.com`, `google.com`, or their real subdomains may navigate in-app. Host suffix checks include the dot boundary so lookalike names such as `youtube.com.example.org` are not trusted.

Trusted `blob:` URLs are accepted only when both their embedded origin and creating page are trusted. `about:blank` is allowed for browser mechanics. Unrelated HTTP(S) and `mailto:` links open externally only following explicit link or form activation. Other schemes and automatic external navigation are blocked.

Do not weaken these rules merely to make a third-party link work. Add a focused test and document the security reasoning for any policy change.

## Data lifecycle

Authentication and site data are controlled by WebKit and stored in the sandbox container for `io.github.lijuno.lean-music-app`. The app does not receive passwords separately. The **Clear Website Data and Sign Out…** command removes all WebKit data types and reloads the home page.

The bundle identifier is therefore part of the data model. Changing it prevents the new build from seeing the old container and requires users to sign in again.

## Playback and offline behavior

Playback is website-controlled. Background playback works because closing the main window orders it out instead of terminating the process or releasing the web view. The app does not claim that macOS sleep, process termination, or an explicit Quit preserves playback.

Offline downloads are also website-controlled and may be unavailable in WebKit. The application never creates independent media copies. If a failed navigation coincides with loss of connectivity, the native overlay explains this limitation.

## Packaging and release

`Scripts/build-app.sh` compiles arm64 and x86_64 executables, combines them with `lipo`, adds metadata and generic artwork, and applies an ad-hoc sandboxed signature for local verification. `Scripts/release.sh` rebuilds, applies Developer ID signing with Hardened Runtime, submits to Apple, staples the ticket, creates the ZIP, and writes its checksum.

Public releases are built from version tags. Signing credentials are operational secrets, not repository data.
