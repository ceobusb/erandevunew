struct FeaturedCompany: Codable, Identifiable, Hashable {
    let id: Int
    let rating: Double
    let address: String
    let latitude: Double
    let longitude: Double
    let description: String
    let sektor_name: String
    let icon: String
    let company_name: String
    let distance: Double?
    let logo_url: String
    let business_phone: String?
    let mobile_phone: String?
    let working_hours: String?

}


