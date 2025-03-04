//
//  NetworkError.swift
//  Stealth
//
//  Created by Rohit Manivel on 10/30/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case encodingError
    case decodingError
    case serverError(String)
}

