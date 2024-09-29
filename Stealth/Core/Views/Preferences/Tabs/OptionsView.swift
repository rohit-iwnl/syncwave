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
    
    
    
    @EnvironmentObject var navigationCoordinator : NavigationCoordinator
    
    @Binding var preferencesArray : [String : Bool]
    
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                TopographyPattern()
                    .fill(TextColors.primaryBlack.color)
                    .opacity(PreferencesScreenConstants.topoPatternOpacity)
                    .ignoresSafeArea(edges: .all)
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading){
                        Text("What are you seeking for?")
                            .font(.sora(.largeTitle, weight: .semibold))
                            .foregroundStyle(TextColors.primaryBlack.color)
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                            .lineLimit(2)
                        
                        Text("You can select multiple options")
                            .font(.sora(.subheadline))
                            .foregroundStyle(TextColors.secondaryBlack.color.opacity(0.6))
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                            .lineLimit(2)
                    }
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
                                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
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
    
    
    
    private func convertPreferencesToJSON(completion: @escaping (String?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let preferences = OptionButtonConstants.buttons.indices.reduce(into: [String: Bool]()) { result, index in
                let jsonKey = OptionButtonConstants.buttons[index].jsonKey
                result[jsonKey] = selectedButtons[index] ?? false
            }
            
            let jsonString: String?
            if let jsonData = try? JSONSerialization.data(withJSONObject: preferences, options: [.prettyPrinted]),
               let jsonStr = String(data: jsonData, encoding: .utf8) {
                jsonString = jsonStr
            } else {
                jsonString = nil
            }
            
            DispatchQueue.main.async {
                completion(jsonString)
            }
        }
    }
    
    
    
    
    
    private func checkIfValidSelection() -> Bool {
        return selectedButtons.values.contains(true)
    }
    
    private func parseJSON(_ jsonString: String) -> [String: Bool] {
        if let data = jsonString.data(using: .utf8),
           let preferences = try? JSONDecoder().decode([String: Bool].self, from: data) {
            return preferences
        }
        return [:]
    }
    
    private func performAPICallAndNavigate() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let apiCallSucceeded = true
            self.isLoading = false
            if apiCallSucceeded {
                self.convertPreferencesToJSON { jsonString in
                    if let jsonString = jsonString {
                        print(jsonString)
                        let preferences = self.parseJSON(jsonString)
                        print(preferences)
                        
                        // Update totalPages based on preferences
                        self.updateTotalPages(preferences)
                        
                        // Update preferencesArray
                        self.preferencesArray = preferences
                        
                        self.navigationCoordinator.updatePreferences(with: preferences)
                        
                        // Push personal Info view
                        withAnimation(.easeOut(duration: 0.5)) {
                            self.navigationCoordinator.path.append("PersonalInfo")
                            self.navigationCoordinator.showPages = true
                            self.navigationCoordinator.currentPage += 1
                        }
                    }
                }
            }
        }
    }
    
    private func updateTotalPages(_ preferences: [String: Bool]) {
        if preferences["here_to_explore"] == true {
            navigationCoordinator.totalPages = 2
        } else if preferences["sell_buy_product"] == true ||
                  preferences["lease_property"] == true ||
                  preferences["find_roommate"] == true {
            navigationCoordinator.totalPages = 3
        } else {
            navigationCoordinator.totalPages = 2 // Default case
        }
    }

    
    
}

#Preview {
    OptionsView(currentPage: .constant(0), totalPages: .constant(3), preferencesArray: .constant([:]))
        .environmentObject(NavigationCoordinator())
}
