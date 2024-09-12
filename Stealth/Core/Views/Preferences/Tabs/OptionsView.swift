//
//  OptionsView.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/10/24.
//

import SwiftUI

struct OptionsView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @State private var selectedButtons: [Int: Bool] = [:] // Dictionary to track selections
    @State private var isLoading = false
    
    @Binding var currentPage: Int
    @Binding var totalPages: Int
    
    var body: some View {
        GeometryReader { geometry in
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
                    
                    LazyVGrid(columns: adaptiveGridColumns(for: geometry.size.width), spacing: 16) {
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
                                            .padding()
                                        Spacer(minLength: 20)
                                        HStack {
                                            Spacer()
                                            Image("Preferences/Illustrations/\(button.illustration)")
                                                .resizable()
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: geometry.size.width / 4, height: geometry.size.width / 4)
                                                .scaleEffect(selectedButtons[index] ?? false ? 1.2 : 1.0) // Access the dictionary value
                                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedButtons[index] ?? false)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, minHeight: geometry.size.height * 0.15, alignment: .topLeading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedButtons[index] ?? false ? button.pressableColor : button.backgroundColor)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedButtons[index] ?? false ? Color.black : Color.gray.opacity(0.2), lineWidth: selectedButtons[index] ?? false ? 1.2 : 1)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                            .buttonStyle(PressableButtonStyle(
                                backgroundColor: button.backgroundColor,
                                pressedColor: button.pressableColor,
                                isSelected: selectedButtons[index] ?? false // Access the dictionary value
                            ))
                            .sensoryFeedback(.selection, trigger: selectedButtons[index] ?? false)
                        }
                    }
                    
                    Spacer()
                    
                    ContinueButton(
                        isEnabled: checkIfValidSelection(),
                        isLoading: isLoading
                    ) {
                        performAPICallAndNavigate()
                    }
                }
                .padding()
            }
        }
    }
    
    private func adaptiveGridColumns(for width: CGFloat) -> [GridItem] {
        let itemWidth: CGFloat = 150
        let numColumns = max(Int(width / itemWidth), 2)
        return Array(repeating: GridItem(.flexible(), spacing: 16), count: numColumns)
    }
    
    private func toggleSelection(_ buttonIndex: Int) {
        DispatchQueue.main.async {
            if buttonIndex == OptionButtonConstants.buttons.count - 1 {
                // If the last button is selected, clear all other selections and set only the last to true
                selectedButtons = Dictionary(uniqueKeysWithValues: OptionButtonConstants.buttons.indices.map { ($0, false) })
                selectedButtons[buttonIndex] = true
            } else {
                // Ensure the last button is deselected, if it was selected
                selectedButtons[OptionButtonConstants.buttons.count - 1] = false
                // Toggle the selected state for the current button
                selectedButtons[buttonIndex, default: false].toggle()
            }
        }
    }
    
    
    private func checkIfValidSelection() -> Bool {
        return selectedButtons.values.contains(true)
    }
    
    private func performAPICallAndNavigate() {
        isLoading = true
        
        // Simulated API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let apiCallSucceeded = true
            isLoading = false
            
            if apiCallSucceeded {
                withAnimation {
                    currentPage = min(currentPage + 1, totalPages - 1)
                }
            }
        }
    }
}

#Preview {
    OptionsView(currentPage: .constant(0), totalPages: .constant(3))
}
