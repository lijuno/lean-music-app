import Foundation

public enum BrowserIdentity {
    public static var safariApplicationName: String {
        let safariBundle = Bundle(path: "/Applications/Safari.app")
        let installedVersion = safariBundle?
            .object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        return safariApplicationName(installedSafariVersion: installedVersion)
    }

    public static func safariApplicationName(installedSafariVersion: String?) -> String {
        let version = normalizedSafariVersion(installedSafariVersion) ?? "17.0"
        return "Version/\(version) Safari/605.1.15"
    }

    private static func normalizedSafariVersion(_ value: String?) -> String? {
        guard let value else { return nil }
        let components = value.split(separator: ".")
        guard !components.isEmpty,
              components.allSatisfy({ component in
                  !component.isEmpty && component.allSatisfy(\.isNumber)
              }) else {
            return nil
        }
        return components.prefix(3).joined(separator: ".")
    }
}
