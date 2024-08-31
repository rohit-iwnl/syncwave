//
//  OptionsSheet.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/30/24.
//

import SwiftUI

struct OptionsSheet: View {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    @Environment(\.dismiss) private var dismiss
    @Binding var navigateToSignIn: Bool
    @Binding var isModalOpen: Bool
    
    var body: some View {
        
        ZStack {
            Color(TextColors.primaryBlack.color)
                .ignoresSafeArea()
            VStack {
                Text("Get Started")
                    .font(.largeTitle)
                    .foregroundStyle(TextColors.primaryWhite.color)
                    .lineLimit(2)
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    .fontWeight(.semibold)
                    .alignment(.leading)
                
                
                OAuthSignInButton(imageName: "AuthIcons/email") {
                    isModalOpen = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        navigateToSignIn = true
                    }
                }
                
                
                HStack {
                    Rectangle()
                        .frame(height: 1)
                    Text("Or")
                        .font(.callout)
                        .lineLimit(1)
                        .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    
                    Rectangle()
                        .frame(height: 1)
                }
                .foregroundStyle(.gray)
                
                OAuthSignInButton(imageName: "AuthIcons/apple") {
                    // Handle Apple sign-in
                }
                
                OAuthSignInButton(imageName: "AuthIcons/google") {
                    // Handle Google sign-in
                }
            }
            .padding()
        }
        .navigationBarHidden(true) // Hide the navigation bar if not needed
        
    }
}

#Preview {
    OptionsSheet(navigateToSignIn: .constant(false), isModalOpen: .constant(true))
}
