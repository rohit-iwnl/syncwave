//
//  EmailValidation.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/27/24.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
        
    }
}
