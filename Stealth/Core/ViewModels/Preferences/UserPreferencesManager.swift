//
//  UserPreferencesManager.swift
//  Stealth
//
//  Created by Rohit Manivel on 10/2/24.
//

import Foundation

struct UserPreferencesManager {
    private static let preferencesKey = "UserPreferences"
    
    static func storePreferences(_ preferences: [String: Bool]) {
        UserDefaults.standard.set(preferences, forKey: preferencesKey)
    }
    static func getPreferences() -> [String: Bool] {
        return UserDefaults.standard.dictionary(forKey: preferencesKey) as? [String: Bool] ?? [:]
    }
    
    static func clearPreferences() {
        UserDefaults.standard.removeObject(forKey: preferencesKey)
    }
}
