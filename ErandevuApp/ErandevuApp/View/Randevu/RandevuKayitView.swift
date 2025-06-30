import SwiftUI

struct RandevuKayitView: View {
    @State private var adSoyad = ""
    @State private var telefon = ""
    @State private var secilenTarih = Date()
    @State private var not = ""

    var body: some View {

            VStack(alignment: .leading, spacing: 20) {
                Text("Yeni Randevu Oluştur")
                    .font(.title2)
                    .fontWeight(.semibold)

                TextField("Ad Soyad", text: $adSoyad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Telefon Numarası", text: $telefon)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.phonePad)

                DatePicker("Tarih Seçin", selection: $secilenTarih, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())

                TextField("Not (isteğe bağlı)", text: $not)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    // API’ye gönderme işlemi
                }) {
                    Text("Randevuyu Kaydet")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
        
    }
}
