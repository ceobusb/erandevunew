import SwiftUI
class RandevuListFirmaViewModel: ObservableObject {
    @Published var randevular: [FirmaRandevuModel] = []
    @Published var isLoading = false
    @Published var page = 1
    @Published var isLastPage = false

    func fetchRandevular(for firma: CompanyModel, page: Int = 1) {
        isLoading = true
        RandevuService.shared.getRandevularFirma(firmaID: firma.id, page: page) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let newItems):
                    if newItems.isEmpty {
                        self.isLastPage = true
                    } else {
                        if page == 1 {
                            self.randevular = newItems
                        } else {
                            self.randevular += newItems
                        }
                        self.page = page
                    }
                case .failure:
                    self.isLastPage = true
                }
            }
        }
    }
}

