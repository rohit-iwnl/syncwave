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
    
    @State var emailID: String
    @State private var phoneNumber: String = ""
    @State private var fullName: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Finish signing up")
                    .font(.largeTitle)
                    .foregroundStyle(TextColors.primaryWhite.color)
                    .fontWeight(.semibold)
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    .alignment(.leading)
                    .padding(.vertical)
                
                CustomTextField(text: $fullName, placeholder: "Full Name")
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
            .padding()
            .background(TextColors.primaryBlack.color)
            .alignment(.leading)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
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
    
    private var isFormValid: Bool {
        return !fullName.isEmpty && !phoneNumber.isEmpty && !emailID.isEmpty && !password.isEmpty && emailID.isValidEmail() && phoneNumber.isValidPhoneNumber() && password.count >= 8
    }
}

#Preview {
    SignupSheet(emailID: "")
}
