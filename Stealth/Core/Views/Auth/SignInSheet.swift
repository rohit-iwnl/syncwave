//
//  SignInSheet.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/25/24.
//

import SwiftUI

struct SignInSheet: View {
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var emailID : String = ""
    @FocusState private var isEmailFocused : Bool
    
    @StateObject var viewModel = SignInViewModel()
    
    @State private var isSignUpModalOpen : Bool = false
    @State private var isPasswordFieldVisible : Bool = false
    @State private var password : String = ""
    @State private var isLoading : Bool = false
    
    
    @Binding var appUser : AppUser?
    
    let appleSignInUtils = AppleSignInUtils()
    
    var body: some View {
        VStack{
            VStack{
                Text("Login /\nSignup")
                    .font(.largeTitle)
                    .lineLimit(2)
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    .fontWeight(.semibold)
                    .alignment(.leading)
                
                Spacer(minLength: 20)
                
                if !isPasswordFieldVisible {
                    TextInputField(
                        text: $emailID,
                        prompt: "Enter your email ID",
                        keyboardType: .emailAddress,
                        textContentType: .emailAddress,
                        autoCapitalization: .never,
                        autoCorrection: false
                    )
                    .transition(.asymmetric(insertion: .slide, removal: .opacity))
                } else {
                    TextInputField(
                        text: $password,
                        prompt: "Enter your password",
                        keyboardType: .default,
                        textContentType: .password,
                        autoCapitalization: .never,
                        autoCorrection: false
                    )
                    .transition(.asymmetric(insertion: .slide, removal: .opacity))
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isPasswordFieldVisible = false
                            password = "" // Clear the password field
                        }
                    }) {
                        Text("Wrong email?")
                            .font(.caption)
                            .foregroundColor(.white)
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                            .padding(.top,10)
                            .transition(.slide)
                            .alignment(.leading)
                    }
                    
                }
                
                Spacer(minLength: 20)
                
                Button(action: {
                    isLoading = true
                    Task {
                        do {
                            if !isPasswordFieldVisible {
                                let response: Bool = try await AuthManager.shared.checkIfUserExist(email: emailID)
                                if response == true {
                                    withAnimation {
                                        isPasswordFieldVisible = true
                                    }
                                } else {
                                    await MainActor.run {
                                        isSignUpModalOpen = true
                                    }
                                    
                                }
                            } else {
                                // Handle sign in with email and password here
                            }
                        } catch {
                            print("Error caught")
                        }
                        isLoading = false
                    }
                }) {
                    HStack {
                        Spacer()
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        } else {
                            Text("Continue")
                                .font(.subheadline) // Customize the font and size
                                .lineLimit(2)
                                .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                            Image(systemName: "arrow.right") // Use SF Symbol for the arrow icon
                                .font(.system(size: 18, weight: .bold))
                        }
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
                .disabled(isLoading) // Disable the button while loading
                
                Spacer(minLength: 20)
                
                HStack{
                    Rectangle()
                        .frame(height: 1)
                    Text("Or continue with")
                        .font(.callout)
                        .lineLimit(1)
                        .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    
                    Rectangle()
                        .frame(height: 1)
                    
                }
                .foregroundStyle(.gray)
                
                Spacer(minLength: 20)
                
                HStack{
                    CircleAuthButton(image: "AuthIcons/apple") {
                        Task {
                            do {
                                let _appUser = try await viewModel.signInWithApple()
                                self.appUser = _appUser
                            } catch {
                                print("Error Signing in with apple provider")
                            }
                        }
                    }
                    CircleAuthButton(image: "AuthIcons/google") {
                        
                    }
                }
                
                VStack{
                    
                }
                .alignment(.top)
            }
            .alignment(.top)
            .padding(.vertical,20)
            .padding(.horizontal)
            
            
        }
        .alignment(.top)
        .foregroundStyle(TextColors.primaryWhite.color)
        .background(TextColors.primaryBlack.color)
        .sheet(isPresented: $isSignUpModalOpen) {
            SignupSheet(emailID: emailID)
                .presentationDragIndicator(.visible)
                .ignoresSafeArea()
        }
        
    }
}

#Preview {
    SignInSheet(appUser: .constant(nil))
        .ignoresSafeArea(edges: [.bottom])
}
