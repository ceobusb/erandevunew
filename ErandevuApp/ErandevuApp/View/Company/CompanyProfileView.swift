import MapKit
import SwiftUI

struct SponsorDetailView: View {
    let sponsor: Sponsor

    @State private var cameraPosition: MapCameraPosition

    init(sponsor: Sponsor) {
        self.sponsor = sponsor
        let latitude = sponsor.latitude ?? 0
        let longitude = sponsor.longitude ?? 0

        _cameraPosition = State(
            initialValue: .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: latitude,
                        longitude: longitude
                    ),
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.01,
                        longitudeDelta: 0.01
                    )
                )
            )
        )
    }

    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: URL(string: sponsor.logoUrl)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
            } placeholder: {
                ProgressView()
                    .frame(width: 80, height: 80)
            }

            Text(sponsor.name)
                .font(.title)
                .bold()

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
            Map(position: $cameraPosition) {
                Marker(
                    sponsor.name,
                    coordinate: CLLocationCoordinate2D(
                        latitude: sponsor.latitude,
                        longitude: sponsor.longitude
                    )
                )
            }
            .frame(height: 200)
            .cornerRadius(10)
            .padding(.vertical)

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
