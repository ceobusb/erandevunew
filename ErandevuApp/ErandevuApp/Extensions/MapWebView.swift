import SwiftUI
import WebKit

struct MapWebView: UIViewRepresentable {
    var latitude: Double
    var longitude: Double

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()

        let htmlString = loadMapHTML()
            .replacingOccurrences(of: "{{LAT}}", with: "\(latitude)")
            .replacingOccurrences(of: "{{LON}}", with: "\(longitude)")

        webView.loadHTMLString(htmlString, baseURL: nil)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func loadMapHTML() -> String {
        guard let filePath = Bundle.main.path(forResource: "map", ofType: "html"),
              let html = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            return "<html><body><p>Harita yüklenemedi.</p></body></html>"
        }
        return html
    }

}
