import SwiftUI

struct FirmaDetayView: View {
    @ObservedObject var viewModel: CompanyProfileViewModel
    @State private var selectedTab = 0
    
    let tabTitles = ["Bilgi", "Hizmetler", "Personel", "Yorumlar"]
    let iconNames = ["info.circle", "list.bullet", "person.3.fill", "text.bubble"]

    var body: some View {
        VStack(spacing: 0) {
            // Üst görsel ve başlık
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: viewModel.firmaBilgi?.logo_url ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipped()
                } placeholder: {
                    Color.gray.frame(height: 180)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(viewModel.firmaBilgi?.company_name ?? "")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    
                    HStack {
                        ForEach(1..<6) { index in
                            Image(systemName: index <= Int(viewModel.firmaBilgi?.rating ?? 0) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .padding(.leading)
                .padding(.bottom, 8)
            }

            // Sekmeler
            HStack {
                ForEach(0..<tabTitles.count, id: \.self) { index in
                    Button(action: {
                        selectedTab = index
                    }) {
                        VStack {
                            Image(systemName: iconNames[index])
                            Text(tabTitles[index])
                        }
                        .foregroundColor(selectedTab == index ? .orange : .gray)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .background(Color(.systemGray6))

            Divider()

            // İçerik
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Group {
                        switch selectedTab {
                        case 0:
                            bilgiView
                        case 1:
                            hizmetlerView
                        case 2:
                            personellerView
                        case 3:
                            yorumlarView
                        default:
                            EmptyView()
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()

            // Randevu Al butonu
            Button(action: {
                // işlem
            }) {
                Text("Randevu Al")
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .ignoresSafeArea(edges: .top)
    }

    var bilgiView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Hakkında: \(viewModel.firmaBilgi?.description ?? "-")")
            Text("Adres: \(viewModel.firmaBilgi?.address ?? "-")")
        }
    }

    var hizmetlerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(viewModel.hizmetler, id: \.self) { hizmet in
                Label(hizmet, systemImage: "scissors")
            }
        }
    }

    var personellerView: some View {
        VStack(spacing: 8) {
            ForEach(viewModel.personeller, id: \.self) { personel in
                HStack {
                    Label(personel, systemImage: "person.fill")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 1)
            }
        }
    }

    var yorumlarView: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(viewModel.yorumlar, id: \.self) { yorum in
                Label(yorum, systemImage: "bubble.left.and.bubble.right.fill")
            }
        }
    }
}
