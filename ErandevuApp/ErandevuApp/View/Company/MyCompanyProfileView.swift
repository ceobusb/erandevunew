import SwiftUI
struct MyCompanyProfileView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    @AppStorage("firmaID") var firmaID: String = ""
    @AppStorage("firmaName") var firmaName: String = ""

    var body: some View {
        VStack {
            Text("Firma Adı: \(firmaName)")
            Text("Firma ID: \(firmaID)")
        }
    }
}
