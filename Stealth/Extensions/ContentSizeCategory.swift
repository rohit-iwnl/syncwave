//
//  ContentSizeCategory.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/25/24.
//

import SwiftUI

extension DynamicTypeSize {
    var customMinScaleFactor : CGFloat {
        switch self {
        case .xSmall, .small, .medium:
            return 1.0
        case .large, .xLarge, .xxLarge:
            return 0.8
        case .xxxLarge, .accessibility1, .accessibility2:
            return 0.2
        case .accessibility3, .accessibility4, .accessibility5 :
            return 0.05
        default:
            return 1.0
        }
    }
}
