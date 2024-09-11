//
//  OptionsView.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/10/24.
//

import SwiftUI

struct OptionsView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @State private var selectedButtons: [Bool] = Array(repeating: false, count: OptionButtonConstants.buttons.count)
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
                    
                    // Use adaptive grid to make it responsive
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
                                            .multilineTextAlignment(.leading)
                                            .padding()
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            Image("Preferences/Illustrations/\(button.illustration)")
                                                .resizable()
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: geometry.size.width / 4, height: geometry.size.width / 4)
                                                .scaleEffect(selectedButtons[index] ? 1.2 : 1.0)
                                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedButtons[index])
                                        }
                                    }
                                    .frame(maxWidth: .infinity, minHeight: geometry.size.height * 0.15, alignment: .topLeading) // Adjust height based on screen size
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
                    
                    ContinueButton(
                        isEnabled: checkIfValidSelection(selectedButtons: selectedButtons),
                        isLoading: isLoading
                    ) {
                        performAPICallAndNavigate()
                    }
                }
                .padding()
            }
        }
    }
    
    // Dynamically adjust the number of columns based on the available width
    private func adaptiveGridColumns(for width: CGFloat) -> [GridItem] {
        let itemWidth: CGFloat = 150  // Define a desired minimum width for each card
        let numColumns = max(Int(width / itemWidth), 2) // Ensure at least 2 columns
        return Array(repeating: GridItem(.flexible(), spacing: 16), count: numColumns)
    }
    
    private func toggleSelection(_ buttonIndex: Int) {
        if buttonIndex == selectedButtons.count - 1 && selectedButtons[buttonIndex] == false {
            // If the last button is selected, clear all other selections and set only the last to true
            selectedButtons = Array(repeating: false, count: selectedButtons.count)
            selectedButtons[buttonIndex] = true
        } else if buttonIndex != selectedButtons.count - 1 && selectedButtons[selectedButtons.count-1] == true {
            selectedButtons[selectedButtons.count-1] = false
            selectedButtons[buttonIndex].toggle()
        } else {
            // Toggle the selection for the button
            selectedButtons[buttonIndex].toggle()
        }
    }
    
    private func checkIfValidSelection(selectedButtons: [Bool]) -> Bool {
        return selectedButtons.contains(true)
    }
    
    private func performAPICallAndNavigate() {
        isLoading = true
        
        // Simulated API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // Replace with actual API call
            // Process the API response here
            let apiCallSucceeded = true // Replace with actual API call result
            
            isLoading = false
            
            if apiCallSucceeded {
                withAnimation {
                    currentPage = min(currentPage + 1, totalPages - 1)
                }
            } else {
                // Handle API call failure (e.g., show an error message)
            }
        }
    }
}

#Preview {
    OptionsView(currentPage: .constant(0), totalPages: .constant(3))
}
