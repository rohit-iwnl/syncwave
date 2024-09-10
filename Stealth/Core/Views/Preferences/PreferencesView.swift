//
//  PreferencesView.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/9/24.
//

import SwiftUI

struct PreferencesView: View {
    @State private var currentPage = 0
    private let totalPages = 3
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @State private var selectedButtons: [Bool] = Array(repeating: false, count: OptionButtonConstants.buttons.count)
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack {
            PreferencesToolbar(currentPage: $currentPage, totalPages: totalPages)
            
            ZStack {
                TopographyPattern()
                    .fill(TextColors.primaryBlack.color)
                    .opacity(PreferencesScreenConstants.topoPatternOpacity)
                    .ignoresSafeArea(edges: .all)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("What are you seeking for?")
                        .font(.sora(.largeTitle, weight: .semibold))
                        .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                        .lineLimit(2)
                        .padding(.bottom)
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(OptionButtonConstants.buttons.indices, id: \.self) { index in
                            let button = OptionButtonConstants.buttons[index]
                            Button(action: {
                                toggleSelection(index)
                            }) {
                                ZStack(alignment: .bottomTrailing) {
                                    VStack(alignment: .leading) {
                                        Text(button.label)
                                            .font(.sora(.headline))
                                            .foregroundColor(.black)
                                            .multilineTextAlignment(.leading)
                                            .padding()
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            Image("Preferences/Illustrations/\(button.illustration)")
                                                .resizable()
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 100, height: 100)
                                                .scaleEffect(selectedButtons[index] ? 1.2 : 1.0)
                                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedButtons[index])
                                            
                                            
                                        }
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 100, alignment: .topLeading)
                                    
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedButtons[index] ? button.pressableColor : button.backgroundColor)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedButtons[index] ? Color.black : Color.gray.opacity(0.2), lineWidth: selectedButtons[index] ? 1.2 : 1)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                            .buttonStyle(PressableButtonStyle(
                                backgroundColor: button.backgroundColor,
                                pressedColor: button.pressableColor,
                                isSelected: selectedButtons[index]
                            ))
                            .sensoryFeedback(.selection, trigger: selectedButtons[index])
                        }
                    }
                    
                    Spacer()
                    
                    
                    ContinueButton()
                    
                }
                .padding()
            }
        }
        .toolbar(.hidden)
    }
    
    private func toggleSelection(_ buttonIndex: Int) {
        selectedButtons[buttonIndex].toggle()
    }
}


#Preview {
    PreferencesView()
}
