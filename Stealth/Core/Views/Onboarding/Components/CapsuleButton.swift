//
//  CapsuleButton.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/25/24.
//

import SwiftUI

struct CapsuleButton: View {
    var title : String
    var action : () -> Void
    let color : Color
    
    var body : some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(TextColors.primaryBlack.color)
                .padding()
                .background(RoundedRectangle(cornerRadius: OnboardingConstants.buttonCornerRadius).fill(TextColors.primaryWhite.color))
        }
    }
}

#Preview {
    CapsuleButton(title: "Hello", action: {
        
    }, color: .black)
}
