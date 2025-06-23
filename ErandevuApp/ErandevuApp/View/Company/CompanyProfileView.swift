import SwiftUI
struct SponsorDetailView: View {
    let sponsor: Sponsor

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: sponsor.logoName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)

            Text(sponsor.name)
                    .font(.title).bold()

                StarRatingView(rating: sponsor.rating)

                Text(String(format: "%.1f", sponsor.rating))
                    .font(.subheadline)
                    .foregroundColor(.gray)

            Text(sponsor.description)
                .padding()

            HStack {
                Image(systemName: "mappin.circle")
                Text(sponsor.address)
            }
            .foregroundColor(.gray)

            Spacer()

            Button(action: {
                // Randevu alma aksiyonu
            }) {
                Text("Randevu Al")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.top, 20)

            Spacer()
        }
        .padding()
        .navigationTitle(sponsor.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

