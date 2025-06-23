import SwiftUI

struct Company: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
    let rating: Double
    let description: String
    let address: String
    let completedJobs: Int

    var initial: String {
        String(name.prefix(1))
    }
}

struct Sponsor: Identifiable {
    let id = UUID()
    let name: String
    let logoName: String
    let description: String
    let rating: Double
    let address: String
}

