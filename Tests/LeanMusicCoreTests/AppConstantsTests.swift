import Foundation
import Testing
@testable import LeanMusicCore

@Test func publicIdentityIsStable() {
    #expect(AppConstants.productName == "Lean Music App")
    #expect(AppConstants.bundleIdentifier == "io.github.lijuno.lean-music-app")
    #expect(AppConstants.homeURL.absoluteString == "https://music.youtube.com/")
}

@Test func limitationsRemainVisible() {
    #expect(AppConstants.offlineMessage.localizedCaseInsensitiveContains("does not download"))
    #expect(AppConstants.helpMessage.localizedCaseInsensitiveContains("independent wrapper"))
}
