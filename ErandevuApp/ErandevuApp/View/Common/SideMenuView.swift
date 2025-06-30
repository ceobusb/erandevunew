import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var appState: AppState
    @Binding var showMenu: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 20) {
                // Üst Başlık
                HStack(spacing: 12) {
                    Image(systemName: "calendar.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)

                    Text("E-Randevu")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }

                Divider()

                menuButton("Anasayfa", systemImage: "house") {
                    appState.path = []
                    appState.path.append(.home)
                    showMenu = false
                }

                menuButton("Randevu Oluştur", systemImage: "calendar.badge.plus") {
                    appState.path = []
                    appState.path.append(appState.isLoggedIn ? .randevu : .login)
                    showMenu = false
                }

                if !appState.isLoggedIn {
                    menuButton("Giriş Yap", systemImage: "person.fill") {
                        appState.path = [.login]
                        showMenu = false
                    }

                    menuButton("Kayıt Ol", systemImage: "person.badge.plus") {
                        appState.path = [.register]
                        showMenu = false
                    }

                } else {
                    // Rol tabanlı menüler
                    if appState.role == 1 {
                        menuButton("Firma Profili", systemImage: "building.2") {
                            appState.path = [.firmaAccount]
                            showMenu = false
                        }
                    } else if appState.role == 2 {
                        menuButton("Profilim", systemImage: "person") {
                            appState.path = [.customerAccount]
                            showMenu = false
                        }
                    }

                    menuButton("Çıkış Yap", systemImage: "arrow.left.circle.fill", color: .red) {
                        appState.logout()
                        withAnimation {
                            showMenu = false
                            appState.path = [.home]
                        }
                    }
                }


                Spacer()
                Divider()
                Text("© 2025 E-Randevu")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.top, 60)
            .padding(.bottom, 30)
            .frame(width: 240)
            .background(Color.white)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 2, y: 0)
        }
    }

    // Buton Bileşeni
    func menuButton(_ label: String, systemImage: String, color: Color = .black, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: systemImage)
                    .frame(width: 24, height: 24)
                Text(label)
                    .font(.body)
            }
            .foregroundColor(color)
            .padding(.vertical, 6)
        }
    }
}
