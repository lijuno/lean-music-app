import Foundation

public enum NavigationDestination: Equatable {
    case inApp
    case external
    case blocked
}

public enum NavigationPolicy {
    private static let trustedDomains = [
        "youtube.com",
        "google.com"
    ]

    public static func destination(
        for url: URL,
        isUserInitiated: Bool = false,
        currentPageURL: URL? = nil
    ) -> NavigationDestination {
        guard let scheme = url.scheme?.lowercased() else {
            return .blocked
        }

        if scheme == "about" {
            return url.absoluteString.lowercased() == "about:blank" ? .inApp : .blocked
        }

        if scheme == "blob" {
            guard let currentPageURL,
                  isTrustedHTTPSURL(currentPageURL),
                  let embeddedURL = URL(string: String(url.absoluteString.dropFirst("blob:".count))),
                  isTrustedHTTPSURL(embeddedURL) else {
                return .blocked
            }
            return .inApp
        }

        if scheme == "mailto" {
            return isUserInitiated ? .external : .blocked
        }

        if isTrustedHTTPSURL(url) {
            return .inApp
        }

        if scheme == "http" || scheme == "https" {
            return isUserInitiated ? .external : .blocked
        }

        return .blocked
    }

    private static func isTrustedHTTPSURL(_ url: URL) -> Bool {
        guard url.scheme?.lowercased() == "https",
              let host = url.host?.lowercased() else {
            return false
        }

        return trustedDomains.contains { domain in
            host == domain || host.hasSuffix(".\(domain)")
        }
    }
}
