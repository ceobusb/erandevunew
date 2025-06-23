import SwiftUI

struct Company: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
    let rating: Double
    let description: String
    let latitude: Double
    let longitude: Double
    let address: String
    let completedJobs: Int
    
    

    var initial: String {
        String(name.prefix(1))
    }
}

struct Sponsor: Identifiable {
    let id: UUID
    let name: String
    let logoUrl: String
    let latitude: Double
    let longitude: Double
    let description: String
    let rating: Double
    let address: String
}

struct CompanyModel: Codable {
    let firma_id: String
    let company_name: String
    let email: String
}




