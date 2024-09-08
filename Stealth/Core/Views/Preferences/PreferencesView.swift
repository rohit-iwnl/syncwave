//
//  PreferencesView.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/4/24.
//

import SwiftUI

struct PreferencesView: View {
    
    @Binding var appUser : AppUser?
    
    @State private var fullName: String = ""
    @State private var isNameLoaded = false
    
    var body: some View {
        NavigationStack {
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
                                if #available(iOS 18, *) {
                                    Text("Hello\n\(fullName)")
                                        .font(.system(size: 50))
                                        .fontWeight(.bold)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                        .meshGradient(
                                            colors: [Color(hex: "#FFEAB6"), Color(hex: "#CFDFFF"), Color(hex: "#FEDDDE")],
                                            animation: .easeInOut(duration: 0.3).repeatForever(autoreverses: true)
                                        )
                                } else {
                                    Text("Hello\n\(fullName)")
                                        .font(.system(size: 50))
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.leading)
                                        .linearGradientBackground(
                                            colors: [Color(hex: "#FFEAB6"), Color(hex: "#CFDFFF"), Color(hex: "#FEDDDE")]
                                        )
                                }
                                Spacer()
                            }
                            .padding(.vertical)
                            
                            Text("Help us to understand you better by adding your preferences. Let's make your journey hyper personalized")
                                .font(.subheadline)
                                .foregroundStyle(TextColors.primaryWhite.color)
                            
                            Spacer()
                            
                            Image(PreferencesScreenConstants.starPath)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        
                        .padding(.horizontal,10)
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
    }
    
    
    private func fetchUserName()  {
        Task {
            do {
                let name = try await PreferencesService.shared.getUserFullName(userID: appUser?.uid ?? "")
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
    PreferencesView(appUser: .constant(nil))
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



