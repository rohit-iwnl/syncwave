//
//  NativeToast.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/7/25.
//

import SwiftUI


/// A simple toast view that displays a message.
struct NativeToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.sora(.subheadline, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.black.opacity(0.8))
            .cornerRadius(8)
            .shadow(radius: 4)
    }
}

/// A view modifier to overlay a toast message.
struct NativeToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    let message: String
    let duration: TimeInterval

    func body(content: Content) -> some View {
        ZStack {
            content
            if isShowing {
                VStack {
                    Spacer()
                    NativeToastView(message: message)
                        .transition(.opacity)
                        .padding(.bottom, 50)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                withAnimation {
                                    isShowing = false
                                }
                            }
                        }
                }
                .animation(.easeInOut, value: isShowing)
            }
        }
    }
}

extension View {
    /// A convenience method to show a native toast with auto-dismiss.
    func nativeToast(isShowing: Binding<Bool>, message: String, duration: TimeInterval = 2) -> some View {
        self.modifier(NativeToastModifier(isShowing: isShowing, message: message, duration: duration))
    }
}


#Preview {
    NativeToastView(message: "Example")
}
