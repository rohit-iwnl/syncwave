//
//  LaunchView.swift
//  Stealth
//
//  Created by Rohit Manivel on 11/30/24.
//

import SwiftUI

struct LaunchView: View {
    @State private var backgroundColor = Color.black
    @State private var logoColor = Color(hex: "#C3FF19")
    @State private var iconScale: CGFloat = 0.2
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            AppLogo()
                .fill(logoColor)
                .aspectRatio(contentMode: .fit)
                .scaleEffect(iconScale)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.5)) {
                backgroundColor = Color(hex: "#C3FF19")
                logoColor = .black
                isAnimating = true
            }
            
            // Scale the logo after the color transition
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 2)) {
                    iconScale = 20
                }
            }
        }
    }
}



#Preview {
    LaunchView()
}
