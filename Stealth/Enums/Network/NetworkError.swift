//
//  NetworkError.swift
//  Stealth
//
//  Created by Rohit Manivel on 10/30/24.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case encodingError
    case invalidResponse
    case serverError(Int, String)
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .encodingError:
            return "Failed to encode data"
        case .invalidResponse:
            return "Invalid response from server"
        case .serverError(let statusCode, let message):
            return "Server error \(statusCode): \(message)"
        case .decodingError:
            return "Failed to decode response"
        }
    }
}

