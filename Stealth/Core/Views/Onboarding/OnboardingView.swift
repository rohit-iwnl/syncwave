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
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    @State private var isModalOpen : Bool = false
    var body: some View {
        ZStack{
            TopographyPattern()
                .fill(onboardingPages[currentPage].color)
                .transition(.opacity)
                .animation(.easeOut(duration: 0.75), value: currentPage)
                .opacity(OnboardingConstants.TopoPatternOpacity)
                .ignoresSafeArea()
            
            TabView(selection: $currentPage){
                ForEach(0..<onboardingPages.count, id : \.self){ index in
                    VStack{
                        RoundedRectangle(cornerRadius: OnboardingConstants.illustrationCornerRadius)
                            .fill(onboardingPages[index].color)
                            .overlay(
                                VStack{
                                    HStack{
                                        CapsuleButton(title: "Skip", action: {
                                            isModalOpen = true
                                        }, color: TextColors.primaryBlack.color)
                                        .alignment(.trailing)
                                        .padding()
                                    }
                                    
                                    Image("OnboardingIllustrations/\(onboardingPages[index].image)")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(.bottom)
                                    Spacer()
                                    
                                }
                            )
                            .padding()
                            .containerRelativeFrame(.vertical) { height, _ in
                                return height / 1.75
                            }
                        Spacer()
                        
                        Text(onboardingPages[index].title)
                            .font(.largeTitle)
                            .transition(.opacity)
                            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: index)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                            .alignment(.leading)
                            .padding()
                        
                        Text(onboardingPages[index].description)
                            .font(.headline)
                            .transition(.opacity)
                            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: index)
                            .lineLimit(3)
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                            .alignment(.leading)
                            .alignment(.top)
                            .padding(.horizontal)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            HStack(spacing: 8) {
                ForEach(0..<onboardingPages.count, id: \.self) { index in
                    Capsule()
                        .fill(index == currentPage ? Color.primary : Color.secondary.opacity(0.5))
                        .frame(width: index == currentPage ? 20 : 8, height: 8)
                        .animation(.easeInOut(duration: 0.25), value: currentPage)
                }
                Spacer()
                Button(action: {
                    if currentPage < onboardingPages.count - 1 {
                        withAnimation(.easeOut) {
                            currentPage += 1
                        }
                    } else {
                        isModalOpen = true
                    }
                }){
                    HStack{
                        Text(currentPage < onboardingPages.count - 1 ? "Next" : "Continue")
                            .font(.callout)
                            .lineLimit(1)
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.5), value: currentPage)
                            .padding(.horizontal)
                            .padding(.vertical,5)
                    }
                    .containerRelativeFrame(.horizontal, { length, _ in
                        return length / 3.5
                    })
                    .background(TextColors.primaryBlack.color)
                    .clipShape(RoundedRectangle(cornerRadius: 12.0))
                }
            }
            .padding()
            .alignment(.trailing)
            .alignment(.bottom)
        }
        .sheet(isPresented: $isModalOpen){
            SignInSheet()
            
                .presentationDetents([.fraction(0.8)])
                .presentationDragIndicator(.visible)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    OnboardingView()
}
