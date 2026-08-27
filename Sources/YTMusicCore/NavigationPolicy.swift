import Foundation

public enum NavigationDestination: Equatable {
    case inApp
    case external
}

public enum NavigationPolicy {
    private static let trustedDomains = [
        "youtube.com",
        "google.com"
    ]

    public static func destination(for url: URL) -> NavigationDestination {
        guard let scheme = url.scheme?.lowercased() else {
            return .inApp
        }

        if ["about", "blob", "data"].contains(scheme) {
            return .inApp
        }

        guard scheme == "http" || scheme == "https" else {
            return .external
        }

        guard let host = url.host?.lowercased() else {
            return .external
        }

        let isTrusted = trustedDomains.contains { domain in
            host == domain || host.hasSuffix(".\(domain)")
        }
        return isTrusted ? .inApp : .external
    }
}
