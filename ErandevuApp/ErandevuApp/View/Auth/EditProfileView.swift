import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    let company: CompanyModel
    
    @State private var companyName: String = ""
    @State private var email: String = ""
    @State private var sektorName: String = ""
    @State private var address: String = ""
    @State private var description: String = ""
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0

    @State private var isSaving = false
    @State private var showAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Firma Bilgileri")) {
                    TextField("Firma Adı", text: $companyName)
                    TextField("E-posta", text: $email)
                    TextField("Sektör", text: $sektorName)
                    TextField("Adres", text: $address)
                    TextField("Açıklama", text: $description)
                }

                Section(header: Text("Konum Bilgisi")) {
                    TextField("Enlem", value: $latitude, format: .number)
                    TextField("Boylam", value: $longitude, format: .number)
                }

                Section {
                    Button(action: saveProfile) {
                        if isSaving {
                            ProgressView()
                        } else {
                            Label("Kaydet", systemImage: "checkmark.circle.fill")
                        }
                    }
                }
            }
            .navigationTitle("Profili Düzenle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Kapat") {
                        dismiss()
                    }
                }
            }
            .alert("Güncelleme başarılı", isPresented: $showAlert) {
                Button("Tamam") {
                    dismiss()
                }
            }
            .onAppear {
                // company'den gelen verileri başlat
                companyName = company.company_name
                email = company.email ?? ""
                sektorName = company.sektor_name
                address = company.address ?? ""
                description = company.description ?? ""
                latitude = company.latitude ?? 0.0
                longitude = company.longitude ?? 0.0
            }
        }
    }

    func saveProfile() {
        isSaving = true
        // API çağrısı burada olacak
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isSaving = false
            showAlert = true
        }
    }
}

