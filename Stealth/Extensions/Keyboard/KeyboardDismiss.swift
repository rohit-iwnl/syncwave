//
//  KeyboardDismiss.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/30/24.
//

import SwiftUI

extension View {
    func addDismissButton(text : String = "Done") -> some View {
        
        return self.toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(text) {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .foregroundStyle(.black)
            }
        }
    }
}
