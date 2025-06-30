import SwiftUI
struct MainLayout<Content: View>: View {
    @Binding var showMenu: Bool
    let content: () -> Content

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 0) {
                HeaderView(showMenu: $showMenu)
                content()
                FooterView()
            }

            if showMenu {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            showMenu = false
                        }
                    }
                    .zIndex(0)
            }

        }
    }
}
