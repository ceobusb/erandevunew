import SwiftUI

struct RegisterView: View {
    enum RegisterType: String, CaseIterable {
        case firma = "Firma Kaydı"
        case musteri = "Müşteri Kaydı"
    }

    @State private var selectedType: RegisterType = .firma

    // Ortak Alanlar
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    // Firma Özel Alanlar
    @State private var companyName: String = ""
    @State private var sector: String = ""

    // Müşteri Özel Alanlar
    @State private var phone: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Picker("Kayıt Tipi", selection: $selectedType) {
                    ForEach(RegisterType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top)

                Text(selectedType.rawValue)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                if selectedType == .firma {
                    TextField("Firma Adı", text: $companyName)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)

                    TextField("Sektör", text: $sector)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }

                TextField("Ad Soyad", text: $fullName)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                TextField("E-posta", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                if selectedType == .musteri {
                    TextField("Telefon", text: $phone)
                        .keyboardType(.phonePad)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }

                SecureField("Şifre", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                SecureField("Şifre Tekrar", text: $confirmPassword)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                Button(action: {
                    register()
                }) {
                    Text("Kayıt Ol")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Kayıt Ol")
        .navigationBarTitleDisplayMode(.inline)
    }

    func register() {
        // API isteği burada yapılacak.
        print("Kayıt türü: \(selectedType.rawValue)")
        // Giriş verilerini kontrol et / gönder
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}
