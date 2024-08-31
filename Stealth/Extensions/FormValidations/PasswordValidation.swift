//
//  PasswordValidation.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/30/24.
//

import Foundation

extension String {
    func isValidPassword() -> Bool {
        // You can customize this validation as per your requirements
        return self.count >= 7
    }
}
