//
//  SignupSheet.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/29/24.
//

import SwiftUI

struct SignupSheet: View {
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    @State var emailID: String
    @State private var phoneNumber: String = ""
    @State private var fullName: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            Text("Finish signing up")
                .font(.largeTitle)
                .foregroundStyle(TextColors.primaryWhite.color)
                .fontWeight(.semibold)
                .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                .alignment(.leading)
                .padding(.vertical)
            
            TextInputField(text: $fullName, prompt: "Full Name", keyboardType: .default, textContentType: .name, autoCapitalization: .sentences, autoCorrection: false)
                .padding(.bottom)
            
            TextInputField(text: $phoneNumber, prompt: "Phone number", keyboardType: .phonePad, autoCapitalization: .never, autoCorrection: false)
                .padding(.bottom)
            
            TextInputField(text: $emailID, prompt: "Email ID", keyboardType: .emailAddress, autoCapitalization: .words, autoCorrection: false)
                .padding(.bottom)
            
            TextInputField(text: $password, prompt: "Password", keyboardType: .default, textContentType: .password, autoCapitalization: .never, autoCorrection: false)
                .padding(.bottom)
            
            Spacer()
            
            Button(action: {
                // Perform the sign-up action
            }) {
                Text("Continue")
                    .font(.subheadline)
                    .foregroundColor(isFormValid ? TextColors.primaryBlack.color : .gray) // Grey when disabled, white when enabled
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isFormValid ? TextColors.primaryWhite.color : .gray.opacity(0.5)) // Grey background when disabled, blue when enabled
                    .cornerRadius(10)
                    .animation(.easeIn, value: isFormValid)
            }
            .disabled(!isFormValid) // Disable button when form is invalid
            .padding(.vertical)
        }
        .padding()
        .background(TextColors.primaryBlack.color)
        .alignment(.leading)
    }
    
    // Computed property to check if the form is valid
    private var isFormValid: Bool {
        return !fullName.isEmpty && !phoneNumber.isEmpty && !emailID.isEmpty && !password.isEmpty && emailID.isValidEmail() && phoneNumber.isValidPhoneNumber() && password.count >= 8
    }
}


#Preview {
    SignupSheet(emailID: "")
}
