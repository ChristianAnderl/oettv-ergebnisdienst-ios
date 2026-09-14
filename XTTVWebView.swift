import SwiftUI
import WebKit

struct XTTVWebView: UIViewRepresentable {
    let url: URL
    @EnvironmentObject private var store: AppStore

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if webView.url != url {
            webView.load(URLRequest(url: url))
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(store: store)
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        let store: AppStore
        init(store: AppStore) { self.store = store }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            store.lastURL = webView.url?.absoluteString
        }
    }
}
