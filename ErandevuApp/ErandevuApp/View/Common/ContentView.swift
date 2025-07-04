import SwiftUI
import MapKit
struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentIndex = 0
    @State private var showMenu: Bool = false
    @StateObject var locationManager = LocationManager()
    @State private var companies: [FeaturedCompany] = []
    @State private var sectors: [Sector] = []

    @State private var selectedDistance = 5 // km cinsinden

    
    let features = [
        ("Takvim ile Kolay Randevu", "Randevularınızı hızlıca yönetin.", "calendar", Color.purple),
        ("Personel Yönetimi", "Personel planlamasını yapın.", "person.2.fill", Color.red),
        ("Hizmet Tanımları", "Sunduğunuz hizmetleri ekleyin.", "list.bullet.rectangle.portrait", Color.blue),
        ("Bildirimler", "Hatırlatmalarla müşterinizi bilgilendirin.", "bell.badge.fill", Color.green)
    ]
    
    var body: some View {
        MainLayout(showMenu: $showMenu) {
            ZStack(alignment: .leading) {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Bilgilendirici Kaydırmalı Alan
                            InfoSliderView()
                            
                            // Yakındaki firmalar
                            SponsorView(
                                locationManager: locationManager,
                                userLatitude: appState.currentLatitude,
                                userLongitude: appState.currentLongitude
                            )


                            
                            // Sektör tanıtımı
                            SectorShowcaseView( locationManager: locationManager,
                                                userLatitude: appState.currentLatitude,
                                                userLongitude: appState.currentLongitude
                            )
                            
                            // Özellik kartları
                            TabView(selection: $currentIndex) {
                                ForEach(0..<features.count, id: \.self) { index in
                                    VStack {
                                        Image(systemName: features[index].2)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .padding()
                                            .background(Color.white.opacity(0.2))
                                            .clipShape(Circle())
                                            .foregroundColor(.white)
                                        
                                        Text(features[index].0)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        
                                        Text(features[index].1)
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(features[index].3)
                                    .cornerRadius(20)
                                    .padding(.horizontal, 16)
                                }
                            }
                            .frame(height: 220)
                            .tabViewStyle(PageTabViewStyle())
                        }
                        .padding(.bottom, 40)
                    }
                    .refreshable {
                        print("Sayfa yenileniyor...")

                        let coordinate = CLLocationCoordinate2D(latitude: appState.currentLatitude, longitude: appState.currentLongitude)

                        // Firma listesi yenileniyor
                        FirmaService.fetchNearbyCompanies(
                            latitude: coordinate.latitude,
                            longitude: coordinate.longitude,
                            distance: selectedDistance
                        ) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let data):
                                    self.companies = data
                                case .failure(let err):
                                    print("Sponsor firma yenileme hatası:", err.localizedDescription)
                                }
                            }
                        }

                        // Sektör listesi yenileniyor
                        SectorService.fetchSectors { result in
                            DispatchQueue.main.async {
                                self.sectors = result
                            }
                        }
                    }

                    
                }
                
                // Menü Açıkken Arka Plan Kapatıcı ve Yan Menü
                if appState.showMenu {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                appState.showMenu = false
                            }
                        }
                    
                    
                    
                }
                
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                // Giriş yapılmamışsa logout
                if !appState.isLoggedIn && appState.FirmaId > 0 {
                    appState.logout()
                }
            }
        }
    }
}
