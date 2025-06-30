import SwiftUI

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var isEmailVerified: Bool = false
    @Published var FirmaId: Int = 0
    @Published var showMenu: Bool = false
    @Published var FirmaAdi: String = ""
    @Published var company: CompanyModel? = nil
    @Published var FirmaLogo: String? = nil
    @Published var path = NavigationPath()
    @Published var userEmail: String? = nil

    // ✅ Giriş tamamlandığında ContentView'den Account'a geçiş
    func completeLogin() {
        isLoggedIn = true
        path = NavigationPath()
        path.append("Account") // veya "Home" yapmak istersen değiştirebilirsin
    }

    // ✅ Email doğrulandıktan sonra login'e değil Account'a yönlendir
    func completeEmailVerification() {
        isEmailVerified = true
        path = NavigationPath()
        path.append("Account")
    }

    // ✅ Çıkış işlemi
    func logout() {
        isLoggedIn = false
        isEmailVerified = false
        userEmail = nil
        showMenu = false
        FirmaId = 0
        FirmaAdi = ""
        company = nil
        FirmaLogo = nil

        DispatchQueue.main.async {
            self.path = NavigationPath()
            self.path.append("Home") // Çıkıştan sonra Home'a yönlendir
        }
    }
}
