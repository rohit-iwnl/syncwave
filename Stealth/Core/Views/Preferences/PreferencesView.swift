//
//  PreferencesView.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/4/24.
//

import SwiftUI
import CoreMotion

struct PreferencesView: View {
    
    @EnvironmentObject private var appUserStateManager: AppUserManger
    @StateObject private var motionManager = MotionManager()
    
    @State private var fullName: String = ""
    @State private var isNameLoaded = false
    
    var body: some View {
        
        ZStack {
            TopographyPattern()
                .fill(TextColors.primaryBlack.color)
                .opacity(PreferencesScreenConstants.topoPatternOpacity)
                .ignoresSafeArea()
            
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
                        
                        Image(PreferencesScreenConstants.starPath)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .overlay(
                                GeometryReader { geometry in
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(hex: "#FFEAB6"),  // Vibrant red
                                            Color(hex: "#CFDFFF"),  // Turquoise
                                            Color(hex: "#CFDFFF"),  // Bright green
                                            Color(hex: "#FEDDDE"),
                                            Color(hex: "#FBBF29"),
                                            
                                        ]),
                                        startPoint: UnitPoint(x: 0.5, y: CGFloat(0.5 + motionManager.tilt * 0.5)),
                                        endPoint: UnitPoint(x: 0.5, y: CGFloat(0.5 - motionManager.tilt * 0.5))
                                    )
                                    .mask(
                                        Image(PreferencesScreenConstants.starPath)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    )
                                }
                            )
                            .animation(.easeInOut(duration: 0.05), value: motionManager.tilt)
                            .animation(.easeInOut(duration: 0.05), value: motionManager.tilt)
                        
                        
                    }
                    
                    .padding(.horizontal)
                    .padding(.vertical)
                }
                .containerRelativeFrame(.vertical) { height, _ in
                    return height / 1.2
                }
                
                NavigationLink {
                    
                } label: {
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
        }
        .padding()
        .onAppear(perform: fetchUserName)
        
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
    PreferencesView()
        .environmentObject(AppUserManger())
}





class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published var tilt: Double = 0.0
    
    init() {
        motionManager.deviceMotionUpdateInterval = 1/60
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let motion = motion else { return }
            
            // Focus on pitch (vertical tilt) and adjust sensitivity
            let pitch = motion.attitude.pitch
            let adjustedTilt = (pitch + .pi/2) / .pi // Normalize to 0-1 range
            
            // Apply a non-linear curve for more sensitivity in the middle range
            self?.tilt = sin(adjustedTilt * .pi)
            
            // Ensure tilt stays within -1 to 1 range
            self?.tilt = max(-1, min(1, self?.tilt ?? 0))
        }
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



