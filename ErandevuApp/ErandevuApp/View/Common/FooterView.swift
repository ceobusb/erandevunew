import SwiftUI

struct FooterView: View {
    var body: some View {
        VStack(spacing: 6) {
            Divider()

            HStack {
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("© 2025 E-Randevu")
                        .font(.footnote)
                        .foregroundColor(.gray)

                    HStack(spacing: 20) {
                        Link("Gizlilik Politikası", destination: URL(string: "https://erandevu.com/gizlilik")!)
                        Link("Kullanım Şartları", destination: URL(string: "https://erandevu.com/sartlar")!)
                    }
                    .font(.footnote)
                    .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            .padding(.vertical, 20)
        }

   
        .background(Color(UIColor.systemGroupedBackground)) 
    }
}
