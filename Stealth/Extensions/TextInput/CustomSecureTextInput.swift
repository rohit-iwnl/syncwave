//
//  CustomSecureTextInput.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/30/24.
//

import SwiftUI

struct CustomSecureField: View {
    @Binding var text: String
    let placeholder: String
    @State private var isFocused: Bool = false
    @State private var isSecure: Bool = true
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 4) {
            HStack {
                if isSecure {
                    SecureField("", text: $text)
                        .placeholder(when: text.isEmpty) {
                            Text(placeholder)
                                .font(.sora(.body))
                                .foregroundColor(Color.gray.opacity(0.7))
                        }
                } else {
                    TextField("", text: $text)
                        .placeholder(when: text.isEmpty) {
                            Text(placeholder)
                                .font(.sora(.body))
                                .foregroundColor(Color.gray.opacity(0.7))
                        }
                }
                
                Button(action: {
                    isSecure.toggle()
                }) {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
            }
            .foregroundColor(.white)
            .tint(.white)
            .padding(.vertical, 8)
            .background(Color(hex: "#242424"))
            .onTapGesture {
                isFocused = true
            }
            .onSubmit {
                isFocused = false
            }
            
            Rectangle()
                .fill(isFocused ? Color.white : Color.gray.opacity(0.5))
                .frame(height: 1)
                .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}



#Preview {
    CustomSecureField(text: .constant(""), placeholder: "Enter your password")
}
