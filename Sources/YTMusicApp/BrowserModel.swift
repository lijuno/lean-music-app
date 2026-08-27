import AppKit
import Combine
import WebKit
import YTMusicCore

@MainActor
final class BrowserModel: NSObject, ObservableObject {
    @Published private(set) var canGoBack = false
    @Published private(set) var canGoForward = false
    @Published private(set) var isLoading = false
    @Published private(set) var navigationError: Error?

    let webView: WKWebView

    override init() {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        configuration.mediaTypesRequiringUserActionForPlayback = []
        // WKWebView omits Safari's identifying suffix by default, which makes
        // YouTube Music reject the otherwise supported system WebKit engine.
        configuration.applicationNameForUserAgent = BrowserIdentity.safariApplicationName
        configuration.preferences.isElementFullscreenEnabled = true

        webView = WKWebView(frame: .zero, configuration: configuration)
        super.init()

        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsMagnification = true
        loadHome()
    }

    func loadHome() {
        navigationError = nil
        webView.load(URLRequest(url: AppConstants.homeURL))
    }

    func reload() {
        navigationError = nil
        if webView.url == nil {
            loadHome()
        } else {
            webView.reload()
        }
    }

    func goBack() {
        guard webView.canGoBack else { return }
        webView.goBack()
    }

    func goForward() {
        guard webView.canGoForward else { return }
        webView.goForward()
    }

    func dismissError() {
        navigationError = nil
    }

    private func updateState() {
        canGoBack = webView.canGoBack
        canGoForward = webView.canGoForward
        isLoading = webView.isLoading
    }

    private func open(_ url: URL) {
        switch NavigationPolicy.destination(for: url) {
        case .inApp:
            navigationError = nil
            webView.load(URLRequest(url: url))
        case .external:
            NSWorkspace.shared.open(url)
        }
    }
}

extension BrowserModel: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping @MainActor @Sendable (WKNavigationActionPolicy) -> Void
    ) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }

        if NavigationPolicy.destination(for: url) == .external {
            NSWorkspace.shared.open(url)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        navigationError = nil
        updateState()
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        updateState()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        navigationError = nil
        updateState()
    }

    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        recordNavigationFailure(error)
    }

    func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation!,
        withError error: Error
    ) {
        recordNavigationFailure(error)
    }

    private func recordNavigationFailure(_ error: Error) {
        let code = (error as NSError).code
        guard code != NSURLErrorCancelled else { return }
        navigationError = error
        updateState()
    }
}

extension BrowserModel: WKUIDelegate {
    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        guard navigationAction.targetFrame == nil,
              let url = navigationAction.request.url else {
            return nil
        }

        open(url)
        return nil
    }
}
