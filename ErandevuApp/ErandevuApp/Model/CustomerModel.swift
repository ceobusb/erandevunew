
import SwiftUI
struct CustomerModel: Codable {
    let id: Int
    let company_name: String?         // backend'de "" geliyor
    let logo_path: String?
    let description: String?
    let address: String
    let latitude: Double
    let longitude: Double
    let full_name: String
    let sector_id: Int?
    let sektor_name: String?
    let status: Int
    let created_at: String?
    let email: String?
}

struct APIResponseCustomer: Codable {
    let status: Bool
    let message: String
    let data: CustomerModel?
}
