import Foundation
import UIKit

class FirmaService {
    
    static let shared = FirmaService()
    
    private init() {}
    
    static func registerFirma(
        companyName: String,
        sectorID: String,
        description: String,
        address: String,
        latitude: Double,
        longitude: Double,
        fullName: String,
        email: String,
        password: String,
        logo: UIImage,
        completion: @escaping (Bool, String) -> Void
    ) {
        guard let url = URL(string: Endpoints.Firma.register) else {
            completion(false, "Geçersiz URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-Api-Key")
        
        var data = Data()
        
        func appendField(name: String, value: String) {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Alanları ekle
        appendField(name: "company_name", value: companyName)
        appendField(name: "sector_id", value: sectorID)
        appendField(name: "description", value: description)
        appendField(name: "address", value: address)
        appendField(name: "latitude", value: "\(latitude)")
        appendField(name: "longitude", value: "\(longitude)")
        appendField(name: "full_name", value: fullName)
        appendField(name: "email", value: email)
        appendField(name: "password", value: password)
        appendField(name: "role", value: "1")
        print(">>> email: \(email)")
        
        
        // Logo (JPEG 500x500 zorunlu)
        if let imageData = logo.jpegData(compressionQuality: 0.8) {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"logo\"; filename=\"logo.jpg\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(imageData)
            data.append("\r\n".data(using: .utf8)!)
        }
        
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { d, r, e in
            if let d = d,
               let res = try? JSONDecoder().decode(GenericResponses.self, from: d) {
                completion(res.status, res.message)
            } else {
                completion(false, "Sunucu hatası")
            }
        }.resume()
    }
    func fetchFeaturedCompanies(completion: @escaping (Result<[FeaturedCompany], Error>) -> Void) {
        guard let url = URL(string: Endpoints.Firma.featuredCompanies) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL Geçersiz"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-Api-Key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Veri alınamadı"])))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(FeaturedCompanyResponse.self, from: data)
                
                completion(.success(decoded.data))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchNearbyCompanies(latitude: Double, longitude: Double, distance: Int, completion: @escaping (Result<[FeaturedCompany], Error>) -> Void)
    {
        let urlString = "\(Endpoints.Firma.nearbyCompanies)?latitude=\(latitude)&longitude=\(longitude)&distance=\(distance)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL Geçersiz"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-Api-Key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Veri alınamadı"])))
                return
            }
            print(String(data: data, encoding: .utf8) ?? "Veri çözümlenemedi")

            
            
            do {
                let decoded = try JSONDecoder().decode(FeaturedCompanyResponse.self, from: data)
                completion(.success(decoded.data))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    static func login(email: String, password: String, completion: @escaping (Result<CompanyModel, Error>) -> Void) {
        guard let url = URL(string: Endpoints.Firma.login) else {
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
            
           
            
            do {
                let decoded = try JSONDecoder().decode(APIResponse<CompanyModel>.self, from: data)
                
                
                if decoded.status, let company = decoded.data {
                    completion(.success(company))
                } else {
                    let apiError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: decoded.message])
                    completion(.failure(apiError))
                }
                
                
                
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
    
    
    
    
}
struct APIMessageResponse: Codable {
    let success: Bool
    let message: String
    enum CodingKeys: String, CodingKey {
        case success = "status"
        case message
    }
}


struct APIResponse<T: Codable>: Codable {
    let status: Bool
    let message: String
    let data: T?
}


struct FeaturedCompanyResponse: Codable {
    let status: Bool
    let message: String
    let data: [FeaturedCompany]
}


