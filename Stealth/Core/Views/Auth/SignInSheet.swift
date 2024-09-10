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
    
    @State private var isEmailValid: Bool = false
    @State private var isPasswordValid: Bool = false
    
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    
    
    var isInputValid: Bool {
        if isPasswordFieldVisible {
            return isEmailValid && isPasswordValid
        } else {
            return isEmailValid
        }
    }
    
    
    @EnvironmentObject private var appUserStateManager: AppUserManger
    
    let appleSignInUtils = AppleSignInUtils()
    
    var body: some View {
        VStack{
            VStack{
                Text("Login")
                    .font(.sora(.largeTitle))
                    .lineLimit(2)
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    .fontWeight(.semibold)
                    .alignment(.leading)
                
                
                
                if !isPasswordFieldVisible {
                    CustomTextField(text: $emailID, placeholder: "Enter your email")
                        .transition(.asymmetric(insertion: .slide, removal: .opacity))
                        .onChange(of: emailID) { _, newValue in
                            isEmailValid = newValue.isValidEmail()
                        }
                } else {
                    VStack(alignment: .trailing, spacing: 10) {
                        CustomSecureField(text: $password, placeholder: "Enter your password")
                            .transition(.asymmetric(insertion: .slide, removal: .opacity))
                            .onChange(of: password) { _, newValue in
                                isPasswordValid = newValue.isValidPassword()
                            }
                        
                        HStack {
                            
                            Spacer()
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    isPasswordFieldVisible = false
                                    password = "" // Clear the password field
                                }
                            }) {
                                Text("Wrong email?")
                                    .font(.sora(.caption))
                                    .underline()
                                    .foregroundColor(.white)
                                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                            }
                            .transition(.slide)
                        }
                        .padding(.top)
                    }
                }
                
                
                
                
                Button(action: {
                    isLoading = true
                    Task {
                        do {
                            if !isPasswordFieldVisible {
                                let response: String = try await AuthManager.shared.checkIfUserExist(email: emailID)
                                if response == CheckEmailUserExists.ApiReponse.Found {
                                    withAnimation {
                                        isPasswordFieldVisible = true
                                    }
                                } else if response == CheckEmailUserExists.ApiReponse.Not_Found {
                                    await MainActor.run {
                                        isSignUpModalOpen = true
                                    }
                                }
                            } else {
                                // Handle sign in with email and password here
                                Task {
                                    do {
                                        let _appUser = try await viewModel.signInWithEmail(email: emailID, password: password)
                                        await MainActor.run {
                                            self.appUserStateManager.appUser = _appUser
                                        }
                                        print("DEBUG : \(_appUser.uid)")
                                        print("DEBUG : \(String(describing: _appUser.email))")
                                    } catch {
                                        print("Error Signing in with email provider: \(error)")
                                    }
                                }
                                
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
                                .font(.sora(.title3))
                                .lineLimit(2)
                                .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                            Image(systemName: "arrow.right")
                                .font(.system(size: 18, weight: .bold))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 50)
                    .background(
                        isInputValid && !isLoading ?
                        Color.white :
                            Color.white.opacity(0.3) // Reduced opacity for disabled state
                    )
                    .foregroundColor(
                        isInputValid && !isLoading ?
                        Color.black :
                            Color.gray // Gray text for disabled state
                    )
                    .cornerRadius(16)
                    .shadow(
                        color: isInputValid && !isLoading ?
                        Color.black.opacity(0.2) :
                            Color.clear, // No shadow for disabled state
                        radius: 5, x: 0, y: 2
                    )
                    .animation(.easeInOut(duration: 0.25), value: isInputValid)
                    .animation(.easeInOut(duration: 0.25), value: isLoading)
                }
                .padding(.vertical)
                .disabled(!isInputValid || isLoading)
                
                
                if (isPasswordFieldVisible){
                    NavigationLink(destination: ForgotPasswordView(email: emailID)) {
                        
                        Text("Forgot password?")
                            .font(.sora(.subheadline))
                            .underline()
                            .foregroundColor(.white)
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                            .transition(.slide)
                    }
                    .padding(.vertical)
                    
                }
                
                if (!isPasswordFieldVisible) {
                    HStack{
                        Rectangle()
                            .frame(height: 1)
                        Text("Or continue with")
                            .font(.sora(.subheadline))
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                        
                        Rectangle()
                            .frame(height: 1)
                        
                    }
                    .foregroundStyle(.gray)
                    
                    
                    
                    
                    HStack{
                        CircleAuthButton(image: "AuthIcons/apple") {
                            Task {
                                do {
                                    let _appUser = try await viewModel.signInWithApple()
                                    self.appUserStateManager.appUser = _appUser
                                } catch {
                                    print("Error Signing in with apple provider")
                                }
                            }
                        }
                        CircleAuthButton(image: "AuthIcons/google") {
                            Task {
                                do {
                                    let _appUser = try await viewModel.signInWithGoogle()
                                    self.appUserStateManager.appUser = _appUser
                                } catch {
                                    print("Error Signing in with google provider")
                                }
                            }
                        }
                    }
                    .animation(.easeIn, value: isPasswordFieldVisible)
                    .padding(.vertical)
                    Spacer(minLength: 20)
                }
                
                if (!isPasswordFieldVisible){
                    VStack {
                        HStack {
                            Text("Don't have an account?")
                                .foregroundColor(.gray)
                            NavigationLink(destination: SignupSheet(emailID: emailID)) {
                                Text("Sign up here")
                                    .foregroundColor(TextColors.primaryWhite.color)
                                    .underline()
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                            }
                            .toolbarColorScheme(.dark, for: .navigationBar)
                        }
                        .transition(.slide)
                        .animation(.easeIn, value: isPasswordFieldVisible)
                        .font(.sora(.subheadline))
                        .padding(.top, 20)
                    }
                    .padding(.bottom,60)
                    .alignment(.bottom)
                }
            }
            .alignment(.top)
            
            
            
        }
        .alignment(.top)
        .foregroundStyle(TextColors.primaryWhite.color)
        .background(TextColors.primaryBlack.color)
        .sheet(isPresented: $isSignUpModalOpen) {
            SignupSheet(emailID: emailID)
                .presentationDragIndicator(.visible)
                .ignoresSafeArea()
                .environmentObject(viewModel)
        }
        .overlay(
            ToastView(message: toastMessage, isShowing: $showToast, color: .white)
        )
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var previewUser: AppUser? = AppUser(uid: "1234", email: "rohitmanivel9@gmail.com")
        
        var body: some View {
            SignInView()
        }
    }
    
    return PreviewWrapper()
}

