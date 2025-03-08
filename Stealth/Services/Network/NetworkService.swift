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

        switch httpResponse.statusCode {
        case 200...299:
            break
        case 400:
            throw NetworkError.serverError(httpResponse.statusCode, "Bad request")
        case 401:
            throw NetworkError.serverError(httpResponse.statusCode, "Unauthorized")
        case 403:
            throw NetworkError.serverError(httpResponse.statusCode, "Forbidden")
        case 404:
            throw NetworkError.serverError(httpResponse.statusCode, "Not found")
        case 500:
            throw NetworkError.serverError(httpResponse.statusCode, "Internal server error")
        default:
            throw NetworkError.serverError(httpResponse.statusCode, "Unknown server error")
        }

        do {
            let decodedResponse = try JSONDecoder().decode(U.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.decodingError
        }
    }


    func sendPreferences(_ preferences: [String: Bool], supabaseID: String)
        async throws
    {
        let payload = PreferencesPayload(
            supabase_id: supabaseID, preferences: preferences)

        let _: EmptyResponse = try await request(
            endpoint: "/onboarding/set-preferences",
            method: .post,
            body: payload
        )
    }

    /// Store user traits
    func storeUserTraits(basicInfoSubmission payload: BasicInfoSubmission, supabaseID: String)
        async throws
    {

        let _: EmptyResponse = try await request(
            endpoint: "/personality-traits", method: .post, body: payload
        )
    }
}
