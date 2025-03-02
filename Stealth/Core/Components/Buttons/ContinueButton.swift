//
//  ContinueButton.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/10/24.
//

import SwiftUI

struct ContinueButton: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    var isEnabled: Bool
    var isLoading: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Continue")
                        .font(.sora(.title3))
                        .lineLimit(2)
                        .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    Image(systemName: "arrow.right")
                        .font(.system(size: 18, weight: .bold))
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(height: 50)
            .background(
                isEnabled && !isLoading ?
                TextColors.primaryBlack.color :
                TextColors.primaryBlack.color.opacity(0.3)
            )
            .foregroundColor(
                isEnabled && !isLoading ?
                TextColors.primaryWhite.color :
                TextColors.primaryWhite.color.opacity(0.6)
            )
            .cornerRadius(16)
            .shadow(
                color: isEnabled && !isLoading ?
                Color.black.opacity(0.2) :
                Color.clear,
                radius: 5, x: 0, y: 2
            )
        }
        .disabled(!isEnabled || isLoading)
        .animation(.easeInOut(duration: 0.25), value: isEnabled)
        .animation(.easeInOut(duration: 0.25), value: isLoading)
    }
}



#Preview {
    ContinueButton(isEnabled: false, isLoading: false, action: {
        
    })
        .padding()
}
