//
//  OnboardingView.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/25/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @Binding var appUser : AppUser?
    @State private var progress: CGFloat = 0.0
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
                                        if (index < onboardingPages.count - 1 ){
                                            CapsuleButton(title: "Skip", action: {
                                                isModalOpen = true
                                            }, color: TextColors.primaryBlack.color)
                                            .alignment(.trailing)
                                            .padding()
                                        } else {
                                            Spacer()
                                                .frame(height: 36) // Adjust the height to match the height of the button
                                                .padding()
                                        }
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
            .onAppear {
                updateProgress()
            }
            .onChange(of : currentPage) {
                updateProgress()
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            HStack() {
                ForEach(0..<onboardingPages.count, id: \.self) { index in
                    Capsule()
                        .fill(index == currentPage ? Color.primary : Color.secondary.opacity(0.5))
                        .frame(width: index == currentPage ? 20 : 8, height: 8)
                        .animation(.easeInOut(duration: 0.25), value: currentPage)
                }
                Spacer()
                ArrowButton(progress: $progress, size: 60)
                    .onTapGesture {
                        let totalPages = onboardingPages.count
                        if currentPage < totalPages - 1 {
                            currentPage += 1
                            progress = CGFloat(currentPage + 1) / CGFloat(totalPages)
                        } else {
                            isModalOpen = true
                        }
                    }
            }
            .padding()
            .alignment(.trailing)
            .alignment(.bottom)
        }
        .sheet(isPresented: $isModalOpen){
            SignInSheet(appUser: $appUser)
                .presentationDetents([.fraction(0.8)])
                .presentationDragIndicator(.visible)
                .ignoresSafeArea()
                .onAppear{
                    Task {
                        try await AuthManager.shared.getCurrentSession()
                    }
                }
        }
    }
    
    
    private func updateProgress() {
        let totalPages = onboardingPages.count
        progress = CGFloat(currentPage + 1) / CGFloat(totalPages)
    }
}

#Preview {
    OnboardingView(appUser: .constant(nil))
}
