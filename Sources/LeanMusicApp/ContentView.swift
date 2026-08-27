import SwiftUI
import LeanMusicCore

struct ContentView: View {
    @ObservedObject var browser: BrowserModel
    @ObservedObject var connectivity: ConnectivityMonitor

    private var shouldShowOfflineWarning: Bool {
        !connectivity.isConnected && browser.navigationError != nil
    }

    var body: some View {
        ZStack {
            BrowserView(webView: browser.webView)

            if shouldShowOfflineWarning {
                offlineWarning
                    .transition(.opacity)
            }
        }
        .frame(minWidth: 720, minHeight: 480)
        .toolbar {
            ToolbarItemGroup(placement: .navigation) {
                Button(action: browser.goBack) {
                    Label("Back", systemImage: "chevron.left")
                }
                .disabled(!browser.canGoBack)
                .help("Back")

                Button(action: browser.goForward) {
                    Label("Forward", systemImage: "chevron.right")
                }
                .disabled(!browser.canGoForward)
                .help("Forward")

                Button(action: browser.reload) {
                    Label("Reload", systemImage: "arrow.clockwise")
                }
                .help("Reload")

                Button(action: browser.loadHome) {
                    Label("YouTube Music Home", systemImage: "house")
                }
                .help("YouTube Music Home")
            }

            ToolbarItem(placement: .status) {
                if !connectivity.isConnected {
                    Label("Offline", systemImage: "wifi.slash")
                        .foregroundStyle(.secondary)
                        .help("This Mac is offline")
                } else if browser.isLoading {
                    ProgressView()
                        .controlSize(.small)
                        .help("Loading")
                } else {
                    HStack(spacing: 5) {
                        Image(systemName: "lock.fill")
                        Text(browser.currentHost)
                            .font(.caption.monospaced())
                    }
                        .foregroundStyle(.secondary)
                        .help("Current secure website")
                }
            }
        }
        .animation(.easeInOut(duration: 0.15), value: shouldShowOfflineWarning)
    }

    private var offlineWarning: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 42, weight: .medium))
                .foregroundStyle(.secondary)

            Text("Offline playback unavailable")
                .font(.title2.weight(.semibold))

            Text(AppConstants.offlineMessage)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 480)

            HStack {
                Button("Dismiss") {
                    browser.dismissError()
                }

                Button("Try Again") {
                    browser.reload()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(32)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18))
        .shadow(radius: 24)
        .padding(40)
    }
}
