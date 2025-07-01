import Foundation

enum AppRoute: Hashable {
    case home
    case registerFirma
    case registerMusteri
    case login
    case register
    case emailVerification
    case account       // Firma profili
    case customerAccount  // Müşteri profili
    case slotList
    case randevu
    case firmaAccount
    case sectorDetail(Sector)
    case sponsorDetail(FeaturedCompany)
}

enum UserType: String, Hashable {
    case firma
    case customer
}




