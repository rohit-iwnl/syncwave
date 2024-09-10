//
//  PressableButtonShadows.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/9/24.
//

import SwiftUI

struct PressableButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let pressedColor: Color
    let isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: 100)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? pressedColor : (configuration.isPressed ? pressedColor : backgroundColor))
                        .shadow(color: .black.opacity(0.2), radius: configuration.isPressed || isSelected ? 2 : 5, x: 0, y: configuration.isPressed || isSelected ? 1 : 3)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.black : Color.gray.opacity(0.2))
                }
            )
            .scaleEffect(configuration.isPressed || isSelected ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
