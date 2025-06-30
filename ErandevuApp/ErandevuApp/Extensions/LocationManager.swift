import CoreLocation
import Foundation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?
    @Published var errorMessage: String?
     @Published var locationFetched = false

     override init() {
         super.init()
         manager.delegate = self
         manager.desiredAccuracy = kCLLocationAccuracyBest
         manager.requestWhenInUseAuthorization()
         manager.startUpdatingLocation()
     }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first?.coordinate {
            location = loc
            locationFetched = true  // 🔔 konum başarıyla alındı
            errorMessage = nil
            manager.stopUpdatingLocation() // 🔴 Bu satırı EKLE

        }
    }


    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = "Konum alınamadı"
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {
            errorMessage = "Konum izni reddedildi"
        }
    }
    func requestLocation() {
        manager.requestLocation()
    }
    

}
