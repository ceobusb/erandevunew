import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage = ""

    func login(appState: AppState) {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Tüm alanları doldurun"
            return
        }

        isLoading = true
        errorMessage = ""

        FirmaService.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let company):
                    appState.company = company
                    appState.isLoggedIn = true
                    appState.completeLogin() // ✅ Stack temizle
                    appState.path.append("Account") // ✅ Hesap ekranına git
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
