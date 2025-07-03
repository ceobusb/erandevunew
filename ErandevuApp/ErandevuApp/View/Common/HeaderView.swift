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
                    .foregroundColor(Color(.black))
                    .frame(width: 40, alignment: .leading)
            }

            Spacer()

            // Logo
            HStack(spacing: 6) {
                Image(systemName: "calendar.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color(.black))
                Text("E-Randevu")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.black))
            }

            Spacer()

            // Sağ üst ikonlar
            if appState.isLoggedIn {
                HStack(spacing: 20) {
                    // 👤 Hesap
                    Button {
                             appState.path = []
                             if appState.role == 1 {
                                 appState.path.append(.firmaAccount)
                             } else if appState.role == 2 {
                                 appState.path.append(.customerAccount)
                             }
                         } label: {
                             Image(systemName: "person.crop.circle")
                                 .font(.system(size: 18))
                                 .foregroundColor(Color(.black))
                         }

                    // 🔓 Çıkış
                    if isLoggingOut {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(.black))
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
                                .foregroundColor(Color(.black))
                        }
                    }
                }
            } else {
                // 🔐 Giriş / Kayıt
                HStack(spacing: 20) {
                    Button {
                        appState.path = []
                        appState.path.append(.login(redirectAfter: .randevu))
                    } label: {
                        Image(systemName: "person.fill")
                            .font(.system(size: 18))
                            .foregroundColor(Color(.black))
                    }

                    Button {
                        appState.path = []
                        appState.path.append(.register)
                    } label: {
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 18))
                            .foregroundColor(Color(.black))
                    }
                }
                .frame(width: 60, alignment: .trailing)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 20)
        .background(Color(.white))
    }
}
