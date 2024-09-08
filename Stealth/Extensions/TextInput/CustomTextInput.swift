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
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField(placeholder, text: $text)
                .focused($isFocused)
                .foregroundColor(.white)
                .tint(.white)
                .padding(.vertical, 8)
                .background(Color(hex: "#242424"))
                .animation(.easeInOut(duration: 0.2), value: isFocused)
            
            Rectangle()
                .fill(isFocused ? Color.white : Color.gray.opacity(0.5))
                .frame(height: 1)
                .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}
