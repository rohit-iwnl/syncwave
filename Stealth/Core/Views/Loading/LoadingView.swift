//
//  LoadingView.swift
//  Stealth
//
//  Created by Rohit Manivel on 10/3/24.
//

import SwiftUI

struct LoadingView: View {
    @State private var isGlowing = false
    
    var body: some View {
        VStack {
            Spacer()
            Image("Logo/white") // Ensure "appicon" matches your asset name
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaledToFit()
                .frame(width: 150, height: 150)
                .glow(color: Color(hex: "#C3FF19"), radius: isGlowing ? 10 : 0)
                .animation(
                    Animation.easeInOut(duration: 1)
                        .repeatForever(autoreverses: true),
                    value: isGlowing
                )
            Spacer()
            
            Text("Loading")
                .soraStyle()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(TextColors.primaryBlack.color)
        .onAppear {
            isGlowing.toggle() // Start the glowing animation
        }
    }
}

struct GlowEffect: ViewModifier {
    var color: Color
    var radius: CGFloat = 20
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.5), radius: radius, x: 0, y: 0)
            .shadow(color: color.opacity(0.5), radius: radius, x: 0, y: 0)
            .shadow(color: color.opacity(0.5), radius: radius, x: 0, y: 0)
    }
}

// Extension to apply the glow effect easily
extension View {
    func glow(color : Color, radius: CGFloat = 20) -> some View {
        self.modifier(GlowEffect(color: color, radius: radius))
    }
}

#Preview {
    LoadingView()
}
