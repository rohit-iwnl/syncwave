//
//  ApiConstants.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/11/24.
//

import Foundation

struct apiAuthDict{
    let value : String
    let key : String
}

struct ApiConstants{
    static let apiAuthToken : apiAuthDict = apiAuthDict(value: "15010cc4a33675e26b96a6ebd60d35ee", key: "Auth-Token")
    
}
