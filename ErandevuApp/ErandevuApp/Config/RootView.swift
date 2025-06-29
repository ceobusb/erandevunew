import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack(path: $appState.path) {
            Group {
                if !appState.isLoggedIn {
                    if !appState.isEmailVerified {
                        if let email = appState.userEmail {
                            EmailVerificationView(email: email)
                        } else {
                            ContentView()
                        }
                    } else {
                        LoginView()
                    }
                } else {
                    ContentView()
                }
            }
            .navigationDestination(for: String.self) { route in
                switch route {
                case "Account":
                    if let company = appState.company {
                        AccountView(company: company)
                    } else {
                        Text("Firma bilgisi eksik")
                    }

                case "Register":
                    RegisterView()
                case "EmailVerification":
                    if let email = appState.userEmail {
                        EmailVerificationView(email: email)
                    } else {
                        Text("E-posta bulunamadı")
                    }
                default:
                    Text("Sayfa bulunamadı")
                }
            }
        }

    }
}
