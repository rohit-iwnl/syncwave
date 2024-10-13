//
//  DefaultTextStyle.swift
//  Stealth
//
//  Created by Rohit Manivel on 10/13/24.
//

import SwiftUI

struct DefaultTextStyle : ViewModifier {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    var style : Font.TextStyle
    var weight: Font.Weight
    
    
    func body(content : Content) -> some View {
        content
            .font(.sora(style, weight: weight))
            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
    }
}

extension View {
    func soraStyle(style : Font.TextStyle = .body ,weight: Font.Weight = .regular) -> some View {
        self.modifier(DefaultTextStyle(style: style, weight: weight))
    }
}

