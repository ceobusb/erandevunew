import Foundation

class SliderService {
    static func fetchSliders(completion: @escaping ([SliderInfo]) -> Void) {
        guard let url = URL(string: Endpoints.Slider.list) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-API-KEY") // ← önemli

        URLSession.shared.dataTask(with: request) { data, _, error in // ← düzeltildi
            if let error = error {
                print("API Hata: \(error.localizedDescription)")
                return
            }

            guard let data = data else { return }

            do {
                let sliders = try JSONDecoder().decode([SliderInfo].self, from: data)
                DispatchQueue.main.async {
                    completion(sliders)
                }
            } catch {
                print("Decode Hata: \(error.localizedDescription)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Gelen Veri: \(jsonString)")
                }
            }
        }.resume()
    }
}

