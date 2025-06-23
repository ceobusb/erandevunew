import SwiftUI

struct ContentView: View {
    @State private var showMenu = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea(.all, edges: .top) // Üstteki beyaz boşluğu yok eder

                VStack(spacing: 0) {
                    // Header
                    HeaderView(showMenu: $showMenu)
                        .background(Color.orange)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2) // ALT GÖLGE
                        .overlay(
                            Rectangle()
                                .frame(height: 0.5)
                                .foregroundColor(Color.black.opacity(0.15))
                                .padding(.top, 50),
                            alignment: .bottom
                        )


                    // Ana içerik
                    ScrollView(showsIndicators: false) {
                        WelcomeView()
                    }

                    // Footer
                    FooterView()
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}
