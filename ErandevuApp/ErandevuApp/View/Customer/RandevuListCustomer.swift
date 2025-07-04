import SwiftUI

struct RandevuListCustomer: View {
    @StateObject var viewModel: RandevuListCustomerViewModel = RandevuListCustomerViewModel()
    @EnvironmentObject var appState: AppState
    let customer: CustomerModel

    
    @State private var isLoading = false
    @State private var showCancelAlert = false
    @State private var cancelReason = ""
    @State private var selectedRandevuID: Int?
    @State private var showResultAlert = false
    @State private var resultMessage = ""
    
    
    @State private var showCompleteSheet = false
    @State private var selectedRandevuToComplete: CustomerRandevuModel?
    @State private var rating: Int = 0
    @State private var comment: String = ""

    
    
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.randevular.isEmpty && !viewModel.isLoading {
                    EmptyStateView(
                        title: "Henüz Randevunuz Yok",
                        message: "Yeni bir randevu oluşturmak için firmaları inceleyin",
                        systemImage: "calendar.badge.exclamationmark"
                    )
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.randevular) { randevu in
                            randevuCardView(for: randevu)
                                .onAppear {
                                    if randevu == viewModel.randevular.last && !viewModel.isLoading && !viewModel.isLastPage {
                                          viewModel.page += 1
                                          viewModel.fetchRandevular(for: customer, page: viewModel.page)
                                      }
                                }
                        }
                        
                        if isLoading {
                            ProgressView().padding()
                        }
                    }
                    .padding(.top)
                }

            
            }
          
            .onAppear {
                if viewModel.randevular.isEmpty {
                    viewModel.fetchRandevular(for: customer, page: 1)
                }
            }

        }
    }
    @ViewBuilder
    func randevuCardView(for randevu: CustomerRandevuModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(randevu.firma_name ?? "Firma Adı Yok")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                statusTextView(for: randevu.status)
            }
            
            Text("📅 Tarih: \(formattedDate(randevu.date))")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if let note = randevu.note {
                Text("📝 Not: \(note)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            // İptal sebebini göster
            if randevu.status == 2, let reason = randevu.cancel_reason {
                Text("❗️ İptal Sebebi: \(reason)")
                    .font(.footnote)
                    .foregroundColor(.red)
            }
            
            if randevu.status == 0 {
                Button(action: {
                    selectedRandevuID = randevu.id
                    showCancelAlert = true
                }) {
                    Text("İptal Et")
                        .foregroundColor(.red)
                        .padding(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.red, lineWidth: 1)
                        )
                }
            }
            
            if randevu.status == 1 {
                Button(action: {
                    selectedRandevuToComplete = randevu
                    showCompleteSheet = true
                }) {
                    Text("Randevu Tamamla")
                        .foregroundColor(.blue)
                        .padding(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                }
            }
              


            
            
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
        .alert("İptal Et", isPresented: $showCancelAlert, actions: {
            TextField("İptal sebebini yazın", text: $cancelReason)
            Button("Gönder", action: {
                guard let id = selectedRandevuID, !cancelReason.isEmpty else {
                    resultMessage = "Açıklama gerekli."
                    showResultAlert = true
                    return
                }
                
                RandevuService.updateCustomerRandevuStatus(
                    customerID: randevu.customer_id,
                    randevuID: id,
                    newStatus: 2,
                    reason: cancelReason) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let msg):
                                resultMessage = msg
                                viewModel.fetchRandevular(for: customer, page: 1)

                            case .failure(let error):
                                resultMessage = error.localizedDescription
                            }
                            showResultAlert = true
                        }
                    }
            })
            Button("İptal", role: .cancel, action: {})
        }, message: {
            Text("İptal nedenini giriniz.")
        })
        .alert("Bilgi", isPresented: $showResultAlert) {
            Button("Tamam", role: .cancel) {}
        } message: {
            Text(resultMessage)
        }
        .sheet(isPresented: $showCompleteSheet) {
            VStack(spacing: 16) {
                Text("Tamamla")
                    .font(.headline)

                Text("Puan ver (isteğe bağlı)")
                HStack {
                    ForEach(1...5, id: \.self) { i in
                        Image(systemName: i <= rating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .onTapGesture {
                                rating = i
                            }
                    }
                }

                TextField("Yorum (isteğe bağlı)", text: $comment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Gönder") {
                    if let randevu = selectedRandevuToComplete {
                        RandevuService.updateCustomerRandevuStatusTamamla(
                            customerID: randevu.customer_id,
                            randevuID: randevu.id,
                            newStatus: 3, // tamamlandı
                            reason: "", // boş çünkü iptal değil
                            rating: rating,
                            comment: comment
                        ) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let msg):
                                    resultMessage = msg
                                    viewModel.fetchRandevular(for: customer, page: 1)

                                case .failure(let err):
                                    resultMessage = err.localizedDescription
                                }
                                showResultAlert = true
                                showCompleteSheet = false
                                rating = 0
                                comment = ""
                            }
                        }
                    }
                }

                Button("İptal", role: .cancel) {
                    showCompleteSheet = false
                }
            }
            .padding()
        }
        
    }
    struct EmptyStateView: View {
        let title: String
        let message: String
        let systemImage: String

        var body: some View {
            VStack(spacing: 16) {
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.orange.opacity(0.8))

                Text(title)
                    .font(.title3)
                    .bold()

                Text(message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }

    
    // MARK: - Status View
    func statusTextView(for status: Int) -> some View {
        Text(statusText(for: status))
            .font(.subheadline)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color(for: status).opacity(0.2))
            .foregroundColor(color(for: status))
            .cornerRadius(8)
    }
    
    
    // MARK: - Helpers
    private func statusText(for status: Int) -> String {
        switch status {
        case 0: return "Bekliyor"
        case 1: return "Onaylandı"
        case 2: return "İptal Edildi"
        case 3  : return "Tamamlandı"
        default: return "Bilinmiyor"
        }
    }
    
    private func color(for status: Int) -> Color {
        switch status {
        case 0: return .orange
        case 1: return .green
        case 2: return .red
        default: return .gray
        }
    }
    
    private func formattedDate(_ dateStr: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = formatter.date(from: dateStr) {
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return dateStr
    }
}
