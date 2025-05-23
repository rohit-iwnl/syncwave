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
                .smoothScale(iconScale)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.5)) {
                backgroundColor = TextColors.primaryWhite.color
                logoColor = .black
                isAnimating = true
            }
            
            // Scale the logo after the color transition
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.spring(response: 2, dampingFraction: 0.8, blendDuration: 1)) {
                    iconScale = 25
                }

            }
        }
    }
}

struct ScaleEffect: AnimatableModifier {
    var scale: CGFloat
    
    var animatableData: CGFloat {
        get { scale }
        set { scale = newValue }
    }
    
    func body(content: Content) -> some View {
        content.scaleEffect(scale)
    }
}

extension View {
    func smoothScale(_ scale: CGFloat) -> some View {
        self.modifier(ScaleEffect(scale: scale))
    }
}




#Preview {
    LaunchView()
}
