//
//  LeasingRequestModel.swift
//  Stealth
//
//  Created by Rohit Manivel on 11/3/24.
//

import Foundation


struct LeasingPreferences: Codable {
    let property: PropertyDetails
    let coordinates: Coordinates
}

struct PropertyDetails: Codable {
    let description: String
    let location: String
    let monthlyBaseRent: Int
    let perPersonRent: Int
    let squareFootage: Int
    let type: String
    let bedrooms: String
    let bathrooms: String
    let preferredRoommates: String
    let furnishing: String
    let amenities: [String]
    
    enum CodingKeys: String, CodingKey {
        case description
        case location
        case monthlyBaseRent = "monthly_base_rent"
        case perPersonRent = "per_person_rent"
        case squareFootage = "square_footage"
        case type
        case bedrooms
        case bathrooms
        case preferredRoommates = "preferred_roommates"
        case furnishing
        case amenities
    }
}

struct PropertyDetailsToGenerateDescription: Codable {
    
    let location: String
    let monthlyBaseRent: Int
    let perPersonRent: Int
    let squareFootage: Int
    let type: String
    let bedrooms: String
    let bathrooms: String
    let preferredRoommates: String
    let furnishing: String
    let amenities: [String]
    
    enum CodingKeys: String, CodingKey {
        
        case location
        case monthlyBaseRent = "monthly_base_rent"
        case perPersonRent = "per_person_rent"
        case squareFootage = "square_footage"
        case type
        case bedrooms
        case bathrooms
        case preferredRoommates = "preferred_roommates"
        case furnishing
        case amenities
    }
}

struct Coordinates: Codable {
    let latitude: Double
    let longitude: Double
}
