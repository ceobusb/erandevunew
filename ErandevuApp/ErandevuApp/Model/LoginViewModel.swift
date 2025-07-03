import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage = ""
  
    var onLoginSuccess: () -> Void

    init(onLoginSuccess: @escaping () -> Void = {}) {
        self.onLoginSuccess = onLoginSuccess
    }

    func login(appState: AppState, userType: LoginView.LoginType) {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Tüm alanları doldurun"
            return
        }

        isLoading = true
        errorMessage = ""

        switch userType {
        case .firma:
            FirmaService.login(email: email, password: password) { result in
                DispatchQueue.main.async {
                    self.isLoading = false
                  
                    switch result {
                    case .success(let company):
                        appState.userType = .firma
                        appState.company = company
                        appState.role = 1
                        appState.isLoggedIn = true
                        appState.path.append(.firmaAccount)

                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
            }

        case .musteri:
            MusteriService.login(email: email, password: password) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let musteri):
                        appState.userType = .customer
                        appState.customer = musteri
                        appState.role = 2
                        appState.isLoggedIn = true
                        appState.path.append(.customerAccount)
                        self.onLoginSuccess()



                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
                
            }


        }
    }

}
