//
//  WelcomeCard.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/4/24.
//

import SwiftUI
import CoreMotion

struct WelcomeCard: View {
    
    @EnvironmentObject private var appUserStateManager: AppUserManger
    @State private var fullName: String = ""
    @State private var isNameLoaded = false
    

    
    @StateObject var viewModel = SignInViewModel()
    
    var body: some View {
        
        NavigationView {
            ZStack {
                TopographyPattern()
                    .fill(TextColors.primaryBlack.color)
                    .opacity(PreferencesScreenConstants.topoPatternOpacity)
                    .ignoresSafeArea(edges: .all)
                
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(TextColors.primaryBlack.color))
                        
                        VStack {
                            HStack {
                                
                                Text("Hello\n\(fullName)")
                                    .font(.sora(.largeTitle, weight: .bold))
                                    .fontWeight(.bold)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(.white)
                                
                                Spacer()
                            }
                            .padding(.vertical)
                            
                            Text("Help us to understand you better by adding your preferences. Let's make your journey hyper personalized")
                                .font(.sora(.subheadline))
                                .foregroundStyle(TextColors.primaryWhite.color)
                            
                            Spacer()
                            
                            AnimatedStarIllustration()
                            Spacer()
                            
                        }
                        
                        .padding(.horizontal)
                        .padding(.vertical)
                    }
                    .containerRelativeFrame(.vertical) { height, _ in
                        return height / 1.2
                    }
                    
                    
                    NavigationLink(destination: PreferencesView()) {
                        HStack {
                            Text("Select preferences")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(TextColors.primaryBlack.color)
                        .cornerRadius(16)
                    }
                    
                }
                .padding()
            }
            .onAppear(perform: fetchUserName)
        }
        
    }
    
    
    private func fetchUserName()  {
        Task {
            do {
                let name = try await PreferencesService.shared.getUserFullName(userID: appUserStateManager.appUser?.uid ?? "")
                await MainActor.run {
                    self.fullName = name
                    withAnimation {
                        self.isNameLoaded = true
                    }
                }
            } catch {
                print("Error fetching user's full name: \(error)")
            }
        }
    }
}

#Preview {
    WelcomeCard()
        .environmentObject(AppUserManger())
}

struct AnimatedStarIllustration : View {
    
    @StateObject private var motionManager = MotionManager()
    var body : some View {
        Image(PreferencesScreenConstants.starPath)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "#BFB2F3"),
                            Color(hex: "#96CAF7"),
                            Color(hex: "#9CDCAA"),
                            Color(hex: "#E5E1AB"),
                            Color(hex: "#F3C6A5"),
                            Color(hex: "#F8A3A8"),
                        ]),
                        startPoint: UnitPoint(
                            x: 0.5 + CGFloat(motionManager.tiltX * 0.1),
                            y: 0.5 + CGFloat(motionManager.tiltY * 0.1)
                        ),
                        endPoint: UnitPoint(
                            x: 0.5 - CGFloat(motionManager.tiltX * 0.1),
                            y: 0.5 - CGFloat(motionManager.tiltY * 0.1)
                        )
                    )
                    .mask(
                        Image(PreferencesScreenConstants.starPath)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    )
                }
            )
            .animation(.interpolatingSpring(stiffness: 50, damping: 5), value: motionManager.tiltX)
            .animation(.interpolatingSpring(stiffness: 50, damping: 5), value: motionManager.tiltY)
    }
}





class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published var tiltX: Double = 0.0
    @Published var tiltY: Double = 0.0
    
    init() {
        motionManager.deviceMotionUpdateInterval = 1/60
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let motion = motion else { return }
            
            // Use attitude.roll for X-axis tilt
            let roll = motion.attitude.roll
            // Use attitude.pitch for Y-axis tilt
            let pitch = motion.attitude.pitch
            
            // Apply a non-linear curve and damping for more sensitivity
            self?.tiltX = sin(roll) * 2 // Increase multiplier for more sensitivity
            self?.tiltY = sin(pitch) * 2 // Increase multiplier for more sensitivity
            
            // Apply damping to create inertia effect
            self?.applyDamping()
        }
    }
    
    private func applyDamping() {
        // Adjust these values to fine-tune the inertia effect
        let damping: Double = 0.95
        let sensitivity: Double = 0.1
        
        tiltX = tiltX * damping + (tiltX * sensitivity)
        tiltY = tiltY * damping + (tiltY * sensitivity)
    }
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}







extension View {
    // Helper function for linear gradient background
    func linearGradientBackground(colors: [Color]) -> some View {
        self.overlay(
            LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .mask(self)
        )
    }
    
    // Placeholder for mesh gradient function
    @available(iOS 18, *)
    func meshGradient(colors: [Color], animation: Animation) -> some View {
        // Implement mesh gradient animation here
        // This is a placeholder as the actual implementation depends on the mesh gradient API
        self.overlay(
            LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .mask(self)
        )
    }
}



