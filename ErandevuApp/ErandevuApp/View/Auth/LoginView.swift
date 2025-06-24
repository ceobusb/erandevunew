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
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        VStack(spacing: 20) {
            
        NavigationStack {
                if isLoggedIn {
                    MyCompanyProfileView()

                } else {
              
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

                    Text(
                        selectedLoginType == .firma
                            ? "Lütfen firmanıza ait kullanıcı bilgilerinizle giriş yapın."
                            : "Lütfen müşteri bilgilerinizle giriş yapın."
                    )
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                    TextField("E-posta", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)

                    SecureField("Şifre", text: $viewModel.password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)

                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }

                    Button(action: {
                        viewModel.login()
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
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
            }
            
         
        }
        .navigationDestination(isPresented: $viewModel.navigateToDashboard) {
            MyCompanyProfileView()

        }

        .padding()
        .navigationTitle(selectedLoginType.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        if !viewModel.errorMessage.isEmpty {
            Text(viewModel.errorMessage)
                .foregroundColor(.red)
                .font(.footnote)
        }

     
    }

}
