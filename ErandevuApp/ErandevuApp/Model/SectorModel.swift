import SwiftUI // ← Bunu ekle
import Foundation
struct Sector: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let colorName: String // ← string olarak tanımlıyoruz
    let description: String

    var color: Color {
        switch colorName {
        case "blue": return .blue
        case "green": return .green
        case "red": return .red
        case "purple": return .purple
        case "teal": return .teal
        case "indigo": return .indigo
        default: return .gray
        }
    }
}
