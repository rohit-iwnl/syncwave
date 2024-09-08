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
    
    @EnvironmentObject private var appUserStateManager: AppUserManger
    @StateObject var viewModel = SignInViewModel()
    
    var body: some View {
        
        ZStack {
            Color(TextColors.primaryBlack.color)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Text("Get Started")
                        .font(.sora(.largeTitle))
                        .foregroundStyle(TextColors.primaryWhite.color)
                        .lineLimit(2)
                        .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                        .fontWeight(.semibold)
                        
                    Spacer()
                }
                
                
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
                        .font(.sora(.callout))
                        .lineLimit(1)
                        .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    
                    Rectangle()
                        .frame(height: 1)
                }
                .foregroundStyle(.gray)
                
                OAuthSignInButton(imageName: "AuthIcons/apple") {
                    // Handle Apple sign-in
                    Task {
                        do {
                            let _appUser = try await viewModel.signInWithApple()
                            self.appUserStateManager.appUser = _appUser
                        } catch {
                            print("DEBUG: Error signing in with apple from OPTIONS SHEET")
                        }
                    }
                }
                
                OAuthSignInButton(imageName: "AuthIcons/google") {
                    // Handle Google sign-in
                    Task {
                        do {
                            let _appUser = try await viewModel.signInWithGoogle()
                            self.appUserStateManager.appUser = _appUser
                        } catch {
                            print("DEBUG: Error signing in with google from OPTIONS SHEET")

                        }
                    }
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
