import Foundation
class SectorService {
    static func fetchSectors(completion: @escaping ([Sector]) -> Void) {
        guard let url = URL(string: Endpoints.Sektor.list) else {
            completion([])
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-Api-Key") // ← önemli

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let data = data {
                let rawResponse = String(data: data, encoding: .utf8) ?? "Veri çözümlenemedi"
               
                
                do {
                    let response = try JSONDecoder().decode(SectorResponse.self, from: data)
                    completion(response.data)
                } catch {
                    print("❌ JSON decode hatası: \(error)")
                    completion([])
                }
            } else {
                print("❗ Veri gelmedi. Hata: \(error?.localizedDescription ?? "Bilinmiyor")")
                completion([])
            }
        }.resume()
    }
    
}

struct SectorResponse: Codable {
    let status: Bool
    let data: [Sector]
}
