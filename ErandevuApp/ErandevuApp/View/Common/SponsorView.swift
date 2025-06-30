import SwiftUI
import SDWebImageSwiftUI
struct SponsorView: View {
    @State private var companies: [FeaturedCompany] = []
    @State private var selectedDistance = 5 // km cinsinden
    @State private var isLoading = false
    @ObservedObject var locationManager: LocationManager
    
    
    var userLatitude: Double
     var userLongitude: Double

    let distances = [1, 5, 10, 20, 50]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Yakındaki Firmalar")
                .font(.title2)
                .bold()
                .padding(.horizontal)

            Picker("Mesafe", selection: $selectedDistance) {
                ForEach(distances, id: \.self) { km in
                    Text("\(km) km").tag(km)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .onChange(of: locationManager.locationFetched) {
                if $0 {
                    fetchData()
                }
            }


            if isLoading {
                ProgressView().padding()
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(companies) { company in
                        let sponsor = Sponsor(from: company)
                        NavigationLink(destination: SponsorDetailView(sponsor: Sponsor(from: company))) {
                            CompanyItemView(company: company)
                        }
                    }

                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            fetchData()
        }
        .onChange(of: userLatitude) { _ in
            fetchData()
        }
        .onChange(of: userLongitude) { _ in
            fetchData()
        }

    }

    func fetchData() {
        guard let coordinate = locationManager.location else {
            print("Konum alınmamış")
            return
        }

        isLoading = true

        FirmaService.shared.fetchNearbyCompanies(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            distance: selectedDistance
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

            // Randevu Al butonu
            Button(action: {
                // Navigation yapılabilir
                print("Randevu alınacak: \(company.company_name)")
            }) {
                Text("Randevu Al")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
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
    }
}
