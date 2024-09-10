//
//  SignupSheet.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/29/24.
//

import SwiftUI



struct SignupSheet: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = SignInViewModel()
    
    @EnvironmentObject private var appUserStateManager: AppUserManger
    @State private var isVisible = true
    
    
    @State var emailID: String
    @State private var phoneNumber: String = ""
    @State private var preferredName: String = ""
    @State private var password: String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    
    var body: some View {
        if isVisible {
            NavigationStack {
                
                VStack {
                    Text("Finish signing up")
                        .font(.largeTitle)
                        .foregroundStyle(TextColors.primaryWhite.color)
                        .fontWeight(.semibold)
                        .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                        .alignment(.leading)
                        .padding(.vertical)
                    
                    CustomTextField(text: $preferredName, placeholder: "Preferred Name")
                        .padding(.bottom)
                    
                    CustomTextField(text: $phoneNumber, placeholder: "Phone number")
                        .padding(.bottom)
                    
                    CustomTextField(text: $emailID, placeholder: "Email ID")
                        .padding(.bottom)
                    
                    CustomTextField(text: $password, placeholder: "Password")
                        .padding(.bottom)
                    
                    Spacer()
                    
                    Button(action: {
                        // Perform the sign-up action
                        registerNewUser(emailId: emailID, password: password)
                    }) {
                        Text("Continue")
                            .font(.subheadline)
                            .foregroundColor(isFormValid ? TextColors.primaryBlack.color : .gray)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isFormValid ? TextColors.primaryWhite.color : .gray.opacity(0.5))
                            .cornerRadius(10)
                            .animation(.easeIn, value: isFormValid)
                    }
                    .disabled(!isFormValid)
                    .padding(.vertical)
                }
                .transition(.asymmetric(insertion: .opacity, removal: .opacity.combined(with: .move(edge: .trailing))))
                
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Sign Up Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .animation(.easeInOut(duration: 0.3), value: isVisible)
                
                .padding()
                .background(TextColors.primaryBlack.color)
                .alignment(.leading)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isVisible = false
                            }
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .foregroundColor(.white)
                        }
                    }
                    
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        return !preferredName.isEmpty && !phoneNumber.isEmpty && !emailID.isEmpty && !password.isEmpty && emailID.isValidEmail() && phoneNumber.isValidPhoneNumber() && password.count >= 8
    }
    
    private func registerNewUser(emailId: String, password: String) {
        if (isFormValid) {
            Task {
                do {
                    let _appUser = try await viewModel.registerNewUserWithEmail(email: emailID, password: password)
                    
                    let updateSuccess = try await AuthManager.shared.updateUserFullName(userID: _appUser.uid, fullName: preferredName)
                    
                    if updateSuccess {
                        await MainActor.run {
                            self.appUserStateManager.appUser = _appUser
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isVisible = false
                            }
                           
                        }
                    } else {
                        throw NSError(domain: "SignUp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to update user's full name"])
                    }
                } catch {
                    await MainActor.run {
                        alertMessage = "Error during sign up: \(error.localizedDescription)"
                        showAlert = true
                    }
                }
            }
        } else {
            alertMessage = "Please fill all fields correctly."
            showAlert = true
        }
    }
    
    private func dismissView() {
        withAnimation(.easeInOut(duration: 0.5)) {
            isVisible = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    
    
    
}

#Preview {
    SignupSheet(emailID: "")
}
