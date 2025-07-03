import SwiftUI

struct EmailVerificationView: View {
    let email: String

    @State private var code: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isVerifying = false
    @State private var isCodeResending = false
    @State private var onAlertDismissed = false

    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 24) {
            Text("E-Posta Doğrulama")
                .font(.title)
                .fontWeight(.bold)

            Text("Lütfen \(email) adresine gönderilen 4 haneli kodu girin.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            TextField("4 Haneli Kod", text: $code)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .frame(maxWidth: 200)

            Button(action: verifyCode) {
                if isVerifying {
                    ProgressView()
                } else {
                    Text("Kodu Doğrula")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .disabled(isVerifying)

            Button(action: resendCode) {
                if isCodeResending {
                    ProgressView()
                } else {
                    Text("Kodu Tekrar Gönder")
                        .foregroundColor(.blue)
                }
            }
            .padding(.top, 8)

            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Bilgi"),
                message: Text(alertMessage),
                dismissButton: .default(Text("Tamam")) {
                    if onAlertDismissed {
                        appState.userEmail = email
                        appState.isEmailVerified = true
                        appState.isLoggedIn = false // login henüz yapılmadı
                        
                        appState.path = []
                        appState.path.append(.login(redirectAfter: .randevu))
                      
                        onAlertDismissed = false
                    }
                }
            )
        }
    }

    func verifyCode() {
        guard code.count == 4 else {
            alertMessage = "Lütfen 4 haneli bir kod girin."
            showAlert = true
            return
        }

        isVerifying = true
        EmailAPI.confirmVerificationCode(email: email, code: code) { success, message, data in
            DispatchQueue.main.async {
                isVerifying = false
                if success {
                    alertMessage = "Doğrulama başarılı"
                    onAlertDismissed = true
                    showAlert = true
                } else {
                    alertMessage = message
                    showAlert = true
                }
            }
        }
    }

    func resendCode() {
        isCodeResending = true
        EmailAPI.sendVerificationCodeNew(email: email) { success, message in
            DispatchQueue.main.async {
                isCodeResending = false
                alertMessage = message
                showAlert = true
            }
        }
    }
}
