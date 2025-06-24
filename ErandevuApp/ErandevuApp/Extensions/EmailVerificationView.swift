import SwiftUI

struct EmailVerificationView: View {
    let email: String
    
    @State private var code: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isVerifying = false
    @State private var isCodeResending = false
    @State private var navigateToLogin = false
    @EnvironmentObject var appState: AppState
    var body: some View {
        Group {
            if !appState.isEmailVerified {
                ContentView()
            }
            else {
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
                                .progressViewStyle(CircularProgressViewStyle())
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
                                .progressViewStyle(CircularProgressViewStyle())
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
                            // Doğrulama başarılıysa LoginView'e yönlendir
                            if alertMessage == "Doğrulama başarılı" {
                                navigateToLogin = true
                                
                            }
                        }
                    )
                }
                .navigationDestination(isPresented: $navigateToLogin) {
                    LoginView()
                }
            }
        }
            
    }
    
    func verifyCode() {
        guard code.count == 4 else {
            alertMessage = "Lütfen 4 haneli bir kod girin."
            showAlert = true
            return
        }
        
        isVerifying = true
        EmailAPI.confirmVerificationCode(email: email, code: code) { success, message in
            DispatchQueue.main.async {
                appState.isEmailVerified=true
                isVerifying = false
                alertMessage = success ? "Doğrulama başarılı" : message
                showAlert = true
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
