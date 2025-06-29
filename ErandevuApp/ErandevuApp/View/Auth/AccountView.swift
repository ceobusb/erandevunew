import SwiftUI
import SDWebImageSwiftUI
struct AccountView: View {
    @EnvironmentObject var appState: AppState
    @State private var showEditProfile = false
    @State private var showAddSlot = false
    let company: CompanyModel


    var body: some View {
        ScrollView {
                   VStack(spacing: 24) {
                       // LOGO
                       if let logo = company.logo_path {
                           WebImage(url: URL(string: "\(Endpoints.logobaseurl)/\(logo)"))

                               .resizable()
                               .scaledToFit()
                               .frame(width: 120, height: 120)
                               .clipShape(Circle())
                               .shadow(radius: 6)
                       }

                       // Firma Bilgileri
                       VStack(spacing: 8) {
                           Text(company.company_name)
                               .font(.title)
                               .bold()

                           Text("Sektör: \(company.sektor_name)")
                               .foregroundColor(.secondary)

                           Text("Firma ID: \(company.id)")
                               .font(.footnote)

                           if let email = company.email {
                               Label(email, systemImage: "envelope")
                           }

                           Label(company.address ?? "Adres yok", systemImage: "map")
                           Label("Konum: \(company.latitude ?? 0), \(company.longitude ?? 0)", systemImage: "location")
                       }
                       .padding()
                       .background(.ultraThinMaterial)
                       .cornerRadius(12)
                   }
                   .padding()
               }
               .navigationTitle("Firma Profili")
               .navigationBarTitleDisplayMode(.inline)
           }
    
}
