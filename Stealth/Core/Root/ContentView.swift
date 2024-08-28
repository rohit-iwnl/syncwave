//
//  ContentView.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/25/24.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @AppStorage(AppStorageConstants.hasCompletedOnboarding.key) private var hasCompletedOnboarding: Bool = false
    @State var appUser: AppUser? = nil
    
    var body: some View {
        ZStack {
            if let appUser = appUser {
                // User is logged in and onboarding is completed
                if hasCompletedOnboarding {
                    HomeView()
                } else {
                    SignInSheet(appUser: $appUser)
                }
            } else {
                // User is not logged in, show onboarding or login view
                OnboardingView(appUser: $appUser)
                    .preferredColorScheme(.light)
            }
        }
        .onAppear {
            Task {
                do {
                    self.appUser = try await AuthManager.shared.getCurrentSession()
                } catch {
                    // Handle error if session retrieval fails
                    print("Failed to get current session: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    ContentView(appUser: nil)
}
