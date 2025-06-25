import SwiftUI

struct AccountView: View {
    @AppStorage("firmaID") var firmaID: String = ""
    @AppStorage("firmaName") var firmaName: String = ""
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 20) {
            Text("Firma Adı: \(firmaName)")
            Text("Firma ID: \(firmaID)")

            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
     

    }
}
