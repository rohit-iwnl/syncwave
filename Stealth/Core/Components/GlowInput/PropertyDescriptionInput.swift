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
    let isEnabled: Bool
    @Binding var isLoading: Bool
    
    @FocusState.Binding var focusedField: Field?
    let field: Field
    
    @State private var animationDuration: TimeInterval = 5.0 // Set minimum animation duration
    @State private var pendingDescription: String?
    
    let onGenerateDescription: () async -> Void
    
    @State private var shouldShimmer = false
    @State private var textOpacity = 1.0
    
    private let glowColors: [Color] = [.red, .green, .blue, .purple, .orange]
    @State private var angle: Double = 0
    @State private var glowOpacity: Double = 0
    
    private let gradientColors: [Color] = [.white, .pink, .purple, .blue, .teal, .red, .orange, .yellow, .green]
    
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
                        // Shimmer effect overlay
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.0),
                                        Color.white.opacity(0.7),
                                        Color.white.opacity(0.0)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .opacity(shouldShimmer ? 0.5 : 0)
                            .offset(x: shouldShimmer ? 150 : -150) // Reduced movement distance
                            .animation(.easeInOut(duration: 0.8), value: shouldShimmer)
                    )
                    .opacity(textOpacity)
                    .focused($focusedField, equals: field)
                
                    .onChange(of: description) {
                        if !description.isEmpty {
                            // Animate text fade-in and shimmer
                            withAnimation(.easeOut(duration: 0.3)) {
                                textOpacity = 0
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    textOpacity = 1
                                    shouldShimmer = true
                                }
                                
                                // Reset shimmer after animation
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    shouldShimmer = false
                                }
                            }
                        }
                    }

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
                            .opacity(glowOpacity)
                    )
                    .disabled(!isEnabled || isLoading) // Disable during loading
                    .onChange(of: description) { _ in
                        // Stop animations when new description arrives
                        if !description.isEmpty {
                            stopEffects()
                        }
                    }
                    .onChange(of: isGlowing) { newValue in
                        withAnimation(.easeInOut(duration: 1.0)) {
                            glowOpacity = newValue ? 0.8 : 0
                        }
                        
                        if newValue {
                            withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                                angle = 360
                            }
                        } else {
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
                    
                    Spacer()
                    Text("\(maxCharacters - description.count) Characters left")
                        .font(.sora(.caption))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 4)
                
                HStack {
                    Text("Can't think of writing a beautiful description? Let AI do it.")
                        .font(.sora(.footnote, weight: .regular))
                        .foregroundColor(.gray)
                        .padding(.horizontal,4)
                    Spacer()
                    Button(action: {
                        if isEnabled && !isLoading {
                            Task {
                                startSmartWrite()
                                await onGenerateDescription()
                            }
                        }
                    }) {
                        HStack(spacing: 8) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Text("Smart write")
                                    .font(.sora(.body))
                                Image(systemName: "sparkles")
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isEnabled && !isLoading ? TextColors.primaryBlack.color : Color.gray.opacity(0.3))
                        )
                        .foregroundColor(isEnabled && !isLoading ? .white : .gray)
                    }
                    .disabled(!isEnabled || isLoading)
                }
            }
        }
        .onDisappear {
            stopHaptics()
        }
    }
    
    private func startSmartWrite() {
        isLoading = true
        showSmartWrite = true
        withAnimation(.easeIn(duration: 1.0)) {
            isGlowing = true
        }
        hapticCount = 0
        angle = 0
        
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.prepare()
        
        // Start the haptic feedback with animation
        hapticTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            let intensity = 0.5 * (1 + sin(Double(hapticCount) * 0.3))
            generator.impactOccurred(intensity: intensity)
            hapticCount += 1
            
            if hapticCount >= Int(animationDuration * 10) { // Adjust haptic duration to match animation
                stopEffects() // Stop after animation duration completes
            }
        }
    }
    
    
    private func stopEffects() {
        hapticTimer?.invalidate()
        hapticTimer = nil
        
        // Apply pending description with proper sequencing
        if let pendingDesc = pendingDescription {
            // First fade out
            withAnimation(.easeOut(duration: 0.3)) {
                textOpacity = 0
            }
            
            // Wait for fade out to complete, then update text and fade in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                description = pendingDesc
                pendingDescription = nil
                
                // Fade in with shimmer
                withAnimation(.easeIn(duration: 0.5)) {
                    textOpacity = 1
                    shouldShimmer = true
                }
                
                // Reset shimmer after animation completes
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation {
                        shouldShimmer = false
                    }
                }
            }
        }
        
        // Stop glow animation last
        withAnimation(.easeOut(duration: 1.0)) {
            isGlowing = false
            isLoading = false
        }
    }
    
    
    
    private func stopHaptics() {
        hapticTimer?.invalidate()
        hapticTimer = nil
    }
}


