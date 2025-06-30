//
//  APIService.swift
//  ErandevuApp
//
//  Created by Büşra Şener on 21.06.2025.
// dasdas
import Foundation
class APIService {
    static func fetchSlots(for companyID: Int, completion: @escaping (Result<[SlotModel], Error>) -> Void) {
        guard let url = URL(string: "\(Endpoints.baseURL)/firma/slots?firma_id=\(companyID)") else {
            return completion(.failure(URLError(.badURL)))
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let slots = try JSONDecoder().decode([SlotModel].self, from: data)
                    completion(.success(slots))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}


