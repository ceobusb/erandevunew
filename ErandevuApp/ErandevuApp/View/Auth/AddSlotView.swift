import SwiftUI

struct AddSlotView: View {
    let companyID: Int
    @Environment(\.dismiss) var dismiss

    @State private var date = Date()
    @State private var startHour = Date()
    @State private var endHour = Date()
    @State private var isSaving = false
    @State private var showSuccess = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Yeni Randevu Saati")
                    .font(.title2)
                    .bold()
                    .padding(.top)

                Form {
                    Section(header: Text("📅 Tarih")) {
                        DatePicker("Tarih Seçin", selection: $date, displayedComponents: .date)
                    }

                    Section(header: Text("🕒 Saat Aralığı")) {
                        DatePicker("Başlangıç Saati", selection: $startHour, displayedComponents: .hourAndMinute)
                        DatePicker("Bitiş Saati", selection: $endHour, displayedComponents: .hourAndMinute)
                    }

                    Section {
                        Button(action: saveSlot) {
                            HStack {
                                Spacer()
                                if isSaving {
                                    ProgressView()
                                } else {
                                    Label("Kaydet", systemImage: "plus.circle.fill")
                                        .foregroundColor(.white)
                                }
                                Spacer()
                            }
                        }
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color(.systemGroupedBackground))
                .cornerRadius(12)
            }
            .padding()
            .navigationTitle("Randevu Saati Ekle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        dismiss()
                    }
                }
            }
            .alert("Slot başarıyla eklendi ✅", isPresented: $showSuccess) {
                Button("Tamam") {
                    dismiss()
                }
            }
        }
    }

    private func saveSlot() {
        isSaving = true

        // Örnek bekleme (gerçek API ile değiştir)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isSaving = false
            showSuccess = true
        }
    }
}
