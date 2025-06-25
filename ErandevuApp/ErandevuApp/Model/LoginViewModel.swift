import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage = ""

    @AppStorage("firmaID") var firmaID: String = "0"
    @AppStorage("firmaName") var firmaName: String = ""

    func login(onSuccess: @escaping () -> Void) {
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
                    self.firmaID = company.firma_id
                    self.firmaName = company.company_name

                    // Giriş başarılıysa dışarıdan verilen işlem çalıştırılır
                    onSuccess()

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
