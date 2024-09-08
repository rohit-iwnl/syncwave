//
//  ToastView.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/5/24.
//
import SwiftUI

struct ToastView: View {
    let message: String
    @Binding var isShowing: Bool
    let color : Color
    
    var body: some View {
        VStack {
            Spacer()
            if isShowing {
                Text(message)
                    .padding()
                    .background(color.opacity(0.75))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                isShowing = false
                            }
                        }
                    }
            }
        }
        .animation(.easeInOut, value: isShowing)
        .padding(.bottom, 20)
    }
}

#Preview {
    ToastView(message: "This is a example toast", isShowing: .constant(true), color: .black)
}
