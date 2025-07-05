import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @State private var currentPage = 0

    let pages: [OnboardingData] = [
        OnboardingData(title: "Hoş Geldiniz!", description: "E-Randevu ile işletmeleri kolayca keşfedin.", icon: "location.viewfinder"),
        OnboardingData(title: "Kolay Rezervasyon", description: "Sadece birkaç dokunuşla randevunuzu oluşturun.", icon: "calendar.badge.plus"),
        OnboardingData(title: "Takipte Kalın", description: "Randevularınızı yönetin ve değerlendirme yapın.", icon: "clock.arrow.circlepath")
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingCard(data: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 500)

                HStack(spacing: 8) {
                    ForEach(0..<pages.count) { index in
                        Circle()
                            .fill(currentPage == index ? Color.white : Color.white.opacity(0.4))
                            .frame(width: 10, height: 10)
                    }
                }

                Spacer()

                Button(action: {
                    if currentPage == pages.count - 1 {
                        hasSeenOnboarding = true
                    } else {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Başlayalım" : "İleri")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                Spacer(minLength: 40)
            }
        }
    }
}

struct OnboardingCard: View {
    let data: OnboardingData

    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: data.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundColor(.white)

            Text(data.title)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)

            Text(data.description)
                .multilineTextAlignment(.center)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .padding(.horizontal)
        }
        .padding()
    }
}

struct OnboardingData {
    let title: String
    let description: String
    let icon: String
}
