import SwiftUI

struct MainLayout<Content: View>: View {
    @Binding var showMenu: Bool
    let content: () -> Content
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .leading) {
            // 🔵 Ana içerik
            VStack(spacing: 0) {
                HeaderView(showMenu: $showMenu)
                content()
                FooterView()
            }
            .disabled(showMenu)
            .blur(radius: showMenu ? 3 : 0)
            .zIndex(0)

            // ⚫️ Siyah opak arka plan (menü açıkken)
            if showMenu {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showMenu = false
                        }
                    }
                    .zIndex(1)
            }

            // ⚪️ Menü kutusu
            SideMenuView(showMenu: $showMenu)
                .frame(width: 240)
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
                .offset(x: showMenu ? 0 : -300)
                .animation(.easeInOut(duration: 0.3), value: showMenu)
                .zIndex(2) // Menü her zaman en üstte olacak
        }
        .animation(.easeInOut, value: showMenu)
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -200 {
                        withAnimation {
                            showMenu = false
                        }
                    }
                }
        )
       
    }
}
