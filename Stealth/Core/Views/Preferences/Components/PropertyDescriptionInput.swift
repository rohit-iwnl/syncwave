//
//  SmartWrite.swift
//  Stealth
//
//  Created by Rohit Manivel on 11/2/24.
//

import SwiftUI

struct PropertyDescriptionInput: View {
    @Binding var description: String
    let maxCharacters: Int = 350
    @State private var showSmartWrite: Bool = false
    @State private var hapticTimer: Timer?
    @State private var isGlowing = false
    @State private var colorIndex = 0
    @State private var hapticCount = 0
    
    private let glowColors: [Color] = [.red, .green, .blue, .purple, .orange]
    @State private var angle: Double = 0
    @State private var glowOpacity: Double = 0
        
    private let gradientColors: [Color] = [.blue, .purple, .red, .orange, .yellow, .green , .teal, .cyan, .mint]
    var currentGlowColor: Color {
        glowColors[colorIndex % glowColors.count]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Write about your property here*")
                .font(.sora(.body))
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $description)
                    .font(.sora(.body))
                    .frame(height: 150)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3))
                    )
                    .overlay(
                        ZStack {
                            ForEach(0..<2) { index in
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        AngularGradient(
                                            colors: gradientColors,
                                            center: .center,
                                            angle: .degrees(angle + Double(index * 120))
                                        ),
                                        lineWidth: 2
                                    )
                                    .shadow(color: Color.blue.opacity(0.5), radius: 50)
                                    .shadow(color: Color.purple.opacity(0.5), radius: 60)
                                    .shadow(color: Color.red.opacity(0.5), radius: 80)
                                    .blur(radius: 3)
                            }
                        }
                            .opacity(glowOpacity) // Use glowOpacity instead of isGlowing
                    )
                    .onChange(of: isGlowing) { newValue in
                        withAnimation(.easeInOut(duration: 1.0)) { // Smooth fade transition
                            glowOpacity = newValue ? 0.8 : 0
                        }
                        
                        if newValue {
                            withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                                angle = 360
                            }
                        } else {
                            // Smoothly reset angle when stopping
                            withAnimation(.easeOut(duration: 1.0)) {
                                angle = 0
                            }
                        }
                    }
                
                
                if description.isEmpty {
                    Text("Describe briefly about your property.")
                        .font(.sora(.body))
                        .foregroundColor(.gray.opacity(0.5))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 18)
                }
                
                
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack{
                    Text("5 personalizations available")
                        .font(.sora(.caption))
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                    Spacer()
                    Text("\(maxCharacters - description.count) Characters left")
                        .font(.sora(.caption))
                        .foregroundColor(.gray)
                        .padding(8)
                        
                }
                Text("Can't think of writing a beautiful description? Let AI do it.")
                    .font(.sora(.callout, weight: .regular))
                    .foregroundColor(.gray)
                
                
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        startSmartWrite()
                    }) {
                        HStack(spacing: 8) {
                            Text("Smart write")
                                .font(.sora(.body))
                            Image(systemName: "sparkles")
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(TextColors.primaryBlack.color)
                        )
                        .foregroundColor(.white)
                    }
                    
                    
                }
            }
        }
        .onDisappear {
            stopHaptics()
        }
    }
    
    
    private func startSmartWrite() {
        showSmartWrite.toggle()
        withAnimation(.easeIn(duration: 1.0)) {
            isGlowing = true
        }
        hapticCount = 0
        angle = 0
        
        // Create impact generator for more subtle vibrations
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.prepare()
        
        // Create continuous wave-like haptic feedback
        hapticTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            // Calculate varying intensity using sine wave
            let intensity = 0.5 * (1 + sin(Double(hapticCount) * 0.3))
            generator.impactOccurred(intensity: intensity)
            hapticCount += 1
            
            // Run for about 6 seconds (60 pulses)
            if hapticCount >= 60 {
                hapticTimer?.invalidate()
                hapticTimer = nil
            }
        }
        
        // Stop effects after AI completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            stopEffects()
        }
    }

    
    private func stopEffects() {
        withAnimation(.easeOut(duration: 1.0)) {
            isGlowing = false
        }
        hapticTimer?.invalidate()
        hapticTimer = nil
    }
    
    private func stopHaptics() {
        hapticTimer?.invalidate()
        hapticTimer = nil
    }
}


#Preview {
    PropertyDescriptionInput(description: .constant(""))
        .padding()
}
