//
//  SignInSheet.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/25/24.
//

import SwiftUI

struct SignInSheet: View {
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var emailID : String = ""
    @FocusState private var isEmailFocused : Bool
    
    var body: some View {
        VStack{
            VStack{
                Text("Login /\nSignup")
                    .font(.largeTitle)
                    .lineLimit(2)
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    .fontWeight(.semibold)
                    .alignment(.leading)
            
                Spacer(minLength: 20)
                
                TextField(text: $emailID, prompt: Text("Enter your email ID").foregroundStyle(.gray)) {
                    
                }
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .focused($isEmailFocused)
                .autocorrectionDisabled()
                .foregroundStyle(.white)
                .padding(.vertical, 10)  // Adjust vertical padding to give some spacing
                .background(Color.clear)  // Ensure background is clear
                .overlay(
                    Rectangle()
                        .frame(height: 1)  // Border height
                        .foregroundColor(isEmailFocused ? .white : .gray)  // Border color
                        .transition(.opacity)
                        .animation(.easeOut.speed(2), value: isEmailFocused)
                        .padding(.top, 35),  // Position the border at the bottom
                    alignment: .bottom
                )
                
                Spacer(minLength: 20)
                
                Button(action: {
                    // Action to perform when the button is tapped
                }) {
                    HStack {
                        Spacer()
                        Text("Continue")
                            .font(.subheadline) // Customize the font and size
                            .lineLimit(2)
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                        Image(systemName: "arrow.right") // Use SF Symbol for the arrow icon
                            .font(.system(size: 18, weight: .bold))
                        Spacer()
                    }
                    .padding(.horizontal, 20) // Add horizontal padding
                    .frame(height: 50) // Set the height of the button
                    .background(Color.white) // Button background color
                    .foregroundColor(.black)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Optional: Add shadow for depth
                    .padding(.vertical)
                }
                Spacer(minLength: 20)
                
                HStack{
                    Rectangle()
                        .frame(height: 1)
                    Text("Or")
                    
                    Rectangle()
                        .frame(height: 1)
                    
                }
                .foregroundStyle(.gray)
                
                Spacer(minLength: 20)
                
                HStack{
                    CircleAuthButton(image: "AuthIcons/apple") {
                        
                    }
                    CircleAuthButton(image: "AuthIcons/google") {
                        
                    }
                }
                
                VStack{
                    
                }
                .alignment(.top)
            }
            .alignment(.top)
            .padding(.vertical,20)
            .padding(.horizontal)

            
        }
        .alignment(.top)
        .foregroundStyle(TextColors.primaryWhite.color)
        .background(TextColors.primaryBlack.color)
        
    }
}

#Preview {
    SignInSheet()
        .ignoresSafeArea(edges: [.bottom])
}
