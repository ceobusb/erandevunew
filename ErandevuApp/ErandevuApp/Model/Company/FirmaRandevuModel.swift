struct FirmaRandevuModel: Identifiable, Codable, Equatable {
    let id: Int
    let firma_id: Int
    let customer_id: Int
    let date: String
    let note: String?
    let status: Int  // dikkat: bu string gelmiş
    let created_at: String
    let firma_name: String?  // bu alan yeni eklendi
    let customer_name: String?  // bu alan yeni eklendi
    let cancel_reason: String?  // bu alan yeni eklendi
}




struct FirmaRandevuResponse: Codable {
    let status: Bool
    let message: String
    let data: [FirmaRandevuModel]
}
