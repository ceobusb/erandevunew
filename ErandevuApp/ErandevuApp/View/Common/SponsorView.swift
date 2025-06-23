import SwiftUI

let sponsors: [Sponsor] = [
    Sponsor(name: "Makro2000", logoName: "m.circle.fill", description: "ERP ve inşaat çözümleri", rating: 2.8, address: "İstanbul, Türkiye"),
    Sponsor(name: "Suare Halı", logoName: "s.circle.fill", description: "Dijital baskılı halı üretimi", rating: 4.6, address: "İzmir"),
    Sponsor(name: "TechSoft", logoName: "t.circle.fill", description: "Mobil ve web geliştirme", rating: 4.9, address: "Ankara"),
    Sponsor(name: "A Firması", logoName: "q.circle.fill", description: "Danışmanlık çözümleri", rating: 4.5, address: "Bakü"),
    Sponsor(name: "B Firması", logoName: "b.circle.fill", description: "Sağlık teknolojileri", rating: 4.2, address: "İstanbul"),
    Sponsor(name: "C Firması", logoName: "c.circle.fill", description: "Etkinlik planlama", rating: 4.7, address: "İzmir")
]

let sponsorColors: [Color] = [.blue, .green, .purple, .pink, .teal, .indigo]

struct SponsorView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Öne Çıkan Firmalar")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(sponsors.enumerated()), id: \.element.id) { index, sponsor in
                        NavigationLink(destination: SponsorDetailView(sponsor: sponsor)) {
                            VStack(spacing: 6) {
                                Image(systemName: sponsor.logoName)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                                Text(sponsor.name)
                                    .font(.footnote)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(sponsorColors[index % sponsorColors.count])
                            .cornerRadius(12)
                            .shadow(radius: 1)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom, 16)
    }
}



