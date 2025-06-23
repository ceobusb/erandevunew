import SwiftUI

struct LoginView: View {
    enum LoginType: String, CaseIterable {
        case firma = "Firma Girişi"
        case musteri = "Müşteri Girişi"
    }

    @State private var selectedLoginType: LoginType = .firma
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Giriş Tipi Seçimi
            Picker("Giriş Tipi", selection: $selectedLoginType) {
                ForEach(LoginType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            Text("\(selectedLoginType.rawValue)")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(selectedLoginType == .firma ?
                 "Lütfen firmanıza ait kullanıcı bilgilerinizle giriş yapın." :
                 "Lütfen müşteri bilgilerinizle giriş yapın.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            TextField("E-posta", text: $email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            SecureField("Şifre", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            Button(action: {
                login()
            }) {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    Text("Giriş Yap")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }

            Spacer()

            NavigationLink(destination: RegisterView()) {
                Text("Hesabınız yok mu? Kayıt olun")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }

            Spacer()
        }
        .padding()
        .navigationTitle(selectedLoginType.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }

    func login() {
        isLoading = true
        showError = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            if email.lowercased() == "busra@makro2000.com.tr" && password == "123456" {
                // başarılı giriş — yönlendirme yapılabilir
            } else {
                showError = true
                errorMessage = "Geçersiz e-posta veya şifre."
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}
