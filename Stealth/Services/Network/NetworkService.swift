//
//  NetworkService.swift
//  Stealth
//
//  Created by Rohit Manivel on 10/30/24.
//

import Foundation

class NetworkService {
    func sendPreferences(_ jsonString: String) async throws {
        guard let url = URL(string: "YOUR_SERVER_URL/preferences") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonString.data(using: .utf8)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
    }
}
