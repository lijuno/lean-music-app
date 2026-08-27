import SwiftUI

@main
struct LeanMusicApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var browser = BrowserModel()
    @StateObject private var connectivity = ConnectivityMonitor()

    var body: some Scene {
        WindowGroup {
            ContentView(browser: browser, connectivity: connectivity)
        }
        .defaultSize(width: 1180, height: 760)
        .commands {
            AppCommands(browser: browser, appDelegate: appDelegate)
        }
    }
}
