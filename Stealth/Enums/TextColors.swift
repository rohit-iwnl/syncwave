//
//  File.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/25/24.
//

import Foundation
import SwiftUI

enum TextColors {
    case primaryBlack, primaryWhite
    
    var color : Color {
        switch self {
        case .primaryBlack:
            return Color(hex: "#242424")
        case .primaryWhite:
            return Color(hex: "#F6F6F6")

        }
    }
}
