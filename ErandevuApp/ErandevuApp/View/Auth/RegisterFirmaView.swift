import SwiftUI
import CoreLocation

struct WorkingHour: Identifiable, Codable {
    var id = UUID()
    var day: String        // Örnek: "Pazartesi"
    var startTime: String  // Örnek: "09:00"
    var endTime: String    // Örnek: "18:00"
    
    var timeRange: String {
        return "\(startTime)-\(endTime)"
    }
}


struct Personnel: Identifiable {
    var id = UUID()
    var name: String
}

struct Service: Identifiable {
    var id = UUID()
    var name: String
}

struct RegisterFirmaView: View {
    @EnvironmentObject var appState: AppState

    @State private var companyName = ""
    @State private var selectedSector: Sector?
    @State private var sectors: [Sector] = []
    @State private var companyInfo = ""
    @State private var isSelfOnly = true

    @State private var showImagePicker = false
    @State private var logoImage: UIImage?

    @State private var address = ""
    @StateObject private var locationManager = LocationManager()

    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    @State private var businessPhone = ""
    @State private var mobilePhone = ""
    @State private var phoneFixed = ""
    @State private var workingHours: [WorkingHour] = []
    @State private var personnelList: [Personnel] = []
    @State private var servicesList: [Service] = []

    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var showSectorDialog = false
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
                        VStack(spacing: 24) {
                            Text("Firma Kaydı")
                                .font(.title)
                                .bold()

                            formFirmaBilgileri()
                            formKonumSaatPersonel()
                            formKullaniciBilgileri()

                            Button("Kayıt Ol") {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    validateAndRegister()
                                }

                               
                            }
                            .modifier(PrimaryButtonStyle())
                        }
                        .padding()
                        .navigationBarBackButtonHidden(true)
                        .navigationTitle("")
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
                    appState.path = []
                    appState.path.append(.emailVerification)
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
            logo: logo,
            businessPhone: businessPhone,
            mobilePhone: mobilePhone,
            workingHours: workingHours,
            services: servicesList.map { $0.name },
            isSelfOnly: isSelfOnly,
            personnelList: personnelList.map { $0.name }
        ) { success, message in
            DispatchQueue.main.async {
                isLoading = false
                alertMessage = message
                showAlert = true
            }
        }
    }

    
    @ViewBuilder
    private func formFirmaBilgileri() -> some View {
        TextField("Firma Adı", text: $companyName)
            .modifier(StandardField())

        Button(action: { showSectorDialog = true }) {
            HStack {
                Text(selectedSector?.title ?? "Sektör Seçin")
                    .foregroundColor(selectedSector == nil ? .gray : .primary)
                Spacer()
                Image(systemName: "chevron.down")
            }
            .modifier(StandardField())
        }
        .confirmationDialog("Sektör Seçin", isPresented: $showSectorDialog) {
            ForEach(sectors, id: \.id) { sector in
                Button(sector.title) {
                    selectedSector = sector
                }
            }
        }

        TextEditor(text: $companyInfo)
            .frame(height: 100)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))

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
        .modifier(ActionButtonStyle())

        Group {
            TextField("İş Telefonu", text: $businessPhone)
            TextField("Mobil Telefon", text: $mobilePhone)
            TextField("Açık Adres", text: $address)
        }.modifier(StandardField())

        if let location = locationManager.location {
            Text("Konum: \(location.latitude), \(location.longitude)")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
    
    @ViewBuilder
    private func formKonumSaatPersonel() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Çalışma Saatleri")
                .font(.headline)
            
            ForEach(workingHours.indices, id: \.self) { index in
                HStack {
                    // Gün seçimi
                    Picker("", selection: $workingHours[index].day) {
                        ForEach(["Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi", "Pazar"], id: \.self) {
                            Text($0)
                        }
                    }
                    .frame(width: 110)
                    .pickerStyle(MenuPickerStyle())

                    // Başlangıç ve bitiş saatleri
                    TextField("09:00", text: $workingHours[index].startTime)
                        .keyboardType(.numbersAndPunctuation)
                        .frame(width: 60)

                    Text("-")

                    TextField("18:00", text: $workingHours[index].endTime)
                        .keyboardType(.numbersAndPunctuation)
                        .frame(width: 60)

                    // Silme butonu
                    Button(action: {
                        workingHours.remove(at: index)
                    }) {
                        Image(systemName: "trash")
                    }
                }
                .padding(.horizontal)
            }

            if workingHours.count < 7 {
                Button(action: {
                    workingHours.append(WorkingHour(day: "Pazartesi", startTime: "09:00", endTime: "18:00"))
                }) {
                    Label("Çalışma Saati Ekle", systemImage: "plus")
                }
                .actionButton()
            }

            Toggle(isOn: $isSelfOnly) {
                Text("Sadece ben çalışacağım")
                    .font(.body)
            }
            .padding(.trailing)

            Text("Eğer işletmede sadece siz çalışıyorsanız bu seçeneği işaretleyin.")
                .font(.caption)
                .foregroundColor(.gray)

            Divider()

            // Personel
            Text("Personeller")
                .font(.headline)

            ForEach(personnelList.indices, id: \.self) { index in
                HStack {
                    TextField("Personel Adı", text: $personnelList[index].name)
                    Spacer()
                    Button(action: {
                        personnelList.remove(at: index)
                    }) {
                        Image(systemName: "trash")
                    }
                }
                .padding(.horizontal)
            }

            Button(action: {
                personnelList.append(Personnel(name: ""))
            }) {
                Label("Personel Ekle", systemImage: "plus")
            }
            .actionButton()

            Divider()

            // Hizmetler
            Text("Hizmetler")
                .font(.headline)

            ForEach(servicesList.indices, id: \.self) { index in
                HStack {
                    TextField("Hizmet Adı", text: $servicesList[index].name)
                    Spacer()
                    Button(action: {
                        servicesList.remove(at: index)
                    }) {
                        Image(systemName: "trash")
                    }
                }
                .padding(.horizontal)
            }

            Button(action: {
                servicesList.append(Service(name: ""))
            }) {
                Label("Hizmet Ekle", systemImage: "plus")
            }
            .actionButton()
        }
    }

    
    @ViewBuilder
    private func formKullaniciBilgileri() -> some View {
        Group {
            TextField("Ad Soyad", text: $fullName)
            TextField("E-posta", text: $email)
                .keyboardType(.emailAddress)
            SecureField("Şifre", text: $password)
                .textContentType(.password) // veya .none

            SecureField("Şifre Tekrar", text: $confirmPassword)
                .textContentType(.password) // veya .none

        }.modifier(StandardField())
    }
    




    // TextField, SecureField, TextEditor gibi input alanları için ortak stil
    struct StandardField: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
        }
    }


    // Kayıt ol gibi ana işlemler için buton stili
    struct PrimaryButtonStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }


}

// Dosyanın en altına ekle
struct ActionButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
    }
}

extension View {
    func actionButton() -> some View {
        self.modifier(ActionButtonStyle())
    }
}



