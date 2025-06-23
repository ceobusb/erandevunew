import SwiftUI
import CoreLocation

struct RegisterView: View {
    @State private var companyName = ""
    @State private var selectedSector: Sector?
    @State private var sectors: [Sector] = []
    @State private var companyInfo = ""

    @State private var showImagePicker = false
    @State private var logoImage: UIImage?


    @State private var address = ""
    @StateObject private var locationManager = LocationManager()

    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var navigateToVerification = false
    @State private var registeredEmail = ""
    @State private var isLoading = false


    var body: some View {
        if isLoading {
            ProgressView("Kayıt yapılıyor...")
                .padding()
        }
        ScrollView {
            VStack(spacing: 16) {
                Text("Firma Kaydı")
                    .font(.title)
                    .bold()

                // Firma Adı
                TextField("Firma Adı", text: $companyName)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                // Sektör Seçimi
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


                Button(action: {
                    showImagePicker = true
                }) {
                    Text("Logo Seç (500x500 JPG)")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: $logoImage)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)

                // Adres
                TextField("Açık Adres", text: $address)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                // Konum Bilgisi
                if let location = locationManager.location {
                    Text("Konum: \(location.latitude), \(location.longitude)")
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    Text("Konum alınamadı")
                        .font(.caption)
                        .foregroundColor(.red)
                }

                // Kullanıcı Bilgileri
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
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                 NavigationLink(destination: EmailVerificationView(email: registeredEmail), isActive: $navigateToVerification) {
                         EmptyView()
                     }
            }
            .padding()
        }
        .onAppear {
            SectorService.fetchSectors { self.sectors = $0 }
        }
        .alert("Uyarı", isPresented: $showAlert) {
            Button("Tamam", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }

    @State private var showSectorDialog = false

 
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
                alertMessage = message
                showAlert = true

                if success {
                    registeredEmail = email
                    navigateToVerification = true
                }
            }
        }
    }
}
