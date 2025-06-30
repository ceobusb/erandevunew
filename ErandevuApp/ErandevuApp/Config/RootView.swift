import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack(path: $appState.path) {
            // Başlangıç görünümü her zaman ContentView
            ContentView()
                .navigationDestination(for: String.self) { route in
                    switch route {
                    case "Home":
                        ContentView()
                    case "RegisterFirma":
                        RegisterFirmaView()
                    case "RegisterMusteri":
                        RegisterMusteriView()
                    case "Login":
                        LoginView()
                    case "Register":
                        RegisterView()
                        
                    case "EmailVerification":
                        if let email = appState.userEmail {
                            EmailVerificationView(email: email)
                        } else {
                            ContentView()
                        }
                        
                    case "Account":
                        if appState.isLoggedIn, let company = appState.company {
                            AccountView(company: company)
                        } else {
                            ContentView()
                        }
                        
                    case "SlotList":
                        if let company = appState.company {
                            SlotListView(companyID: company.id)
                        } else {
                            ContentView()
                        }
                        
                    case "Randevu":
                        RandevuKayitView()
                        
                    default:
                        Text("Sayfa bulunamadı")
                    }
                }
        }
    }
}
