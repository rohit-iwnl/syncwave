//
//  KeyboardAvoid.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/7/25.
//

import SwiftUI
import Combine

// Publisher to get keyboard height
extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { notification -> CGFloat in
                let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
                return keyboardFrame.height
            }
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ -> CGFloat in 0 }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

// KeyboardAdaptive view modifier that adds extra bottom padding
struct KeyboardAdaptive: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    let additionalPadding: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight + additionalPadding)
            .onReceive(Publishers.keyboardHeight) { newHeight in
                withAnimation(.easeOut(duration: 0.25)) {
                    self.keyboardHeight = newHeight
                }
            }
    }
}

extension View {
    func keyboardAdaptive(additionalPadding: CGFloat = 20) -> some View {
        self.modifier(KeyboardAdaptive(additionalPadding: additionalPadding))
    }
}

