import AppKit
import YTMusicCore

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    private var mainWindow: NSWindow?
    private var windowObserver: NSObjectProtocol?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        windowObserver = NotificationCenter.default.addObserver(
            forName: NSWindow.didBecomeMainNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let window = notification.object as? NSWindow else { return }
            Task { @MainActor in
                self?.configureMainWindow(window)
            }
        }

        if let window = NSApp.windows.first {
            configureMainWindow(window)
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }

    func applicationShouldHandleReopen(
        _ sender: NSApplication,
        hasVisibleWindows flag: Bool
    ) -> Bool {
        if !flag {
            showMainWindow()
        }
        return true
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        sender.orderOut(nil)
        return false
    }

    func showMainWindow() {
        guard let window = mainWindow ?? NSApp.windows.first else { return }
        configureMainWindow(window)
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(nil)
    }

    func showOfflineHelp() {
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = "About offline playback"
        alert.informativeText = AppConstants.helpMessage
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    private func configureMainWindow(_ window: NSWindow) {
        guard window.level == .normal else { return }
        if let mainWindow, mainWindow !== window { return }

        let isFirstConfiguration = mainWindow == nil
        mainWindow = window
        window.delegate = self
        window.isReleasedWhenClosed = false
        window.title = AppConstants.productName
        window.minSize = NSSize(width: 720, height: 480)
        if isFirstConfiguration {
            window.setContentSize(NSSize(width: 1180, height: 760))
        }
    }
}
