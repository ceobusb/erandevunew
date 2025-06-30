import SwiftUI

struct HeaderView: View {
    @Binding var showMenu: Bool
    @EnvironmentObject var appState: AppState
    @State private var isLoggingOut = false

    var body: some View {
        HStack {
            // Menü ikonu
            Button {
                withAnimation {
                    showMenu.toggle()
                }
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
                    .frame(width: 40, alignment: .leading)
            }

            Spacer()

            // Logo
            HStack(spacing: 6) {
                Image(systemName: "calendar.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.black)
                Text("E-Randevu")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }

            Spacer()

            // Sağ üst ikonlar
            if appState.isLoggedIn {
                HStack(spacing: 20) {
                    // 👤 Hesap
                    Button {
                        appState.path = NavigationPath()
                        appState.path.append("Account")
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                    }

                    // 🔓 Çıkış
                    if isLoggingOut {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    } else {
                        Button {
                            withAnimation {
                                isLoggingOut = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                appState.logout()
                                isLoggingOut = false
                            }
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                        }
                    }
                }
            } else {
                // 🔐 Giriş / Kayıt
                HStack(spacing: 20) {
                    Button {
                        appState.path = NavigationPath()
                        appState.path.append("Login")
                    } label: {
                        Image(systemName: "person.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                    }

                    Button {
                        appState.path = NavigationPath()
                        appState.path.append("Register")
                    } label: {
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                    }
                }
                .frame(width: 60, alignment: .trailing)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 20)
        .background(Color(UIColor.systemGroupedBackground))
    }
}
