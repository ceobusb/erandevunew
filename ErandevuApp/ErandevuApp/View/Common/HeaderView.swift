import SwiftUI

struct HeaderView: View {
    @Binding var showMenu: Bool

    var body: some View {
        HStack {
            // Menü ikonu
            Button(action: {
                withAnimation {
                    showMenu.toggle()
                }
            }) {
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

            // Giriş/Kayıt ikonları
            HStack(spacing: 20) {
                NavigationLink(destination: LoginView()) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                }

                NavigationLink(destination: RegisterView()) {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                }
            }
            .frame(width: 60, alignment: .trailing)
        }
        .padding(.horizontal)
        .padding(.vertical, 20)
        .background(Color(UIColor.systemGroupedBackground))



  
    }
}
