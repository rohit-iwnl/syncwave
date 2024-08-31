//
//  ForgotPasswordView.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/30/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    let email: String
    
    var body: some View {
        VStack {
            Text("Forgot Password")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("We'll send a password reset link to \(email)")
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Send Reset Link") {
                // Implement password reset logic here
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ForgotPasswordView(email: "rohitmanivel9@gmail.com")
}
