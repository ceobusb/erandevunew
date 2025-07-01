import SwiftUI
import CoreLocation


struct RegisterMusteriView: View {
    @EnvironmentObject var appState: AppState

    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    @State private var address = ""
    @StateObject private var locationManager = LocationManager()

    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showMenu = false
    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        Group {
            if isLoading {
                ProgressView("Kayıt yapılıyor...")
                    .padding()
            } else {
                CustomHeaderView(title: "") {
                              presentationMode.wrappedValue.dismiss()
                          }
                    ScrollView {
                        VStack(spacing: 16) {
                            Text("Müşteri Kaydı")
                                .font(.title)
                                .bold()
                            
                            TextField("Ad Soyad", text: $fullName)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                            
                            TextField("E-posta", text: $email)
                                .keyboardType(.emailAddress)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                            
                            SecureField("Şifre", text: $password)
                                .textContentType(.newPassword)
                                   .autocorrectionDisabled(true)
                                   .textInputAutocapitalization(.never)
                                   .padding()
                                   .background(Color(.secondarySystemBackground))
                                   .cornerRadius(10)
                            
                            SecureField("Şifre Tekrar", text: $confirmPassword)
                                .textContentType(.newPassword)
                                  .autocorrectionDisabled(true)
                                  .textInputAutocapitalization(.never)
                                  .padding()
                                  .background(Color(.secondarySystemBackground))
                                  .cornerRadius(10)
                            
                            TextField("Adres", text: $address)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                            
                            if let location = locationManager.location {
                                Text("Konum: \(location.latitude), \(location.longitude)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            } else {
                                Text("Konum alınamadı")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            
                            Button("Kayıt Ol") {
                                validateAndRegister()
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding()
                    }
                    .navigationBarBackButtonHidden(true)
                    .navigationTitle("")
                
            }
        }
        .onAppear {
            locationManager.requestLocation()
        }
        .alert("Uyarı", isPresented: $showAlert) {
            Button("Tamam") {
                if alertMessage.contains("başarı") {
                    appState.userEmail = email
                  
                    appState.path = []
                    appState.path.append(.emailVerification)
                }
            }
        } message: {
            Text(alertMessage)
        }
    }

    func validateAndRegister() {
        guard !fullName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              password == confirmPassword,
              !address.isEmpty,
              let loc = locationManager.location else {
            alertMessage = "Lütfen tüm alanları eksiksiz doldurun."
            showAlert = true
            return
        }

        isLoading = true

        MusteriService.registerMusteri(
            fullName: fullName,
            email: email,
            password: password,
            address: address,
            latitude: loc.latitude,
            longitude: loc.longitude
        ) { success, message in
            DispatchQueue.main.async {
                isLoading = false
                alertMessage = message
                showAlert = true
            }
        }
    }
}
