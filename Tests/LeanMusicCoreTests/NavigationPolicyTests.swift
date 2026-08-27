import Foundation
import Testing
@testable import LeanMusicCore

@Test func trustedDestinationsStayInApp() throws {
    let urls = [
        "https://music.youtube.com/",
        "https://accounts.google.com/signin",
        "https://www.youtube.com/watch?v=123",
        "https://support.google.com/youtubemusic/",
        "about:blank"
    ]

    for rawURL in urls {
        let url = try #require(URL(string: rawURL))
        #expect(NavigationPolicy.destination(for: url) == .inApp, Comment(rawValue: rawURL))
    }
}

@Test func trustedBlobRequiresTrustedCreatorAndEmbeddedOrigin() throws {
    let trustedBlob = try #require(URL(string: "blob:https://music.youtube.com/1234"))
    #expect(
        NavigationPolicy.destination(
            for: trustedBlob,
            currentPageURL: AppConstants.homeURL
        ) == .inApp
    )

    let externalBlob = try #require(URL(string: "blob:https://example.com/1234"))
    #expect(
        NavigationPolicy.destination(
            for: externalBlob,
            currentPageURL: AppConstants.homeURL
        ) == .blocked
    )
    #expect(NavigationPolicy.destination(for: trustedBlob, currentPageURL: nil) == .blocked)
}

@Test func userInitiatedExternalDestinationsOpenOutsideApp() throws {
    let urls = [
        "https://example.com/",
        "https://youtube.com.example.org/",
        "mailto:hello@example.com"
    ]

    for rawURL in urls {
        let url = try #require(URL(string: rawURL))
        #expect(
            NavigationPolicy.destination(for: url, isUserInitiated: true) == .external,
            Comment(rawValue: rawURL)
        )
    }
}

@Test func untrustedAutomaticAndUnsafeDestinationsAreBlocked() throws {
    let urls = [
        "data:text/html,blocked",
        "javascript:alert(1)",
        "custom-scheme://open",
        "http://music.youtube.com/",
        "about:config"
    ]

    for rawURL in urls {
        let url = try #require(URL(string: rawURL))
        #expect(
            NavigationPolicy.destination(
                for: url,
                currentPageURL: AppConstants.homeURL
            ) == .blocked,
            Comment(rawValue: rawURL)
        )
    }

    let externalURL = try #require(URL(string: "https://example.com/"))
    #expect(NavigationPolicy.destination(for: externalURL) == .blocked)
}

@Test func lookalikeHostsAreNeverTrusted() throws {
    let urls = [
        "https://youtube.com.example.org/",
        "https://google.com.evil.test/",
        "https://notyoutube.com/"
    ]

    for rawURL in urls {
        let url = try #require(URL(string: rawURL))
        #expect(NavigationPolicy.destination(for: url) == .blocked, Comment(rawValue: rawURL))
    }
}
