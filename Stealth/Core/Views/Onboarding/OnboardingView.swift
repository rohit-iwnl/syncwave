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
            
            TabView(selection: $currentPage){
                ForEach(0..<onboardingPages.count, id : \.self){ index in
                    VStack{
                        RoundedRectangle(cornerRadius: OnboardingConstants.illustrationCornerRadius)
                            .fill(onboardingPages[currentPage].color)
                            .overlay(
                                VStack{
                                    HStack{
                                        CapsuleButton(title: "Skip", action: {
                                            
                                        }, color: .black)
                                        .alignment(.topRight)
                                        .padding()
                                    }
                                }
                            )
                            .padding()
                            .containerRelativeFrame(.vertical) { height, _ in
                                return height / 1.75
                            }
                        Spacer()
                        VStack{
                            Text(onboardingPages[currentPage].title)
                        }
                        
                    }
                }
            }
            
        }
    }
}

#Preview {
    OnboardingView()
}
