import Foundation
import UIKit

class MusteriService {
    
    static let shared = MusteriService()
    static func login(email: String, password: String, completion: @escaping (Result<CustomerModel, Error>) -> Void) {
        guard let url = URL(string: Endpoints.Customer.login) else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL Geçersiz"])
            completion(.failure(error))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-Api-Key")

        let postString = "email=\(email)&password=\(password)"
        request.httpBody = postString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Sunucudan veri alınamadı"])
                completion(.failure(error))
                return
            }
            print(String(data: data, encoding: .utf8) ?? "Boş veri")

            do {
                let decoded = try JSONDecoder().decode(APIResponseCustomer.self, from: data)
                if decoded.status, let customer = decoded.data {
                    completion(.success(customer))
                } else {
                    let apiError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: decoded.message])
                    completion(.failure(apiError))
                }
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }


    static func registerMusteri(
        fullName: String,
        email: String,
        password: String,
        address: String,
        latitude: Double,
        longitude: Double,
        completion: @escaping (Bool, String) -> Void
    ) {
        guard let url = URL(string: Endpoints.Customer.register) else {
            completion(false, "URL hatalı")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-Api-Key")

        // ✅ Tüm değerleri güvenli şekilde encode edelim
        let paramDict: [String: String] = [
            "full_name": fullName,
            "email": email,
            "password": password,
            "address": address,
            "latitude": "\(latitude)",
            "longitude": "\(longitude)",
            "role": "2"
        ]

        let paramString = paramDict.map { key, value in
            "\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }.joined(separator: "&")

        request.httpBody = paramString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }

            guard let data = data else {
                completion(false, "Sunucudan veri alınamadı.")
                return
            }

            do {
                let json = try JSONDecoder().decode(APIMessageResponse.self, from: data)
                completion(json.success, json.message)
            } catch {
                let responseStr = String(data: data, encoding: .utf8) ?? "Veri okunamadı"
                completion(false, "Yanıt çözümlenemedi. \(responseStr)")
            }
        }.resume()
    }

}
