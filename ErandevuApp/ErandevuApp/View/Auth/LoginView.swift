import SwiftUI

struct LoginView: View {
    enum LoginType: String, CaseIterable {
        case firma = "Firma Girişi"
        case musteri = "Müşteri Girişi"
    }
    
    var redirectAfter: AppRoute? = nil 
    @State private var selectedLoginType: LoginType = .firma
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = LoginViewModel()
    @State private var showMenu = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        CustomHeaderView(title: "") {
                      presentationMode.wrappedValue.dismiss()
                  }
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                    
                    Picker("Giriş Tipi", selection: $selectedLoginType) {
                        ForEach(LoginType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    Text(selectedLoginType.rawValue)
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
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                    
                    Button(action: {
                        viewModel.login(appState: appState, userType: selectedLoginType)
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
                    
                    Button {
                        appState.path = []
                        appState.path.append(.register)
                    } label: {
                        Text("Hesabınız yok mu? Kayıt olun")
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationBarBackButtonHidden(true)
                .navigationTitle("")
            }
        
    }
}
