import SwiftUI

struct CustomerAccountView: View {
    let customer: CustomerModel
    @State private var showMenu: Bool = false
    var body: some View {
        MainLayout(showMenu: $showMenu) {
            ZStack(alignment: .leading) {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("👤 Profil Bilgilerim")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.bottom, 10)
                            
                            InfoRow(label: "Ad Soyad", value: customer.full_name)
                            InfoRow(label: "E-posta", value: customer.email ?? "Email getirilemedi")
                            InfoRow(label: "Adres", value: customer.address ?? "Adres girilmedi")
                            InfoRow(label: "Konum", value: "\(customer.latitude), \(customer.longitude)")
                            if let created = customer.created_at {
                                InfoRow(label: "Kayıt Tarihi", value: created)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .padding()
                    }
                  
                    .navigationBarBackButtonHidden(true)
                    .navigationTitle("")
                }
            }
        }
        
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text("\(label):")
                .fontWeight(.semibold)
                .frame(width: 120, alignment: .leading)
            Text(value)
                .multilineTextAlignment(.leading)
        }
        .padding(.vertical, 4)
    }
}
