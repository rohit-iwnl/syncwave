//
//  CapsuleButton.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/25/24.
//

import SwiftUI

struct CapsuleButton: View {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var title : String
    var action : () -> Void
    let color : Color
    
    var body : some View {
        Button(action: action) {
            Text(title)
                .font(.sora(.callout))
                .fontWeight(.medium)
                .lineLimit(1)
                .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                .foregroundColor(TextColors.primaryBlack.color)
                .containerRelativeFrame(.horizontal, { length, _ in
                    return length/5
                })
                .padding(.vertical,10)
                .padding(.horizontal,2)
                .background(RoundedRectangle(cornerRadius: OnboardingConstants.buttonCornerRadius).fill(TextColors.primaryWhite.color))
        }
    }
}

#Preview {
    CapsuleButton(title: "Hello", action: {
        
    }, color: .black)
}
