import Darwin
import Foundation
import YTMusicCore

private var failures: [String] = []

@MainActor
private func expect(_ condition: @autoclosure () -> Bool, _ message: String) {
    if !condition() {
        failures.append(message)
    }
}

expect(AppConstants.productName == "YT Music App", "Unexpected product name")
expect(
    AppConstants.bundleIdentifier == "io.github.lijuno.yt-music-app",
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
    "blob:https://music.youtube.com/1234"
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
        NavigationPolicy.destination(for: url) == .external,
        "Expected external navigation for \(rawURL)"
    )
}

if failures.isEmpty {
    print("All YT Music App checks passed.")
    exit(EXIT_SUCCESS)
}

for failure in failures {
    fputs("FAIL: \(failure)\n", stderr)
}
exit(EXIT_FAILURE)
