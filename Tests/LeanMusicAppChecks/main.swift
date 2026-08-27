import Darwin
import Foundation
import LeanMusicCore

private var failures: [String] = []

@MainActor
private func expect(_ condition: @autoclosure () -> Bool, _ message: String) {
    if !condition() {
        failures.append(message)
    }
}

expect(AppConstants.productName == "Lean Music App", "Unexpected product name")
expect(
    AppConstants.bundleIdentifier == "io.github.lijuno.lean-music-app",
    "Unexpected bundle identifier"
)
expect(
    AppConstants.homeURL.absoluteString == "https://music.youtube.com/",
    "Unexpected home URL"
)
expect(
    AppConstants.offlineMessage.localizedCaseInsensitiveContains("does not download"),
    "Offline warning must disclose that the app does not download music"
)
expect(
    AppConstants.helpMessage.localizedCaseInsensitiveContains("independent wrapper"),
    "Help copy must identify the app as independent"
)
expect(
    BrowserIdentity.safariApplicationName(installedSafariVersion: "26.5.2")
        == "Version/26.5.2 Safari/605.1.15",
    "Safari-compatible WebKit identity should use the installed Safari version"
)
expect(
    BrowserIdentity.safariApplicationName(installedSafariVersion: "invalid")
        == "Version/17.0 Safari/605.1.15",
    "Safari-compatible WebKit identity should safely handle invalid versions"
)

let trustedURLs = [
    "https://music.youtube.com/",
    "https://accounts.google.com/signin",
    "https://www.youtube.com/watch?v=123",
    "https://support.google.com/youtubemusic/",
    "about:blank"
]
for rawURL in trustedURLs {
    guard let url = URL(string: rawURL) else {
        failures.append("Could not construct trusted test URL: \(rawURL)")
        continue
    }
    expect(
        NavigationPolicy.destination(for: url) == .inApp,
        "Expected in-app navigation for \(rawURL)"
    )
}

expect(
    NavigationPolicy.destination(
        for: URL(string: "blob:https://music.youtube.com/1234")!,
        currentPageURL: AppConstants.homeURL
    ) == .inApp,
    "Trusted blob URLs should stay inside the app when created by a trusted page"
)

let externalURLs = [
    "https://example.com/",
    "https://youtube.com.example.org/",
    "mailto:hello@example.com"
]
for rawURL in externalURLs {
    guard let url = URL(string: rawURL) else {
        failures.append("Could not construct external test URL: \(rawURL)")
        continue
    }
    expect(
        NavigationPolicy.destination(for: url, isUserInitiated: true) == .external,
        "Expected external navigation for \(rawURL)"
    )
}

let blockedURLs = [
    "data:text/html,blocked",
    "javascript:alert(1)",
    "custom-scheme://open",
    "http://music.youtube.com/",
    "blob:https://example.com/1234"
]
for rawURL in blockedURLs {
    guard let url = URL(string: rawURL) else {
        failures.append("Could not construct blocked test URL: \(rawURL)")
        continue
    }
    expect(
        NavigationPolicy.destination(
            for: url,
            currentPageURL: AppConstants.homeURL
        ) == .blocked,
        "Expected blocked navigation for \(rawURL)"
    )
}

expect(
    NavigationPolicy.destination(for: URL(string: "https://example.com/")!) == .blocked,
    "External pages must not open without an explicit user action"
)

if failures.isEmpty {
    print("All lean-music-app checks passed.")
    exit(EXIT_SUCCESS)
}

for failure in failures {
    fputs("FAIL: \(failure)\n", stderr)
}
exit(EXIT_FAILURE)
