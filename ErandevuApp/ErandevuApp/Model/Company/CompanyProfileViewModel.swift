
import SwiftUI

class CompanyProfileViewModel: ObservableObject {
    @Published var firmaBilgi: FeaturedCompany?
    @Published var hizmetler: [String] = []
    @Published var personeller: [String] = []
    @Published var yorumlar: [String] = []

    func fetchFirmaDetay(firmaId: Int) {
        guard let url = URL(string: "\(Endpoints.Firma.detail)?id=\(firmaId)") else { return }

        var request = URLRequest(url: url)
        request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-Api-Key")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("İstek hatası: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("Veri alınamadı")
                return
            }

            // Gelen veriyi JSON olarak yazdır
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Gelen JSON:")
                print(jsonString)
            }

            do {
                let decoded = try JSONDecoder().decode(FirmaDetayResponse.self, from: data)
                DispatchQueue.main.async {
                    self.firmaBilgi = decoded.data
                }
            } catch {
                print("Firma detay decode hatası: \(error.localizedDescription)")
            }
        }.resume()
    }


    func fetchHizmetler(firmaId: Int) {
        guard let url = URL(string: "\(Endpoints.Firma.services)?id=\(firmaId)") else { return }

        var request = URLRequest(url: url)
        request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-Api-Key")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode(FirmaHizmetResponse.self, from: data)
                DispatchQueue.main.async {
                    self.hizmetler = decoded.services
                }
            } catch {
                print("Hizmetler decode hatası: \(error.localizedDescription)")
            }
        }.resume()
    }

    func fetchPersoneller(firmaId: Int) {
        guard let url = URL(string: "\(Endpoints.Firma.personeller)?id=\(firmaId)") else { return }

        var request = URLRequest(url: url)
        request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-Api-Key")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode(FirmaPersonelResponse.self, from: data)
                DispatchQueue.main.async {
                    self.personeller = decoded.personeller
                }
            } catch {
                print("Personel decode hatası: \(error.localizedDescription)")
            }
        }.resume()
    }

    func fetchYorumlar(firmaId: Int) {
        guard let url = URL(string: "\(Endpoints.Firma.yorumlar)?id=\(firmaId)") else { return }

        var request = URLRequest(url: url)
        request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-Api-Key")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode(FirmaYorumResponse.self, from: data)
                DispatchQueue.main.async {
                    self.yorumlar = decoded.yorumlar
                }
            } catch {
                print("Yorum decode hatası: \(error.localizedDescription)")
            }
        }.resume()
    }
}
struct FirmaDetayResponse: Codable {
    let status: Bool
    let data: FeaturedCompany
}


struct FirmaHizmetResponse: Codable {
    let status: Bool
    let message: String
    let services: [String]
}

struct FirmaPersonelResponse: Codable {
    let status: Bool

    let personeller: [String]
}

struct FirmaYorumResponse: Codable {
    let status: Bool
    let message: String
    let yorumlar: [String]
}

