# Decision Log

This log records constraints that future maintainers should not rediscover or silently reverse. Add a dated entry when an architectural or product boundary changes.

## 2026-08-27 — Native WebKit wrapper

Use SwiftUI, AppKit, WebKit, Network, and Foundation without third-party dependencies. The small native surface reduces packaging, privacy, and supply-chain risk.

## 2026-08-27 — Preserve the official website

Serve the unmodified YouTube Music web experience. Do not scrape, intercept media, inject DOM changes, block advertising, or use undocumented YouTube APIs. This keeps playback, branding, advertisements, and account behavior controlled by YouTube.

## 2026-08-27 — No independent offline library

Do not download or play local audio. Official website-managed Premium functionality may work where YouTube and WebKit support it, but the app makes no guarantee. Show the limitation instead of implementing a custom downloader.

## 2026-08-27 — Persistent lifetime and storage

Retain one `WKWebView` for the application lifetime and use `WKWebsiteDataStore.default()`. Closing the window hides it; explicit Quit terminates it. Provide a confirmed command to erase all website data.

## 2026-08-27 — Stable public identity

Use the product name `Lean Music App` and bundle identifier `io.github.lijuno.lean-music-app`. The bundle identifier selects the sandbox container, so changing it is a user-data migration requiring explicit owner approval and upgrade documentation.

## 2026-08-27 — Sandboxed public distribution

Public builds use App Sandbox with outbound-network access only, Developer ID signing, Hardened Runtime, Apple notarization, stapling, and a published SHA-256 checksum.

## 2026-08-27 — Human-authorized releases

Development may be delegated, but public signing and publishing remain privileged owner actions. Agents may prepare a release but require explicit authorization to tag, access credentials, run the protected release environment, or publish assets.
