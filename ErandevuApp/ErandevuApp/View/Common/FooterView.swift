import SwiftUI

struct FooterView: View {
    var body: some View {
        VStack(spacing: 12) {
            Divider()

            VStack(spacing: 6) {
                Text("E-Randevu © 2025")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)

                HStack(spacing: 20) {
                    Link("Gizlilik Politikası", destination: URL(string: "https://erandevu.com/gizlilik")!)
                    Link("Kullanım Şartları", destination: URL(string: "https://erandevu.com/sartlar")!)
                }
                .font(.footnote)
                .foregroundColor(.blue)
            }
            .padding(.vertical, 12)
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.secondarySystemGroupedBackground))
    }
}
