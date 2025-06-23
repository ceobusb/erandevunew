import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var navigateToDashboard = false

    @AppStorage("firmaID") var firmaID: String = "0"
    @AppStorage("firmaName") var firmaName: String = ""
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    



    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Tüm alanları doldurun"
            return
        }
        
        

        isLoading = true

        FirmaService.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let company):
                    self.firmaID = company.firma_id
                    self.firmaName = company.company_name
                    self.isLoggedIn = true
                    self.navigateToDashboard = true
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
   


    }
}
