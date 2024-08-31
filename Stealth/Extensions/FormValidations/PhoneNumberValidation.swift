//
//  PhoneNumberValidation.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/29/24.
//

import Foundation

extension String {
    func isValidPhoneNumber() -> Bool {
        let phoneRegEx = "^[0-9]{10}$" // Example for a 10-digit phone number
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: self)
    }
}
