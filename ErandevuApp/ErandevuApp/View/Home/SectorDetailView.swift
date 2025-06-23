import SwiftUI

struct SectorDetailView: View {
    let sector: Sector

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Simgeli daire alan
                ZStack {
                    Circle()
                        .fill(Color(hexOrName: sector.color_name).opacity(0.2))
                        .frame(width: 120, height: 120)

                    Image(systemName: sector.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(hexOrName: sector.color_name))
                }
                .padding(.top, 32)

                // Başlık
                Text(sector.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                // Açıklama
                Text(sector.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
        .navigationTitle(sector.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
