import CoreLocation
import Foundation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?
    @Published var errorMessage: String?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        errorMessage = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = "Konum alınamadı"
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {
            errorMessage = "Konum izni reddedildi"
        }
    }
}
