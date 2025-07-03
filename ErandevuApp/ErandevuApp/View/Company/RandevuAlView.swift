import SwiftUI

struct RandevuAlView: View {
    let firmaID: Int
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode

    @State private var selectedDate = Date()
    @State private var note = ""
    @State private var isSubmitting = false
    @State private var message = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""


    var body: some View {
        VStack(spacing: 20) {
            Text("Randevu Al")
                .font(.title)
                .fontWeight(.bold)

            DatePicker("Tarih Seç", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()

            TextField("Not (isteğe bağlı)", text: $note)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            if isSubmitting {
                ProgressView()
            } else {
                Button("Randevu Oluştur") {
                    submitRandevu()
                }
           
            }

            if !message.isEmpty {
                Text(message)
                    .foregroundColor(.green)
                    .font(.footnote)
            }

            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("Tamam")) {
                    if alertTitle == "Başarılı" {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }

    }
    private func submitRandevu() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let formattedDate = formatter.string(from: selectedDate)

        isSubmitting = true
        RandevuService.shared.createRandevu(
            firmaID: firmaID,
            customerID: appState.customer?.id ?? 0,
            date: formattedDate, // Formatladığın date string olmalı
            note: note
        ) { success in
            DispatchQueue.main.async {
                isSubmitting = false
                if success {
                    alertTitle = "Başarılı"
                    alertMessage = "Randevu başarıyla oluşturuldu"
                } else {
                    alertTitle = "Hata"
                    alertMessage = "Randevu oluşturulamadı"
                }
                showAlert = true
            }
        }
    }


}
