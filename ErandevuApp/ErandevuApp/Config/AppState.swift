import SwiftUI

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var isEmailVerified: Bool = false
    @Published var FirmaId: Int = 0
    @Published var showMenu: Bool = false
    @Published var FirmaAdi: String = ""
    @Published var company: CompanyModel? = nil
    @Published var customer: CustomerModel? 

    @Published var FirmaLogo: String? = nil
    
    @Published var path: [AppRoute] = []
    @Published var userType: UserType?
    @Published var userEmail: String? = nil
    @Published var role: Int? = nil
    @Published var locationManager = LocationManager()
    @Published var redirectToRoute: AppRoute? = nil



    // ✅ Giriş tamamlandığında ContentView'den Account'a geçiş
    func completeLogin() {
        isLoggedIn = true
        path = []
        switch userType {
        case .firma:
            path.append(.account)
        case .customer:
            path.append(.customerAccount)
        case .none:
            path.append(.home)
        }
    }



    // ✅ Email doğrulandıktan sonra login'e değil Account'a yönlendir
    func completeEmailVerification() {
        isEmailVerified = true
        path = []

        guard let userType = userType else {
            path.append(.home)
            return
        }

        switch userType {
        case .firma:
            path.append(.account)
        case .customer:
            path.append(.customerAccount)
        }
    }
    
    
 

    var currentLatitude: Double {
        if let lat = company?.latitude {
            return lat
        } else if let lat = customer?.latitude {
            return lat
        } else if let lat = locationManager.location?.latitude {
            return lat
        } else {
            return 41.0082 // fallback: İstanbul
        }
    }

    var currentLongitude: Double {
        if let lon = company?.longitude {
            return lon
        } else if let lon = customer?.longitude {
            return lon
        } else if let lon = locationManager.location?.longitude {
            return lon
        } else {
            return 28.9784 // fallback: İstanbul
        }
    }







    // ✅ Çıkış işlemi
    func logout() {
        isLoggedIn = false
        isEmailVerified = false
        userEmail = nil
        showMenu = false
        FirmaId = 0
        role = nil
        FirmaAdi = ""
        company = nil
        FirmaLogo = nil

     
        DispatchQueue.main.async {
            self.path = []
            self.path.append(.home)
        }
    }
}
