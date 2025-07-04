import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var appState: AppState
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack(path: $appState.path) {
            ContentView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                        
                    case .sponsorDetail(let company):
                        CompanyProfileView(company: company, selectedTab: $selectedTab)
                        
                    case .sectorDetail(let sector):
                        SectorDetailView(sector: sector)
                        
                    case .home:
                        ContentView()
                        
                    case .registerFirma:
                        RegisterFirmaView()
                        
                    case .registerMusteri:
                        RegisterMusteriView()
                        
                    case .login(let redirectAfter):
                        LoginView(redirectAfter: redirectAfter)
                        
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
                            LoginView(redirectAfter: .account)
                        }
                        
                    case .customerAccount:
                        if appState.isLoggedIn, let customer = appState.customer {
                            CustomerAccountView(customer: customer)
                        } else {
                            LoginView(redirectAfter: .customerAccount)
                        }
                        
                    case .slotList:
                        if appState.isLoggedIn, let firma = appState.company {
                            SlotListView(companyID: firma.id)
                        } else {
                            LoginView(redirectAfter: .slotList)
                        }
                        
                    case .randevu:
                        RandevuKayitView()
                        
                        
                    case .randevularimcustomer:
                        if appState.isLoggedIn, let customer = appState.customer {
                            RandevuListCustomer(customer: customer)
                        } else {
                            LoginView(redirectAfter: .customerAccount)
                        }
                        
                    case .firmaRandevular:
                        if appState.isLoggedIn, let company = appState.company {
                            RandevuListFirma(company: company)
                        } else {
                            LoginView(redirectAfter: .customerAccount)
                        }
                        
                        
                        
                    case .firmaAccount:
                        if appState.isLoggedIn, let firma = appState.company {
                            AccountView(company: firma)
                        } else {
                            LoginView(redirectAfter: .firmaAccount)
                        }
                        
                    case .randevuAl(let firmaID):
                        if appState.isLoggedIn {
                            RandevuAlView(firmaID: firmaID)
                        } else {
                            LoginView(redirectAfter: .randevuAl(firmaID: firmaID))
                        }
                    }
                }.onChange(of: appState.redirectToRoute) { newRoute in
                    if let route = newRoute {
                        appState.path.append(route)
                        appState.redirectToRoute = nil // tek seferlik yönlendirme
                    }
                }
        }
    }
}
