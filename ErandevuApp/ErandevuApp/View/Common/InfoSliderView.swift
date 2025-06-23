import SwiftUI

struct InfoSliderView: View {
    @StateObject private var viewModel = SliderViewModel()
    @State private var currentIndex = 0
    let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            if viewModel.infoCards.isEmpty {
                ProgressView()
                    .frame(height: 200)
            } else {
                TabView(selection: $currentIndex) {
                    ForEach(0..<viewModel.infoCards.count, id: \.self) { index in
                        let card = viewModel.infoCards[index]
                        VStack(spacing: 12) {
                            Image(systemName: card.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                                .shadow(radius: 4)
                                .foregroundColor(.white)

                            Text(card.text)
                                .font(.headline)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .frame(height: 180)
                        .frame(width: 340)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(20)
                        .padding(.horizontal, 16)
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: 220)
                .onReceive(timer) { _ in
                    withAnimation {
                        currentIndex = (currentIndex + 1) % viewModel.infoCards.count
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadSliders()
        }
    }
}
