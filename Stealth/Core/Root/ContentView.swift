//
//  ContentView.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/25/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(AppStorageConstants.hasCompletedOnboarding.key) private var hasCompletedOnboarding : Bool = false
    
    var body: some View {
        if(hasCompletedOnboarding){
            HomeView()
        } else {
            OnboardingView()
                .preferredColorScheme(.light)
        }
    }
}

#Preview {
    ContentView()
}
