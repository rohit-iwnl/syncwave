//
//  NetworkService.swift
//  Stealth
//
//  Created by Rohit Manivel on 10/30/24.
//

import Foundation

struct PreferencesPayload: Codable {
    let supabase_id: String
    let preferences: [String: Bool]
}

typealias NetworkResult<U: Codable> = (U) async throws -> Void

struct EmptyResponse: Codable {}


class NetworkService {
    static let shared = NetworkService()
    private let baseURL = "http://159.89.222.41:8000/api"
    private let authToken = "Bearer Naandhaandaungoppan"
    
    private init() {}
    
    func request<T: Codable, U: Codable>(
        endpoint: String,
        method: HTTPMethod,
        body: T?
    ) async throws -> U {
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(authToken, forHTTPHeaderField: "Authorization")
        
        if let body = body {
            do {
                let jsonData = try JSONEncoder().encode(body)
                request.httpBody = jsonData
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("Request Body:\n\(jsonString)")
                }
            } catch {
                throw NetworkError.encodingError
            }
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        print("Status code: \(httpResponse.statusCode)")
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError("API call failed with status code: \(httpResponse.statusCode)")
        }
        
        do {
                    let decodedResponse = try JSONDecoder().decode(U.self, from: data)
                    return decodedResponse
                } catch {
                    throw NetworkError.decodingError
                }
    }
    
    func sendPreferences(_ preferences: [String: Bool], supabaseID: String) async throws {
        let payload = PreferencesPayload(supabase_id: supabaseID, preferences: preferences)
        
        let _: EmptyResponse = try await request(
            endpoint: "/onboarding/set-preferences",
            method: .post,
            body: payload
        )
    }
}
