import SwiftUI

class AppState: ObservableObject {
    // Kullanıcının giriş yapıp yapmadığını tutar
    @Published var isLoggedIn: Bool = false
    @Published var isEmailVerified: Bool = false
    @Published var FirmaId: Int = 0
    @Published var FirmaAdi: String = ""
    @Published var company: CompanyModel? // ✅ EKLE
    @Published var FirmaLogo: String? = nil
    

    // E-mail bilgisi (kayıt aşamasında tutulur)
    @Published var userEmail: String? = nil

    // Navigation için path yapısı (stack kontrolü için)
    @Published var path = NavigationPath()

    // Girişten sonra stack'i sıfırlayıp ana sayfaya yönlendir
    func completeLogin() {
        isLoggedIn = true
        path = NavigationPath() // stack temizlenir
    }

    // E-posta doğrulandıktan sonra giriş ekranına değil, direkt hesap ekranına yönlen
    func completeEmailVerification() {
        isEmailVerified = true
        path = NavigationPath() // geçmişi sil
    }

    // Çıkış işlemi
    func logout() {
         isLoggedIn = false
         isEmailVerified = false
         userEmail = nil
         FirmaId = 0
          FirmaAdi = ""
         path = NavigationPath()
    }
}
