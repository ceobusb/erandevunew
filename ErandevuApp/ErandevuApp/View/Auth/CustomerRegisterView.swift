import SwiftUI

struct CustomerRegisterView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreedToTerms = false
    @State private var showAlert = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Müşteri Kayıt")
                .font(.largeTitle)
                .bold()
                .padding(.top, 40)

            Group {
                TextField("Ad Soyad", text: $name)
                TextField("E-posta", text: $email)
                    .keyboardType(.emailAddress)
                SecureField("Şifre", text: $password)
                SecureField("Şifre Tekrar", text: $confirmPassword)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)

            Toggle(isOn: $agreedToTerms) {
                Text("Kullanım şartlarını okudum ve kabul ediyorum")
                    .font(.footnote)
            }
            .padding(.horizontal)

            Button(action: {
                if formIsValid() {
                    // API kayıt işlemi buraya yazılır
                    showAlert = true
                }
            }) {
                Text("Kayıt Ol")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(agreedToTerms ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .disabled(!agreedToTerms)

            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Kayıt Başarılı"), message: Text("Hoş geldiniz, \(name)!"), dismissButton: .default(Text("Tamam")))
        }
    }

    private func formIsValid() -> Bool {
        return !name.isEmpty &&
               !email.isEmpty &&
               !password.isEmpty &&
               password == confirmPassword &&
               agreedToTerms
    }
}
