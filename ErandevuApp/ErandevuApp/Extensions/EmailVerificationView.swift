import SwiftUI

struct EmailVerificationView: View {
    let email: String

    @State private var code: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isVerifying = false
    @Environment(\.presentationMode) var presentationMode

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

            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Bilgi"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")) {
                if alertMessage == "Doğrulama başarılı" {
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }

    func verifyCode() {
        isVerifying = true
        EmailAPI.confirmVerificationCode(email: email, code: code) { success, message in
            DispatchQueue.main.async {
                isVerifying = false
                alertMessage = message
                showAlert = true
            }
        }
    }
}
