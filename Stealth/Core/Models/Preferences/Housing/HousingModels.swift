//
//  HousingModels.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/13/24.
//

import Foundation

struct RentRangeSlider {
    var min : Double
    var max : Double
}

struct propertySizeSlider {
    var min : Double
    var max : Double
}

struct BedroomsOptions {
    static let options : [String] = ["1 BR", "2 BR", "3 BR", "4+ BR", "Any"]
}

struct BathroomOptions {
    static let options : [String] = ["1", "2", "3", "4+", "Any"]
}

struct RoomateOptions {
    static let options : [String] = ["1", "2", "3", "4+", "Any"]
}

struct LeasingOptions {
    static let roommateOptions : [String] = ["1", "2", "3", "4", "5", "Custom"]
    static let bedroomOptions : [String] = ["1", "2", "3", "4+"]
    static let bathroomOptions : [String] = ["1", "2", "3", "4+"]
    static let furnishingOptions : [String] = ["Fully Furnished", "Semi Furnished", "Unfurnished"]
    static let planOptions : [String] = ["Lease", "Sublease", "Temporary Stay"]
}

struct FurnishingOptions {
    static let options : [String] = ["Fully Furnished", "Semi Furnished", "Any"]
}

struct AmenitiesOptions {
    static let options: [String] = [
        "Bicycle Parking",
        "Swimming Pool",
        "Covered Parking",
        "Open Parking",
        "Smoking Area",
        "In-House Laundry",
        "Workspace",
        "Recreational Area",
        "Accessible",
        "Gym"
    ]
}

