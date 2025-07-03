import Foundation

indirect enum AppRoute: Hashable {
    case home
    case registerFirma
    case registerMusteri
    case login(redirectAfter: AppRoute)
    case register
    case randevularimcustomer
    case emailVerification
    case account               // Firma profili
    case customerAccount       // Müşteri profili
    case slotList
    case randevu
    case firmaAccount
    case sectorDetail(Sector)
    case sponsorDetail(FeaturedCompany)
    case randevuAl(firmaID: Int)
}


enum UserType: String, Hashable {
    case firma
    case customer
}




