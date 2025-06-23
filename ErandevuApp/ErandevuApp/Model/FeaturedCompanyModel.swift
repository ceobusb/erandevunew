struct FeaturedCompany: Codable, Identifiable {
    let id: String
    let rating: Double
    let address: String
    let latitude: Double
    let longitude: Double
    let description: String
    let company_name: String
    let logo_url: String
}
