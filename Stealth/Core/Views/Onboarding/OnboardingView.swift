//
//  OnboardingView.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/25/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @State private var currentPage : Int = 0
    let onboardingPages : [OnboardingPage] = OnboardingConstants.pages
    
    var body: some View {
        ZStack{
            TopographyPattern()
                .fill(onboardingPages[currentPage].color)
                .opacity(OnboardingConstants.TopoPatternOpacity)
                .ignoresSafeArea()
                
        }
    }
}

#Preview {
    OnboardingView()
}
