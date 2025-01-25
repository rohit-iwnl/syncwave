//
//  StealthApp.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/25/24.
//

import GoogleSignIn
import SwiftUI

@main
struct StealthApp: App {
    @State private var isLaunchViewPresented = true
    @State private var contentViewOpacity = 0.0 // Start with ContentView fully transparent
    
    var body: some Scene {
        WindowGroup {
                        ZStack {
                            ContentView()
                                .opacity(contentViewOpacity)
                                .onOpenURL { url in
                                    GIDSignIn.sharedInstance.handle(url)
                                }
            
                            if isLaunchViewPresented {
                                LaunchView()
                                    .onAppear {
                                        // Delay to allow the launch animation to complete
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { // 4.0 seconds for the full animation
                                            withAnimation(.easeInOut(duration: 1.5)) {
                                                isLaunchViewPresented = false
                                                contentViewOpacity = 1.0 // Fade in the ContentView
                                            }
                                        }
                                    }
                            }
                        }
                    }
//            RoomTestView()
        }
    }
    

