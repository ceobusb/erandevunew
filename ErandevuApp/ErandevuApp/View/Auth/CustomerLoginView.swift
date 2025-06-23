import SwiftUI

struct CustomerLoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("userName") private var userName: String = ""

    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Müşteri Girişi")
                .font(.title)
                .bold()

            TextField("E-posta", text: $email)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)

            SecureField("Şifre", text: $password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)

            Button("Giriş Yap") {
                login()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Button("Hesabınız yok mu? Kayıt Ol") {
                // Yönlendirme yapılabilir
            }
            .font(.footnote)
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Uyarı"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
        }
    }

    func login() {
        if email == "test@example.com" && password == "123456" {
            userName = "Test Kullanıcısı"
            isLoggedIn = true
        } else {
            alertMessage = "Geçersiz giriş bilgileri"
            showAlert = true
        }
    }
}
