//
//  OAuthSignInButton.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/27/24.
//

import SwiftUI

struct OAuthSignInButton: View {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    let imageName : String
    let provider : String
    let action : () -> Void
    
    
    var body: some View {
        
        
        Button(action: action) {
            HStack {
                Spacer()
                
                Image(imageName) // Use SF Symbol for the arrow icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.vertical)
                    .controlSize(ControlSize.large)
                Text("Continue with \(provider)")
                    .font(.sora(.subheadline)) // Customize the font and size
                    .lineLimit(1)
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                Spacer()
            }
            .padding(.horizontal, 20) // Add horizontal padding
            .frame(height: 50) // Set the height of the button
            .background(Color.white) // Button background color
            .foregroundColor(.black)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Optional: Add shadow for depth
            .padding(.vertical)
        }
    }
}

#Preview {
    OAuthSignInButton(imageName: "AuthIcons/apple", provider: "Apple") {
    }
}
