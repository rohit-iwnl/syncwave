//
//  CircleAuthButton.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/26/24.
//

import SwiftUI

struct AuthButton: View {
    let image: String
    let provider: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    Spacer()
                    
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.height * 0.5, height: geometry.size.height * 0.5)
                        .padding(.trailing, 8)
                    
                    Text("Continue with \(provider)")
                        .font(.sora(.headline, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .frame(height: 50) // Set a fixed height for the button
        .background(TextColors.primaryWhite.color)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    VStack {
        AuthButton(image: "AuthIcons/apple", provider: "Apple") {}
        AuthButton(image: "AuthIcons/google", provider: "Google") {}
    }
    .padding()
    .background(Color.gray.opacity(0.1))
    .previewLayout(.sizeThatFits)
}
