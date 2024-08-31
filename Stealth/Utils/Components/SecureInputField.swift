//
//  SecureInputField.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/29/24.
//

import SwiftUI

struct SecureTextInputField: View {
    
    @Binding var text: String
    var prompt: String
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    var autoCapitalization: TextInputAutocapitalization
    var autoCorrection : Bool
    
    @State private var isSecure: Bool = true
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            if isSecure {
                SecureField(text: $text, prompt: Text(prompt), label: {
                    Text(prompt)
                })
                    .textInputAutocapitalization(autoCapitalization)
                    .autocorrectionDisabled(!autoCorrection)
                    .textContentType(textContentType)
                    .keyboardType(keyboardType)
                    .focused($isFocused)
                    .foregroundStyle(.white)
                    .padding(.vertical, 10)
            } else {
                TextField(text: $text, prompt: Text(prompt).foregroundStyle(.gray)) {}
                    .textInputAutocapitalization(autoCapitalization)
                    .autocorrectionDisabled(!autoCorrection)
                    .textContentType(textContentType)
                    .keyboardType(keyboardType)
                    .focused($isFocused)
                    .foregroundStyle(.white)
                    .padding(.vertical, 10)
            }
            
            Button(action: {
                isSecure.toggle()
            }) {
                Text(isSecure ? "Show" : "Hide")
                    .foregroundStyle(.white)
            }
            .padding(.trailing, 10)
        }
        .background(Color.clear)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(isFocused ? .white : .gray)
                .transition(.opacity)
                .animation(.easeOut.speed(2), value: isFocused)
                .padding(.top, 35),
            alignment: .bottom
        )
    }
}

#Preview {
    SecureTextInputField(text: .constant(""), prompt: "Enter your password", keyboardType: .default, textContentType: .password, autoCapitalization: .never, autoCorrection: false)
        .background(.black)
}
