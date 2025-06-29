import Foundation

class EmailAPI {

    
    static func sendVerificationCode(email: String, completion: @escaping (Bool, String) -> Void) {
         
        guard let url = URL(string: Endpoints.Firma.register) else {
            completion(false, "Geçersiz URL")
            return
        }

          var request = URLRequest(url: url)
          request.httpMethod = "POST"
          request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-Api-Key")
          request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

          let postString = "email=\(email)"
          request.httpBody = postString.data(using: .utf8)

          URLSession.shared.dataTask(with: request) { data, response, error in
              if let data = data {
                  if let result = try? JSONDecoder().decode(GenericResponses.self, from: data) {
                      completion(result.status, result.message)
                  } else {
                      completion(false, "Yanıt çözülemedi")
                  }
              } else {
                  completion(false, error?.localizedDescription ?? "Sunucu hatası")
              }
          }.resume()
      }

    static func sendVerificationCodeNew(email: String, completion: @escaping (Bool, String) -> Void) {
        
        guard let url = URL(string: Endpoints.Firma.resend_firma_kod) else {
            completion(false, "Geçersiz URL")
            return
        }

          var request = URLRequest(url: url)
          request.httpMethod = "POST"
          request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-Api-Key")
          request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

          let postString = "email=\(email)"
          request.httpBody = postString.data(using: .utf8)

          URLSession.shared.dataTask(with: request) { data, response, error in
              if let data = data {
                  if let result = try? JSONDecoder().decode(GenericResponses.self, from: data) {
                      completion(result.status, result.message)
                  } else {
                      completion(false, "Yanıt çözülemedi")
                  }
              } else {
                  completion(false, error?.localizedDescription ?? "Sunucu hatası")
              }
          }.resume()
      }
    
    
    static func confirmVerificationCode(email: String, code: String, completion: @escaping (Bool, String, FirmaData?) -> Void) {
         
        guard let url = URL(string: Endpoints.Firma.verifyCode) else {
            completion(false, "Geçersiz URL", nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-Api-Key")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let postString = "email=\(email)&kod=\(code)"
        request.httpBody = postString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(GenericResponse<FirmaData>.self, from: data)
                    print(result)
                    completion(result.status, result.message, result.data)
                } catch {
                    print("Decode hatası: \(error)")
                    completion(false, "Yanıt çözülemedi", nil)
                }
            } else {
                completion(false, error?.localizedDescription ?? "Sunucu hatası", nil)
            }
        }.resume()
    }

}
struct GenericResponse<T: Codable>: Codable {
    let status: Bool
    let message: String
    let data: T?
}


struct GenericResponses: Codable {
    let status: Bool
    let message: String
}
struct FirmaData: Codable {
    let firma_id: Int
    let firma_name: String
}

