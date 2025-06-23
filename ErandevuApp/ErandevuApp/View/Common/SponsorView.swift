import SwiftUI

struct SponsorView: View {
    @State private var companies: [FeaturedCompany] = []

    var body: some View {
        VStack(alignment: .leading) {
            Text("Öne Çıkan Firmalar")
                .font(.title2)
                .bold()
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(companies) { company in
                        let sponsor = Sponsor(
                            id: UUID(),
                            name: company.company_name,
                            logoUrl: company.logo_url,
                            latitude: company.latitude, // doğrudan kullan
                            longitude: company.longitude, // doğrudan kullan
                            description: company.description,
                            rating: company.rating,
                            address: company.address
                        )

                        NavigationLink(destination: SponsorDetailView(sponsor: sponsor)) {
                            CompanyItemView(company: company)
                        }
                    }

                }

                .padding(.horizontal)
            }
        }
        .onAppear {
      
            FirmaService.shared.fetchFeaturedCompanies { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        print("Gelen Veri:", data)
                        self.companies = data
                    case .failure(let err):
                        print("Hata:", err.localizedDescription)
                    }
                }
            }
        }


    }
    
}

struct CompanyItemView: View {
    let company: FeaturedCompany
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: company.logo_url)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())

            Text(company.company_name)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .padding(8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
