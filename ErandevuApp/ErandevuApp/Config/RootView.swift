import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack(path: $appState.path) {
            // Başlangıç görünümü her zaman ContentView
            ContentView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        ContentView()

                    case .registerFirma:
                        RegisterFirmaView()

                    case .registerMusteri:
                        RegisterMusteriView()

                    case .login:
                        LoginView()

                    case .register:
                        RegisterView()

                    case .emailVerification:
                        if let email = appState.userEmail {
                            EmailVerificationView(email: email)
                        } else {
                            ContentView()
                        }

                    case .account:
                        if appState.isLoggedIn, let firma = appState.company {
                            AccountView(company: firma)
                        } else {
                            ContentView()
                        }

                    case .customerAccount:
                        if appState.isLoggedIn, let customer = appState.customer {
                            CustomerAccountView(customer: customer)
                        } else {
                            ContentView()
                        }

                    case .slotList:
                        if appState.isLoggedIn, let firma = appState.company {
                            AccountView(company: firma)
                            SlotListView(companyID: firma.id)
                        } else {
                            ContentView()
                        }
                       

                    case .randevu:
                        RandevuKayitView()

                    case .firmaAccount:
                        if appState.isLoggedIn, let firma = appState.company {
                            AccountView(company: firma)
                        } else {
                            ContentView()
                        }
                    }
                }


            
        }
    }
}
