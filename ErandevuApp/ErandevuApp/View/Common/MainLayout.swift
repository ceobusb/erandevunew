import SwiftUI

struct MainLayout<Content: View>: View {
    var userName: String
    let content: Content

    @State private var showMenu = false

    init(userName: String, @ViewBuilder content: () -> Content) {
        self.userName = userName
        self.content = content()
    }

    var body: some View {
        ZStack {
            NavigationStack {
                VStack(spacing: 0) {
                    HeaderView(showMenu: $showMenu)
                    content
                    FooterView()
                }
                .background(Color(.systemGroupedBackground))
            }

            // Side Menu
            if showMenu {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showMenu = false
                        }
                    }

                SideMenuView()
                    .transition(.move(edge: .leading))
                    .zIndex(1)
            }
        }
    }
}

