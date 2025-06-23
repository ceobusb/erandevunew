import SwiftUI
struct MyCompanyProfileView: View {
    @AppStorage("firmaID") var firmaID: String = ""
    @AppStorage("firmaName") var firmaName: String = ""

    var body: some View {
        VStack {
            Text("Firma Adı: \(firmaName)")
            Text("Firma ID: \(firmaID)")
        }
    }
}
