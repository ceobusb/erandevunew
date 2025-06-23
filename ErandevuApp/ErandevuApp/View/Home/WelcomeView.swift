import SwiftUI

struct WelcomeView: View {
    @State private var currentIndex = 0
    let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()

    let features = [
        ("Takvim ile Kolay Randevu", "Randevularınızı hızlıca yönetin.", "calendar", Color(red: 0.34, green: 0.29, blue: 0.89)),
        ("Personel Yönetimi", "Personel planlamasını yapın.", "person.2.fill", Color(red: 0.91, green: 0.3, blue: 0.24)),
        ("Hizmet Tanımları", "Sunduğunuz hizmetleri ekleyin.", "list.bullet.rectangle.portrait", Color(red: 0.20, green: 0.60, blue: 0.86)),
        ("Bildirimler", "Hatırlatmalarla müşterinizi bilgilendirin.", "bell.badge.fill", Color(red: 0.26, green: 0.74, blue: 0.55))
    ]



    var body: some View {
        VStack(spacing: 30) {
            
          

            InfoSliderView() // ← slider burada görünecek
            
            SponsorView()

            SectorShowcaseView()

            // Kayan Tanıtım Kartları
            TabView(selection: $currentIndex) {
                ForEach(0..<features.count, id: \.self) { index in
                    VStack(spacing: 12) {
                        Image(systemName: features[index].2)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .padding(12)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                            .shadow(radius: 4)
                            .foregroundColor(.white)


                        Text(features[index].0)
                            .font(.headline)
                            .foregroundColor(.white)

                        Text(features[index].1)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    .padding()
                    .padding(.bottom, 24) // 👈 Bu satır kartın altına boşluk bırakır
                    .frame(maxWidth: .infinity)
                    .background(features[index].3)
                    .cornerRadius(24)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 16)
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .frame(height: 220)
            .tabViewStyle(PageTabViewStyle())
            .onReceive(timer) { _ in
                withAnimation {
                    currentIndex = (currentIndex + 1) % features.count
                }
            }


            Spacer()
         

        }
        .padding(.bottom, 20)

    }
}
