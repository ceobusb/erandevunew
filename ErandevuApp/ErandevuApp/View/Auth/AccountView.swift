import SwiftUI
import SDWebImageSwiftUI
import MapKit

struct AccountView: View {
    @EnvironmentObject var appState: AppState
    @State private var showEditProfile = false
    @State private var showAddSlot = false
    @State private var showMenu: Bool = false


    let company: CompanyModel

    var body: some View {
        MainLayout(showMenu: $showMenu) {
            ZStack(alignment: .leading) {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 24) {
                            // LOGO
                            if let logo = company.logo_path {
                                WebImage(url: URL(string: "\(Endpoints.logobaseurl)/\(logo)"))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 140, height: 140)
                                    .shadow(radius: 4)
                            }
                            
                            // Firma Bilgileri
                            VStack(spacing: 10) {
                                Text(company.company_name)
                                    .font(.title)
                                    .bold()
                                
                                Text(company.sektor_name)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Label(company.email.bound, systemImage: "envelope")
                                Label(company.address.bound, systemImage: "map")
                                Label("Konum: \(company.latitude ?? 0), \(company.longitude ?? 0)", systemImage: "location")
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            
                            // HARİTA
                            if let lat = company.latitude, let lon = company.longitude {
                                Map(coordinateRegion: .constant(
                                    MKCoordinateRegion(
                                        center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                    )
                                ))
                                .frame(height: 200)
                                .cornerRadius(12)
                            }
                            
                            // BUTONLAR
//                            VStack(spacing: 12) {
//                                Button {
//                                    showEditProfile = true
//                                } label: {
//                                    Label("Profili Düzenle", systemImage: "square.and.pencil")
//                                        .frame(maxWidth: .infinity)
//                                        .padding()
//                                        .background(Color.blue)
//                                        .foregroundColor(.white)
//                                        .cornerRadius(10)
//                                }
//                                
//                                Button {
//                                    showAddSlot = true
//                                } label: {
//                                    Label("Randevu Saatleri Ekle", systemImage: "calendar.badge.plus")
//                                        .frame(maxWidth: .infinity)
//                                        .padding()
//                                        .background(Color.green)
//                                        .foregroundColor(.white)
//                                        .cornerRadius(10)
//                                }
//                                
//                                Button {
//                           
//                                    appState.path = []
//                                    appState.path.append(.slotList)
//                                } label: {
//                                    Label("Randevu Saatlerini Gör", systemImage: "clock")
//                                        .frame(maxWidth: .infinity)
//                                        .padding()
//                                        .background(Color.orange)
//                                        .foregroundColor(.white)
//                                        .cornerRadius(10)
//                                }
//                            }
                        }
                        .padding()
                    }
                    .padding()
                    .navigationBarBackButtonHidden(true)
                    .navigationTitle("")
                    
                }
                
                
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileView(company: company)
            }
            .sheet(isPresented: $showAddSlot) {
                AddSlotView(companyID: company.id)
            }
            .onAppear {
                // Eğer kullanıcı giriş yapmadıysa logout ile sıfırla
                if !appState.isLoggedIn {
                    appState.logout()
                }
            }
        }
    }
}
