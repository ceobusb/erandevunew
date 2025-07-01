import SwiftUI
import CoreLocation
import SDWebImageSwiftUI
struct SectorDetailView: View {
    let sector: Sector
    @StateObject private var locationManager = LocationManager()
    @State private var companies: [FeaturedCompany] = []
    @State private var isLoading = false
    @State private var selectedDistance = 5
    let distances = [1, 5, 10, 20, 50]
    @State private var showMenu: Bool = false
    
    var body: some View {
        MainLayout(showMenu: $showMenu) {
            ScrollView {
                VStack(spacing: 20) {
                    // Sektör Bilgisi
                    sectorHeader
                    
                    // Mesafe seçimi
                    Picker("Mesafe", selection: $selectedDistance) {
                        ForEach(distances, id: \.self) {
                            Text("\($0) km")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .onChange(of: selectedDistance) { _ in
                        if let coordinate = locationManager.location {
                            fetchCompanies(with: coordinate)
                        }
                    }
                    .onReceive(locationManager.$locationFetched) { fetched in
                        if fetched, let coordinate = locationManager.location {
                            fetchCompanies(with: coordinate)
                        }
                    }
                    
                    // Firma listesi
                    if isLoading {
                        ProgressView().padding()
                    } else if companies.isEmpty {
                        Text("Yakında firma bulunamadı.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(companies) { company in
                            CompanyItemViewSector(company: company)
                        }
                    }
                }
                .padding()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .navigationTitle("")
            
            
        }
    }
    
    var sectorHeader: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(hexOrName: sector.color_name).opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: sector.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color(hexOrName: sector.color_name))
            }
            
            Text(sector.title)
                .font(.title)
                .bold()
            
            Text(sector.description)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
    }
    
    
    func fetchCompanies(with coordinate: CLLocationCoordinate2D) {
        isLoading = true
        
        FirmaService.fetchNearbyCompaniesBySector(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            distance: selectedDistance,
            sectorId: sector.id
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let firms):
                    self.companies = firms
                case .failure(let err):
                    print("API Hatası: \(err.localizedDescription)")
                }
            }
        }
    }
    
    
    struct CompanyItemViewSector: View {
        let company: FeaturedCompany
        
        var body: some View {
            VStack(spacing: 10) {
                ZStack {
                    if let url = URL(string: company.logo_url) {
                        WebImage(url: url)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                            .shadow(radius: 3)
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray.opacity(0.4))
                    }
                }
                
                Text(company.company_name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Sektör: \(company.sektor_name)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if company.distance > 0 {
                    Text(String(format: "%.1f km uzakta", company.distance))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Button(action: {
                    // Randevu alma işlemi
                }) {
                    Text("Randevu Al")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 4)
            .padding(.horizontal)
        }
    }
    
    
}

