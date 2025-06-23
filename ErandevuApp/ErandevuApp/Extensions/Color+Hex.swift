import SwiftUI

extension Color {
    init(hexOrName value: String) {
        if value.hasPrefix("#") {
            // HEX formatı
            let scanner = Scanner(string: value.replacingOccurrences(of: "#", with: ""))
            var rgb: UInt64 = 0
            if scanner.scanHexInt64(&rgb) {
                let r = Double((rgb >> 16) & 0xFF) / 255
                let g = Double((rgb >> 8) & 0xFF) / 255
                let b = Double(rgb & 0xFF) / 255
                self.init(red: r, green: g, blue: b)
                return
            }
        }

        // Sistem renk adıysa direkt kullan
        switch value.lowercased() {
        case "blue": self = .blue
        case "green": self = .green
        case "red": self = .red
        case "purple": self = .purple
        case "teal": self = .teal
        case "indigo": self = .indigo
        case "orange": self = .orange
        case "pink": self = .pink
        case "gray": self = .gray
        default: self = .black // fallback renk
        }
    }
}
