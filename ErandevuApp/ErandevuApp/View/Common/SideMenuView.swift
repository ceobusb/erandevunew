import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var appState: AppState
    @Binding var showMenu: Bool  // ✅ Bunu ekliyoruz

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Menü")
                .font(.title2)
                .bold()
                .padding(.top, 40)

            Button {
                appState.path = NavigationPath()
                appState.path.append("Home")
                showMenu = false
            } label: {
                Label("Anasayfa", systemImage: "house")
            }

            Button {
                if appState.isLoggedIn {
                    appState.path = NavigationPath()
                    appState.path.append("Randevu")
                } else {
                    appState.path = NavigationPath()
                    appState.path.append("Login")
                }
                showMenu = false
            } label: {
                Label("Randevu Oluştur", systemImage: "calendar.badge.plus")
            }

            if !appState.isLoggedIn {
                Button {
                    appState.path = NavigationPath()
                    appState.path.append("Login")
                    showMenu = false
                } label: {
                    Label("Giriş Yap", systemImage: "person.fill")
                }

                Button {
                    appState.path = NavigationPath()
                    appState.path.append("Register")
                    showMenu = false
                } label: {
                    Label("Kayıt Ol", systemImage: "person.badge.plus")
                }
            } else {
                Divider().padding(.vertical)

                Button {
                    appState.path = NavigationPath()
                    appState.path.append("Account")
                    showMenu = false
                } label: {
                    Label("Firma Profili", systemImage: "building.2.crop.circle")
                }

                Button {
                    appState.logout()
                    withAnimation {
                        showMenu = false
                        appState.path = NavigationPath()
                        appState.path.append("Home")
                    }
                } label: {
                    Label("Çıkış Yap", systemImage: "arrow.left.circle.fill")
                        .foregroundColor(.red)
                }
            }

            Spacer()
        }
        .padding()
        .frame(width: 260)
        .background(Color.white)
        .edgesIgnoringSafeArea(.vertical)
        .shadow(radius: 5)
    }
}
