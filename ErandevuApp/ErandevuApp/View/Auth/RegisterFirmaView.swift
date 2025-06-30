import SwiftUI
import CoreLocation

struct RegisterFirmaView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var companyName = "busra"
    @State private var selectedSector: Sector?
    @State private var sectors: [Sector] = []
    @State private var companyInfo = "busra"
    
    @State private var showImagePicker = false
    @State private var logoImage: UIImage?
    
    @State private var address = "busra"
    @StateObject private var locationManager = LocationManager()
    
    @State private var fullName = "busra"
    @State private var email = "Suarehali@gmail.com"
    @State private var password = "11"
    @State private var confirmPassword = "11"
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var isLoading = false
    @State private var showSectorDialog = false
    
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Kayıt yapılıyor...")
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        Text("Firma Kaydı")
                            .font(.title)
                            .bold()
                        
                        TextField("Firma Adı", text: $companyName)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        // Sektör seçimi
                        Button(action: { showSectorDialog = true }) {
                            HStack {
                                Text(selectedSector?.title ?? "Sektör Seçin")
                                    .foregroundColor(selectedSector == nil ? .gray : .primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        }
                        .confirmationDialog("Sektör Seçin", isPresented: $showSectorDialog) {
                            ForEach(sectors, id: \.id) { sector in
                                Button(sector.title) {
                                    selectedSector = sector
                                }
                            }
                        }
                        
                        // Açıklama
                        TextEditor(text: $companyInfo)
                            .frame(height: 100)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                        
                        // Logo
                        if let image = logoImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .cornerRadius(10)
                        }
                        
                        Button("Logo Seç (500x500 JPG)") {
                            showImagePicker = true
                        }
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker(image: $logoImage)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        
                        TextField("Açık Adres", text: $address)
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
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        SecureField("Şifre Tekrar", text: $confirmPassword)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        Button("Kayıt Ol") {
                            validateAndRegister()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            SectorService.fetchSectors { self.sectors = $0 }
        }
        .alert("Uyarı", isPresented: $showAlert) {
            Button("Tamam") {
                if alertMessage.contains("başarı") {
                    appState.userEmail = email
                    appState.path.append("EmailVerification")
                }
            }
        } message: {
            Text(alertMessage)
        }



    }
    
    func validateAndRegister() {
        guard !companyName.isEmpty,
              let selected = selectedSector,
              !companyInfo.isEmpty,
              let logo = logoImage,
              !address.isEmpty,
              let loc = locationManager.location,
              !fullName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              password == confirmPassword else {
            alertMessage = "Lütfen tüm alanları eksiksiz ve doğru doldurun."
            showAlert = true
            return
        }
        
        isLoading = true
        
        FirmaService.registerFirma(
            companyName: companyName,
            sectorID: selected.id,
            description: companyInfo,
            address: address,
            latitude: loc.latitude,
            longitude: loc.longitude,
            fullName: fullName,
            email: email,
            password: password,
            logo: logo
        ) { success, message in
            DispatchQueue.main.async {
                isLoading = false
                if success {
                    // önce alert'ı göster
                    alertMessage = message
                    showAlert = true

                } else {
                    alertMessage = message
                    showAlert = true
                }

            }
        }
    }
}
