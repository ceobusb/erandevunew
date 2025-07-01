import SwiftUI
import SDWebImageSwiftUI


struct CompanyProfileView: View {
    let company: FeaturedCompany
    @StateObject private var viewModel = CompanyProfileViewModel()

    
    @Binding var selectedTab: Int

    @State private var showMenu = false
    
    var body: some View {
        MainLayout(showMenu: $showMenu) {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        // MARK: - Firma Logosu
                        ZStack {
                            Color.gray.opacity(0.2)
                            WebImage(url: URL(string: company.logo_url))
                                .resizable()
                                .indicator(.activity)
                                .scaledToFill()
                        }
                        .frame(height: 150)
                        .frame(maxWidth: .infinity)

                        // MARK: - Firma Adı ve Puan
                        VStack(spacing: 4) {
                            Text(company.company_name)
                                .font(.headline)
                                .bold()
                                .foregroundColor(.black)
                            StarRatingView(rating: company.rating)
                        }
                        .padding(8)
                        .background(Color.white.opacity(0.80))
                        .cornerRadius(10)
                        .padding(.horizontal, 32)
                        .offset(y: -20)

                        // MARK: - TabBar
                        HStack {
                            TabButton(title: "Bilgi", icon: "info.circle", index: 0, selectedTab: $selectedTab)
                            TabButton(title: "Hizmetler", icon: "list.bullet", index: 1, selectedTab: $selectedTab)
                            TabButton(title: "Personel", icon: "person.3", index: 2, selectedTab: $selectedTab)
                            TabButton(title: "Yorumlar", icon: "message", index: 3, selectedTab: $selectedTab)
                        }
                        .padding(.vertical, 10)
                        .background(Color(.systemGray6))

                        Divider()

                        // MARK: - İçerik
                        Group {
                            if selectedTab == 0 {
                                if let firma = viewModel.firmaBilgi {
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack(alignment: .top) {
                                            Image(systemName: "info.circle")
                                                .foregroundColor(.blue)
                                            Text(firma.description)
                                                .font(.body)
                                        }
                                        HStack {
                                            Image(systemName: "mappin.and.ellipse")
                                                .foregroundColor(.red)
                                            Text(firma.address)
                                                .font(.body)
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 1)
                                    .padding(.horizontal)
                                } else {
                                    ProgressView().padding()
                                }
                            }
                            else if selectedTab == 1 {
                                VStack(spacing: 8) {
                                    ForEach(viewModel.hizmetler, id: \.self) { hizmet in
                                        HStack {
                                            Image(systemName: company.icon) // sembol değişebilir
                                            Text(hizmet)
                                                .font(.body)
                                            Spacer()
                                        }
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 1)
                                        .padding(.horizontal)
                                    }
                                }
                            }

                            else if selectedTab == 2 {
                                VStack(spacing: 8) {
                                    ForEach(viewModel.personeller, id: \.self) { person in
                                        HStack {
                                            Image(systemName: "person.fill")
                                            Text(person)
                                                .font(.body)
                                            Spacer()
                                        }
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                    }
                                }
                            }

                            
                            else if selectedTab == 3 {
                                VStack(alignment: .leading, spacing: 16) {
                                    ForEach(viewModel.yorumlar, id: \.self) { yorum in
                                        HStack(alignment: .top) {
                                            Image(systemName: "quote.bubble")
                                                .foregroundColor(.blue)
                                            Text(yorum)
                                                .font(.body)
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                               
                            }

                        }
                        .padding(.top,8)

                        Spacer(minLength: 80) // İçerikle buton arasında boşluk bırak
                    }
                }
                .navigationBarBackButtonHidden(true)
                .navigationTitle("")

                // MARK: - Sabit Randevu Al Butonu
                Button(action: {
                    // Randevu oluşturma işlemi
                }) {
                    Text("Randevu Al")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("Primary"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.bottom, 8)
            }
            .onAppear {
                viewModel.fetchFirmaDetay(firmaId: company.id)
                viewModel.fetchHizmetler(firmaId: company.id)
                viewModel.fetchPersoneller(firmaId: company.id)
                viewModel.fetchYorumlar(firmaId: company.id)
            }
        }

    }
}

// MARK: - Tab Button View
struct TabButton: View {
    let title: String
    let icon: String
    let index: Int
    @Binding var selectedTab: Int
    
    var body: some View {
        Button(action: {
            selectedTab = index
            print("Seçilen Tab: \(index)")

        }) {
            VStack {
                Image(systemName: icon)
                Text(title)
                    .font(.footnote)
            }
            .foregroundColor(selectedTab == index ? Color("Secondary") : .gray)
            .frame(maxWidth: .infinity)
        }
    }
}
