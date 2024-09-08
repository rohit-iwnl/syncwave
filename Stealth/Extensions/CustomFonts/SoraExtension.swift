//
//  Sora.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/8/24.
//

import Foundation
import SwiftUI

extension Font {
    static func sora(_ textStyle: Font.TextStyle, weight: Font.Weight = .regular) -> Font {
        let size = UIFont.preferredFont(forTextStyle: textStyle.uiKitTextStyle).pointSize
        return Font.custom("Sora", size: size, relativeTo: textStyle).weight(weight)
    }
}

extension Font.TextStyle {
    var uiKitTextStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle: return .largeTitle
        case .title: return .title1
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .subheadline: return .subheadline
        case .body: return .body
        case .callout: return .callout
        case .footnote: return .footnote
        case .caption: return .caption1
        case .caption2: return .caption2
        @unknown default: return .body
        }
    }
}

