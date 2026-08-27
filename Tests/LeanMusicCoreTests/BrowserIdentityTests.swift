import Testing
@testable import LeanMusicCore

@Test func browserIdentityUsesInstalledSafariVersion() {
    #expect(
        BrowserIdentity.safariApplicationName(installedSafariVersion: "26.5.2")
            == "Version/26.5.2 Safari/605.1.15"
    )
}

@Test func browserIdentityRejectsMalformedSafariVersions() {
    let versions: [String?] = [nil, "", "invalid", "17.beta"]
    for version in versions {
        #expect(
            BrowserIdentity.safariApplicationName(installedSafariVersion: version)
                == "Version/17.0 Safari/605.1.15"
        )
    }
}

@Test func browserIdentityLimitsVersionPrecision() {
    #expect(
        BrowserIdentity.safariApplicationName(installedSafariVersion: "17.0.1.2")
            == "Version/17.0.1 Safari/605.1.15"
    )
}
