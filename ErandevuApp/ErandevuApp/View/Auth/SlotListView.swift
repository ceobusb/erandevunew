import SwiftUI

struct SlotListView: View {
    let companyID: Int
    @State private var slots: [SlotModel] = []
    @State private var isLoading = true

    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView("Yükleniyor...")
                        .padding()
                } else if slots.isEmpty {
                    Text("Kayıtlı randevu saati bulunamadı.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(slots) { slot in
                        VStack(alignment: .leading, spacing: 6) {
                            Text("📅 \(slot.date)")
                                .font(.headline)
                            Text("🕒 \(slot.start_time) - \(slot.end_time)")
                                .font(.subheadline)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationTitle("Randevu Saatleri")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                APIService.fetchSlots(for: companyID) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let fetched):
                            self.slots = fetched
                        case .failure:
                            self.slots = []
                        }
                        self.isLoading = false
                    }
                }
            }
        }
    }
}
