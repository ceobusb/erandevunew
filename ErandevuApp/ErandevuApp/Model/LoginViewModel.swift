import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage = ""
    @EnvironmentObject var appState: AppState


    func login(appState: AppState, onSuccess: @escaping () -> Void) {
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
                    appState.FirmaId = company.id
                    appState.FirmaAdi = company.company_name
                    appState.company = company // ✅ EKLE
                    appState.isLoggedIn = true
                    onSuccess()

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }

    }

}
