struct FeaturedCompany: Codable, Identifiable, Hashable {
    let id: Int
    let rating: Double
    let address: String
    let latitude: Double
    let longitude: Double
    let distance: Double
    let description: String
    let sektor_name: String
    let company_name: String
    let icon: String
    let logo_url: String
    let business_phone: String?   // ✅ null olabilir
    let mobile_phone: String?     // ✅ null olabilir
    let working_hours: String?    // ✅ null olabilir

}


