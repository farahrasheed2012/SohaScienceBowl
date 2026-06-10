import SwiftUI
import WebKit

struct HTMLWebView: View {
    let url: URL
    var scrollToWeek: Int?

    var body: some View {
        HTMLWebViewRepresentable(url: url, scrollToWeek: scrollToWeek)
            .ignoresSafeArea(edges: .bottom)
    }
}

enum HTMLWebViewNavigation {
    static func scrollScript(week: Int) -> String {
        """
        (function() {
          var w = \(week);
          var el = document.getElementById('week-' + w);
          if (!el) {
            var sections = document.querySelectorAll('section.week');
            if (sections.length >= w) el = sections[w - 1];
          }
          if (!el) {
            var tags = Array.from(document.querySelectorAll('.week-tag')).filter(function(t) {
              return new RegExp('^Week\\\\s*' + w + '\\\\b').test(t.textContent.trim());
            });
            if (tags[0]) {
              el = tags[0].closest('section') || tags[0].closest('article') || tags[0].closest('h4') || tags[0];
            }
          }
          if (el) {
            el.scrollIntoView({ behavior: 'instant', block: 'start' });
            return true;
          }
          return false;
        })();
        """
    }

    static func scroll(toWeek week: Int, in webView: WKWebView, completion: ((Bool) -> Void)? = nil) {
        webView.evaluateJavaScript(scrollScript(week: week)) { result, _ in
            completion?((result as? Bool) == true)
        }
    }
}

#if os(macOS)
private struct HTMLWebViewRepresentable: NSViewRepresentable {
    let url: URL
    var scrollToWeek: Int?

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let view = WKWebView(frame: .zero, configuration: config)
        view.setValue(false, forKey: "drawsBackground")
        view.navigationDelegate = context.coordinator
        return view
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        let coordinator = context.coordinator

        if coordinator.loadedURL != url {
            coordinator.loadedURL = url
            coordinator.pendingWeek = scrollToWeek
            coordinator.lastScrolledWeek = nil
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
            return
        }

        guard let week = scrollToWeek, week != coordinator.lastScrolledWeek else { return }
        coordinator.pendingWeek = week
        HTMLWebViewNavigation.scroll(toWeek: week, in: webView) { success in
            if success {
                coordinator.lastScrolledWeek = week
                coordinator.pendingWeek = nil
            }
        }
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var loadedURL: URL?
        var pendingWeek: Int?
        var lastScrolledWeek: Int?

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            guard let week = pendingWeek else { return }
            HTMLWebViewNavigation.scroll(toWeek: week, in: webView) { [weak self] success in
                if success {
                    self?.lastScrolledWeek = week
                    self?.pendingWeek = nil
                }
            }
        }
    }
}
#else
private struct HTMLWebViewRepresentable: UIViewRepresentable {
    let url: URL
    var scrollToWeek: Int?

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let coordinator = context.coordinator

        if coordinator.loadedURL != url {
            coordinator.loadedURL = url
            coordinator.pendingWeek = scrollToWeek
            coordinator.lastScrolledWeek = nil
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
            return
        }

        guard let week = scrollToWeek, week != coordinator.lastScrolledWeek else { return }
        coordinator.pendingWeek = week
        HTMLWebViewNavigation.scroll(toWeek: week, in: webView) { success in
            if success {
                coordinator.lastScrolledWeek = week
                coordinator.pendingWeek = nil
            }
        }
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var loadedURL: URL?
        var pendingWeek: Int?
        var lastScrolledWeek: Int?

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            guard let week = pendingWeek else { return }
            HTMLWebViewNavigation.scroll(toWeek: week, in: webView) { [weak self] success in
                if success {
                    self?.lastScrolledWeek = week
                    self?.pendingWeek = nil
                }
            }
        }
    }
}
#endif
