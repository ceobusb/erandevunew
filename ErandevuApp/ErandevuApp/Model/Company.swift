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
    let business_phone: String
    let mobile_phone: String
    let working_hours: String
    
    

    var initial: String {
        String(name.prefix(1))
    }
}
struct Sponsor: Identifiable, Hashable {
    let id: UUID
    let name: String
    let logoUrl: String
    let latitude: Double
    let longitude: Double
    let description: String
    let rating: Double
    let address: String
    let business_phone: String
    let mobile_phone: String
    let working_hours: String
    
}

struct CompanyModel: Codable, Identifiable {
    let id: Int
    let company_name: String
    let sector_id: Int
    let description: String?
    let address: String?
    let latitude: Double?
    let longitude: Double?
    let full_name: String
    let email: String? // ← opsiyonel yapıldı
    let logo_path: String?
    let status: Int
    let created_at: String
    let sektor_name: String
    let business_phone: String?
      let mobile_phone: String?
      let working_hours: String?

    enum CodingKeys: String, CodingKey {
        case id
        case company_name
        case sector_id
        case description
        case address
        case latitude
        case longitude
        case full_name
        case email
        case logo_path
        case status
        case created_at
        case sektor_name
        case business_phone
        case mobile_phone
        case working_hours
    }
}








