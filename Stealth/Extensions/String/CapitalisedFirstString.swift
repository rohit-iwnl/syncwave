//
//  CapitalisedFirstString.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/2/25.
//

import Foundation

extension String {
    /// Capitalizes the first character of a string.
    func capitalizedFirst() -> String {
        guard let first = self.first else { return self }
        return first.uppercased() + self.dropFirst()
    }
}
