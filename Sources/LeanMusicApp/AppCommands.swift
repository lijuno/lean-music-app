import SwiftUI

struct AppCommands: Commands {
    @ObservedObject var browser: BrowserModel
    let appDelegate: AppDelegate

    var body: some Commands {
        CommandGroup(after: .appInfo) {
            Button("About Offline Playback…") {
                appDelegate.showOfflineHelp()
            }

            Divider()

            Button("Clear Website Data and Sign Out…") {
                guard appDelegate.confirmWebsiteDataReset() else { return }
                Task {
                    await browser.clearWebsiteData()
                }
            }
            .disabled(browser.isClearingWebsiteData)
        }

        CommandGroup(after: .newItem) {
            Button("Show Lean Music App") {
                appDelegate.showMainWindow()
            }
            .keyboardShortcut("0", modifiers: [.command])
        }

        CommandMenu("Navigation") {
            Button("Back", action: browser.goBack)
                .keyboardShortcut("[", modifiers: [.command])
                .disabled(!browser.canGoBack)

            Button("Forward", action: browser.goForward)
                .keyboardShortcut("]", modifiers: [.command])
                .disabled(!browser.canGoForward)

            Button("Reload", action: browser.reload)
                .keyboardShortcut("r", modifiers: [.command])

            Button("YouTube Music Home", action: browser.loadHome)
                .keyboardShortcut("h", modifiers: [.command, .shift])
        }
    }
}
