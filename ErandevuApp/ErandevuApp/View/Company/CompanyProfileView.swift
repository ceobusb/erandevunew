import SwiftUI
import SDWebImageSwiftUI

struct CompanyProfileView: View {
    let company: FeaturedCompany
    @StateObject private var viewModel = CompanyProfileViewModel()
    @Binding var selectedTab: Int
    @State private var showMenu = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
  
            VStack(spacing: 0) {
                CustomHeaderView(title: "Firma Detay") {
                              presentationMode.wrappedValue.dismiss()
                          }
                ScrollView {
                    VStack(spacing: 0) {
                        // MARK: - Firma Logosu
                        ZStack {
                            Color.gray.opacity(0.2)
                            WebImage(url: URL(string: company.logo_url))
                                   .resizable()
                                   .indicator(.activity)
                                   .scaledToFill()
                                   .frame(height: 140)
                                   .frame(maxWidth: .infinity)
                                   .clipped() // !!! Taşmayı engeller
                        }
                        .frame(height: 180)
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
                                        Text("Firma Bilgileri")
                                            .font(.headline)
                                            .padding(.horizontal)
                                            .padding(.top)
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
                                        HStack {
                                            Image(systemName: "phone.fill")
                                                .foregroundColor(.green)
                                            Text(firma.business_phone ?? "İş telefonu yok")
                                                .font(.body)
                                        }

                                        HStack {
                                            Image(systemName: "phone.circle.fill")
                                                .foregroundColor(.blue)
                                            Text(firma.mobile_phone ?? "Mobil telefon yok")
                                                .font(.body)
                                        }

                                        if let hours = firma.working_hours {
                                            let splitted = hours.components(separatedBy: ",")
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                ForEach(Array(splitted.enumerated()), id: \.offset) { index, item in
                                                    HStack {
                                                        Image(systemName: "clock.fill")
                                                            .foregroundColor(.orange)
                                                        Text(item)
                                                    }
                                                }
                                            }

                                        }
                                        else {
                                            HStack {
                                                Image(systemName: "clock.fill")
                                                    .foregroundColor(.gray)
                                                Text("Çalışma saatleri belirtilmemiş")
                                            }
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
                                    Text("Firmanın Hizmetlei")
                                        .font(.headline)
                                        .padding(.horizontal)
                                        .padding(.top)
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
                                    Text("Firma Personelleri")
                                        .font(.headline)
                                        .padding(.horizontal)
                                        .padding(.top)
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
                                ScrollView {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("Kullanıcı Yorumları")
                                            .font(.headline)
                                            .padding(.horizontal)
                                            .padding(.top)

                                        ForEach(viewModel.yorumlar, id: \.self) { yorum in
                                            HStack(alignment: .top, spacing: 10) {
                                                Image(systemName: "quote.bubble.fill")
                                                    .foregroundColor(.blue)
                                                    .font(.system(size: 18))
                                                    .padding(.top, 4)

                                                Text(yorum)
                                                    .font(.body)
                                                    .foregroundColor(.black)
                                                    .fixedSize(horizontal: false, vertical: true)

                                                Spacer()
                                            }
                                            .padding()
                                            .background(Color(.systemGray6))
                                            .cornerRadius(12)
                                            .padding(.horizontal)
                                        }
                                    }
                                    .padding(.bottom, 20)
                                }
                            }



                        }
                        .padding(.top,8)

                        Spacer(minLength: 80) // İçerikle buton arasında boşluk bırak
                    }
                }
            

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
            .navigationBarBackButtonHidden(true)
            .onAppear {
                viewModel.fetchFirmaDetay(firmaId: company.id)
                viewModel.fetchHizmetler(firmaId: company.id)
                viewModel.fetchPersoneller(firmaId: company.id)
                viewModel.fetchYorumlar(firmaId: company.id)
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
