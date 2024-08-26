//
//  AppStorageConstants.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/25/24.
//

import Foundation

struct AppStorageKey{
    let key : String
}

struct AppStorageConstants{
    static let hasCompletedOnboarding : AppStorageKey = AppStorageKey(key: "hasCompletedOnboarding")
}
