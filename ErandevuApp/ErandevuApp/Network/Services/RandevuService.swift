import Foundation
import UIKit

class RandevuService {
    
    static let shared = RandevuService()
    
    private init() {}
    
    func createRandevu(firmaID: Int, customerID: Int, date: String, note: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: Endpoints.Customer.createrandevu) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-Api-Key")
        
        let postString = "firma_id=\(firmaID)&customer_id=\(customerID)&date=\(date)&note=\(note)"
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(GenericAPIResponse.self, from: data)
                completion(result.status)
            } catch {
                completion(false)
            }
        }.resume()
    }
    func getRandevular(customerID: Int, page: Int, completion: @escaping (Result<[CustomerRandevuModel], Error>) -> Void) {
        
        
        let urlString = "\(Endpoints.Customer.randevular)?customer_id=\(customerID)&limit=10&offset=\(page * 10)"
        
        
        guard let url = URL(string: urlString) else {
            completion(.success([]))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-Api-Key")
        
        let postString = "customer_id=\(customerID)"
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print("API RESPONSE: \(String(data: data, encoding: .utf8) ?? "Boş veri")")
            }
            
            guard let data = data,
                  let decoded = try? JSONDecoder().decode(CustomerRandevuResponse.self, from: data),
                  decoded.status else {
                print("Decode başarısız veya status false")
                completion(.success([])) // ya da .failure(...) verebilirsin
                return
            }
            
            completion(.success(decoded.data))
            
        }.resume()
        
    }
    
    static func updateCustomerRandevuStatus(customerID: Int,randevuID: Int, newStatus: Int, reason: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: Endpoints.Customer.updateStatus) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL geçersiz"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-Api-Key")
        
        let postString = "randevu_id=\(randevuID)&customer_id=\(customerID)&status=\(newStatus)&reason=\(reason)"
        request.httpBody = postString.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Gelen response: \(data)")
                completion(.failure(error ?? NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Sunucu hatası"])))
                return
            }

            // 🔍 GÖNDERİLEN VERİYİ GÖR
            if let raw = String(data: data, encoding: .utf8) {
                print("🔁 Gelen response:\n\(raw)")
            }
            
            do {
                let decoded = try JSONDecoder().decode(UpdateRandevuResponse.self, from: data)
                if decoded.status {
                    completion(.success(decoded.message))
                } else {
                    completion(.failure(NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: decoded.message])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    
    static func updateCustomerRandevuStatusTamamla(
        customerID: Int,
        randevuID: Int,
        newStatus: Int,
        reason: String,
        rating:Int, 
        comment: String,
        
        completion: @escaping (Result<String, Error>) -> Void) {
            guard let url = URL(string: Endpoints.Customer.updateStatusTamamla) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL geçersiz"])))
            return
        }
         
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(Endpoints.apikey, forHTTPHeaderField: "X-Api-Key")
        
        let postString = "rating=\(rating)&comment=\(comment)&randevu_id=\(randevuID)&customer_id=\(customerID)&status=\(newStatus)&reason=\(reason)"
        request.httpBody = postString.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
             
                completion(.failure(error ?? NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Sunucu hatası"])))
                return
            }

            // 🔍 GÖNDERİLEN VERİYİ GÖR
            if let raw = String(data: data, encoding: .utf8) {
                print("🔁 Gelen response:\n\(raw)")
            }
            
            do {
                let decoded = try JSONDecoder().decode(UpdateRandevuResponse.self, from: data)
                if decoded.status {
                    completion(.success(decoded.message))
                } else {
                    completion(.failure(NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: decoded.message])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    
    
    
    
    
}
struct GenericAPIResponse: Codable {
    let status: Bool
    let message: String
}
enum RandevuDurumu: Int, Codable {
    case bekliyor = 0
    case onaylandi = 1
    case iptalEdildi = 2
    case tamamlandi = 3
    
    var description: String {
        switch self {
        case .bekliyor: return "Bekliyor"
        case .onaylandi: return "Onaylandı"
        case .iptalEdildi: return "İptal Edildi"
        case .tamamlandi: return "Tamamlandı"
        }
    }
}

struct RandevuModel: Codable, Identifiable {
    let id: Int
    let firma_id: Int
    let customer_id: Int
    let date: String
    let note: String
    let status: RandevuDurumu
}

struct RandevuListResponse: Codable {
    let status: Bool
    let data: [RandevuModel]
}

struct UpdateRandevuResponse: Codable {
    let status: Bool
    let message: String
}


