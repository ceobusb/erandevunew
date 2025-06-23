import SwiftUI

struct SectorShowcaseView: View {
    
    
    let sectors: [Sector] = [
        Sector(title: "Kuaför & Güzellik", icon: "scissors", colorName: "blue", description: "Kuaför, güzellik salonu, cilt bakımı merkezleri için hızlı randevu yönetimi."),
        Sector(title: "Oto Servis", icon: "car.fill", colorName: "green", description: "Servis rezervasyonları, bakım takibi ve müşteri yönetimi."),
        Sector(title: "Danışmanlık", icon: "checkmark.circle.fill", colorName: "purple", description: "Psikolojik, hukuki, bireysel danışmanlık hizmetleri için uygundur."),
        Sector(title: "Eğitim", icon: "book.fill", colorName: "red", description: "Özel dersler, dil kursları, okul randevuları için uygundur."),
        Sector(title: "Klinik & Sağlık", icon: "cross.case.fill", colorName: "teal", description: "Poliklinikler, aile hekimlikleri, fizyoterapi merkezleri için özel modüller içerir."),
        Sector(title: "Etkinlik Planlama", icon: "calendar.badge.clock", colorName: "indigo", description: "Etkinlik organizasyon firmaları ve rezervasyonlar için mükemmel.")
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Sektörler")
                .font(.title2)
                .bold()
                .padding(.horizontal)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(sectors) { sector in
                    NavigationLink(destination: SectorDetailView(sector: sector)) {
                        VStack(spacing: 8) {
                            Image(systemName: sector.icon)
                                .font(.title)
                                .foregroundColor(.white)

                            Text(sector.title)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        }
                        .frame(height: 80)
                        .frame(maxWidth: .infinity)
                        .background(sector.color)
                        .cornerRadius(12)
                        .padding(.horizontal, 8)
                    }
                }
            }
            .padding(.vertical)
        }
    }
}
