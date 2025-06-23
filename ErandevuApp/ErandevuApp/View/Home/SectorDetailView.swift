import SwiftUI

struct SectorDetailView: View {
    let sector: Sector

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Image(systemName: sector.icon)
                    .font(.system(size: 64))
                    .padding()
                    .background(sector.color.opacity(0.2))
                    .clipShape(Circle())
                    .foregroundColor(sector.color)

                Text(sector.title)
                    .font(.largeTitle)
                    .bold()

                Text(sector.description)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding()

                Spacer()
            }
            .padding()
        }
        .navigationTitle(sector.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
