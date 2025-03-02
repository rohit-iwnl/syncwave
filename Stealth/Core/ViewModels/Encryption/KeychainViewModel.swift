//
//  KeychainViewModel.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/11/24.
//

import Foundation
import SwiftUI

class KeychainViewModel: ObservableObject {
    static let shared = KeychainViewModel()

    // Save a value using KeychainHelper
    func saveToKeychain(value: String, forKey key: String) {
        _ = KeychainHelper.shared.save(value, forKey: key) // Discard the result
    }
    
    // Retrieve a value using KeychainHelper
    func retrieveFromKeychain(forKey key: String) -> String? {
        return KeychainHelper.shared.retrieve(forKey: key)
    }
    
    // Delete a value using KeychainHelper
    func deleteFromKeychain(forKey key: String) {
        _ = KeychainHelper.shared.delete(forKey: key) // Discard the result
    }
}
