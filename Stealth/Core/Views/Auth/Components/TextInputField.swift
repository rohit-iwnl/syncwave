//
//  TextInputField.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/29/24.
//

import SwiftUI

struct TextInputField: View {
    
    @Binding var text: String
    var prompt: String
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    var autoCapitalization: TextInputAutocapitalization
    var autoCorrection : Bool
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        TextField(text: $text, prompt: Text(prompt).foregroundStyle(.gray)) {}
            .textInputAutocapitalization(autoCapitalization)
            .autocorrectionDisabled(!autoCorrection)
            .textContentType(textContentType)
            .keyboardType(keyboardType)
            .focused($isFocused)
            .foregroundStyle(.white)
            .padding(.vertical, 10)
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
    TextInputField(text: .constant(""), prompt: "Enter your email ID", keyboardType: .URL, textContentType: .emailAddress, autoCapitalization: .never, autoCorrection: false)
}
