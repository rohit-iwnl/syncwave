//
//  CustomTextInput.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/30/24.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    @State private var isFocused: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField("", text: $text, onEditingChanged: { editing in
                DispatchQueue.main.async {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        self.isFocused = editing
                    }
                }
            })
            .placeholder(when: text.isEmpty) {
                Text(placeholder)
                    .foregroundColor(Color.gray.opacity(0.7))
            }
            .addDismissButton()
            .foregroundColor(.white)
            .tint(.white)
            .padding(.vertical, 8)
            .background(Color(hex: "#242424"))
            
            Rectangle()
                .fill(isFocused ? Color.white : Color.gray.opacity(0.5))
                .frame(height: 1)
                .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}



#Preview {
    CustomTextField(text: .constant("nil"), placeholder: "Enter your email")
}
