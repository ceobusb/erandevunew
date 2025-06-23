import Foundation

class EmailAPI {
    static func sendKod(email: String, completion: @escaping (Bool, String) -> Void) {
      
        
        guard let url = URL(string: Endpoints.Firma.register) else {
            completion(false, "Geçersiz URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-API-KEY")


        let bodyString = "email=\(email)"
        request.httpBody = bodyString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                let result = try? JSONDecoder().decode(GenericResponse.self, from: data)
                completion(result?.status ?? false, result?.message ?? "Sunucu hatası")
            } else {
                completion(false, "İstek başarısız")
            }
        }.resume()
    }

    static func confirmKod(email: String, kod: String, completion: @escaping (Bool, String) -> Void) {

        guard let url = URL(string: Endpoints.Firma.verifyCode) else {
            completion(false, "Geçersiz URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-API-KEY")

        let bodyString = "email=\(email)&kod=\(kod)"
        request.httpBody = bodyString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                let result = try? JSONDecoder().decode(GenericResponse.self, from: data)
                completion(result?.status ?? false, result?.message ?? "Sunucu hatası")
            } else {
                completion(false, "İstek başarısız")
            }
        }.resume()
    }
    
    static func sendVerificationCode(email: String, completion: @escaping (Bool, String) -> Void) {
         
        guard let url = URL(string: Endpoints.Firma.register) else {
            completion(false, "Geçersiz URL")
            return
        }

          var request = URLRequest(url: url)
          request.httpMethod = "POST"
          request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-API-KEY")
          request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

          let postString = "email=\(email)"
          request.httpBody = postString.data(using: .utf8)

          URLSession.shared.dataTask(with: request) { data, response, error in
              if let data = data {
                  if let result = try? JSONDecoder().decode(GenericResponse.self, from: data) {
                      completion(result.status, result.message)
                  } else {
                      completion(false, "Yanıt çözülemedi")
                  }
              } else {
                  completion(false, error?.localizedDescription ?? "Sunucu hatası")
              }
          }.resume()
      }
    static func confirmVerificationCode(email: String, code: String, completion: @escaping (Bool, String) -> Void) {
     
        guard let url = URL(string: Endpoints.Firma.verifyCode) else {
            completion(false, "Geçersiz URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-API-KEY")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let postString = "email=\(email)&kod=\(code)"
        request.httpBody = postString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let result = try? JSONDecoder().decode(GenericResponse.self, from: data) {
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
          request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-API-KEY")
          request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

          let postString = "email=\(email)"
          request.httpBody = postString.data(using: .utf8)

          URLSession.shared.dataTask(with: request) { data, response, error in
              if let data = data {
                  if let result = try? JSONDecoder().decode(GenericResponse.self, from: data) {
                      completion(result.status, result.message)
                  } else {
                      completion(false, "Yanıt çözülemedi")
                  }
              } else {
                  completion(false, error?.localizedDescription ?? "Sunucu hatası")
              }
          }.resume()
      }
}


struct GenericResponse: Codable {
    let status: Bool
    let message: String
}
