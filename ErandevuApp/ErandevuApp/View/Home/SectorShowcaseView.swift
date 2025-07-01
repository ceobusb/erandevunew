import SwiftUI
import SDWebImageSwiftUI
import CoreLocation

struct SectorShowcaseView: View {
    @State private var sectors: [Sector] = []
    @ObservedObject var locationManager: LocationManager
    var userLatitude: Double
     var userLongitude: Double
    @EnvironmentObject var appState: AppState
    // 2 kolonlu grid yapısı
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Sektörler")
                .font(.title2)
                .bold()
                .padding(.horizontal)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(sectors) { sector in
                    Button(action: {
                        appState.path.append(.sectorDetail(sector))
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: sector.icon)
                                .font(.title)
                                .foregroundColor(.white)

                            Text(sector.title)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        }
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background(Color(hexOrName: sector.color_name))
                        .cornerRadius(12)
                        .shadow(radius: 2)
                        .padding(.horizontal, 4)
                    }

                }
            }
            .padding()
        }
        .onAppear {
            SectorService.fetchSectors { result in
                DispatchQueue.main.async {
                    self.sectors = result
                }
            }
        }
    }
}
