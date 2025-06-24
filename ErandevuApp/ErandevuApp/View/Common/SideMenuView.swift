import SwiftUI

struct SideMenuView: View {
    @State private var selectedSponsor: Sponsor? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Menü")
                .font(.headline)
                .padding(.top, 40)

            NavigationLink(destination: WelcomeView()) {
                Label("Anasayfa", systemImage: "house")
            }

            NavigationLink(destination: RandevuKayitView()) {
                Label("Randevu Oluştur", systemImage: "calendar.badge.plus")
            }

            NavigationLink(destination: LoginView()) {
                Label("Giriş Yap", systemImage: "person.fill")
            }

            NavigationLink(destination: RegisterView()) {
                Label("Kayıt Ol", systemImage: "person.badge.plus")
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(width: 250)
        .background(Color.white.shadow(radius: 5))
    }
}
