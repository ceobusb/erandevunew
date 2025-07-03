import SwiftUI
class RandevuListCustomerViewModel: ObservableObject {
    @Published var randevular: [CustomerRandevuModel] = []
    @Published var isLoading = false
    @Published var page = 1
    @Published var isLastPage = false

    func fetchRandevular(for customer: CustomerModel, page: Int = 1) {
        isLoading = true
        RandevuService.shared.getRandevular(customerID: customer.id, page: page) { result in
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

