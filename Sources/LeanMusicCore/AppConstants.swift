import Foundation

public enum AppConstants {
    public static let productName = "Lean Music App"
    public static let bundleIdentifier = "io.github.lijuno.lean-music-app"
    public static let homeURL = URL(string: "https://music.youtube.com/")!

    public static let offlineMessage = """
    YouTube Music could not load while this Mac is offline. Offline playback is available only when YouTube provides it through its official web experience for your account, region, and device. This app does not download or extract music independently.
    """

    public static let helpMessage = """
    Lean Music App is an independent wrapper for the official YouTube Music website.

    Your sign-in is stored by WebKit on this Mac. YouTube Music Premium downloads, when available, remain encrypted and controlled entirely by YouTube. This app cannot create its own offline copies, and offline availability may vary by account, region, and WebKit support.
    """
}
