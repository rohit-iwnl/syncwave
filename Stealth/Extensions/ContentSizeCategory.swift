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
            return 0.6
        default:
            return 0.4
        @unknown default:
            return 1.0
        }
    }
}
