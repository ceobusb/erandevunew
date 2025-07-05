import SwiftUI
import SDWebImageSwiftUI
import CoreLocation

struct SponsorView: View {
    @EnvironmentObject var appState: AppState
    @State private var companies: [FeaturedCompany] = []
    @State private var selectedDistance: DistanceFilter = .km(5)

    @State private var isLoading = false
    @ObservedObject var locationManager: LocationManager
    
    enum DistanceFilter: Equatable, Hashable {
        case km(Int)
        case all
        
        var value: Int? {
            switch self {
            case .km(let km): return km
            case .all: return nil
            }
        }

        var label: String {
            switch self {
            case .km(let km): return "\(km) km"
            case .all: return "TÜMÜ"
            }
        }
    }

    var userLatitude: Double
    var userLongitude: Double
    let distances: [DistanceFilter] = [.km(1), .km(5), .km(10), .km(20), .all]

    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Yakındaki Firmalar")
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            Picker("Mesafe", selection: $selectedDistance) {
                ForEach(distances, id: \.self) { item in
                    Text(item.label).tag(item)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            .padding(.horizontal)
            .onChange(of: selectedDistance) { _ in
                if let coordinate = locationManager.location {
                    fetchData(with: coordinate)
                }
            }

            .onChange(of: selectedDistance) { _ in
                if let coordinate = locationManager.location {
                    fetchData(with: coordinate)
                }
            }
            
            
            if isLoading {
                ProgressView().padding()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(companies) { company in
                        Button(action: {
                            let sponsor = Sponsor(from: company)
                            appState.path.append(.sponsorDetail(company))

                        }) {
                            CompanyItemView(company: company)
                        }

                    }
                    
                }
                .padding(.horizontal)
            }
        }
        
        
        
        
    }
    
    func fetchData(with coordinate: CLLocationCoordinate2D) {
        isLoading = true
        
        FirmaService.fetchNearbyCompanies(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            distance: selectedDistance.value ?? 0

        ) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    self.companies = data
                case .failure(let err):
                    print("Hata:", err.localizedDescription)
                }
            }
        }
    }

    
    
    
}

struct CompanyItemView: View {
    let company: FeaturedCompany
    
    var body: some View {
        VStack(spacing: 8) {
            // Firma logosu
            WebImage(url: URL(string: company.logo_url))
                .resizable()
                .indicator(.progress)
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .shadow(radius: 2)
            
            // Firma adı
            Text(company.company_name)
                .font(.footnote)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .lineLimit(1)
            
            // Sektör adı (örnek, sabit yazıldı; istersen veriden al)
            Text("Sektör: \(company.sektor_name ?? "Bilinmiyor")")
                .font(.caption2)
                .foregroundColor(.gray)
                .lineLimit(1)
            
          
        }
        .padding()
        .frame(width: 140)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}

extension Sponsor {
    init(from company: FeaturedCompany) {
        self.id = UUID()
        self.name = company.company_name
        self.logoUrl = company.logo_url
        self.latitude = company.latitude
        self.longitude = company.longitude
        self.description = company.description
        self.rating = company.rating
        self.address = company.address
        self.business_phone = company.business_phone ?? "Telefon yok"
        self.mobile_phone = company.mobile_phone ?? "Telefon yok"
        self.working_hours = company.working_hours ?? "Çalışma saatleri belirtilmedi"

    }
}
