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

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLaunchViewPresented {
                    LaunchView()
                        .onAppear {
                            // Delay to allow the launch animation to complete
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { // 4.0 seconds for the full animation
                                withAnimation {
                                    isLaunchViewPresented = false
                                }
                            }
                        }
                } else {
                    ContentView()
                        .onOpenURL { url in
                            GIDSignIn.sharedInstance.handle(url)
                        }
                }
            }
        }
    }
}
