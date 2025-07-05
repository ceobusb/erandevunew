import SwiftUI
import FirebaseMessaging

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
                        appState.loginid = company.id
                        appState.role = 1
                        appState.isLoggedIn = true
                        appState.path.append(.firmaAccount)
                        
                        if let token = Messaging.messaging().fcmToken {
                            self.sendDeviceToken(userId: company.id, userType: "firma", token: token)
                        }

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
                        appState.loginid = musteri.id
                        appState.role = 2
                        appState.isLoggedIn = true
                        appState.path.append(.customerAccount)
                        self.onLoginSuccess()
                        if let token = Messaging.messaging().fcmToken {
                            self.sendDeviceToken(userId: musteri.id, userType: "musteri", token: token)
                        }


                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
                
            }


        }
    }
    
    func sendDeviceToken(userId: Int, userType: String, token: String) {
        guard let url = URL(string: "https://api.kurumsaleticaretsitesi.com/api/device_token_kaydet") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
     
        request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-Api-Key")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let postString = "user_id=\(userId)&user_type=\(userType)&device_token=\(token)"
        
        request.httpBody = postString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Cihaz token gönderilemedi: \(error.localizedDescription)")
            } else {
                print("✅ Cihaz token kaydedildi.")
            }
        }.resume()
    }


}


