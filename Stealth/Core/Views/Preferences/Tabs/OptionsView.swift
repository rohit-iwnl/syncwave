//
//  OptionsView.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/10/24.
//

import SwiftUI

struct OptionsView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @State private var selectedButtonIndex: Int? // Single integer to track selection
    @State private var isLoading = false
    @Binding var currentPage: Int
    @Binding var totalPages: Int
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @Binding var preferencesArray: [String: Bool]
    

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                TopographyPattern()
                    .fill(TextColors.primaryBlack.color)
                    .opacity(PreferencesScreenConstants.topoPatternOpacity)
                    .ignoresSafeArea(edges: .all)

                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("What are you seeking for?")
                            .font(.sora(.largeTitle, weight: .semibold))
                            .foregroundStyle(TextColors.primaryBlack.color)
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                            .lineLimit(2)
                        Text("Choose an option")
                            .font(.sora(.headline))
                            .foregroundStyle(TextColors.secondaryBlack.color.opacity(0.6))
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                            .lineLimit(1)
                        Text("(You can explore other options later)")
                            .font(.sora(.subheadline))
                            .foregroundStyle(TextColors.secondaryBlack.color.opacity(0.6))
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                            .lineLimit(2)
                    }
                    .padding(.bottom)

                    ScrollView {
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
                                                    .scaleEffect(selectedButtonIndex == index ? 1.2 : 1.0)
                                                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedButtonIndex == index)
                                            }
                                        }
                                        .frame(maxWidth: .infinity, minHeight: geometry.size.height * 0.15, alignment: .topLeading)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(selectedButtonIndex == index ? button.pressableColor : button.backgroundColor)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(selectedButtonIndex == index ? Color.black : Color.gray.opacity(0.2), lineWidth: selectedButtonIndex == index ? 1.2 : 1)
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                }
                                .buttonStyle(PressableButtonStyle(
                                    backgroundColor: button.backgroundColor,
                                    pressedColor: button.pressableColor,
                                    isSelected: selectedButtonIndex == index
                                ))
                                .sensoryFeedback(.selection, trigger: selectedButtonIndex == index)
                            }
                        }
                    }

                    Spacer()

                    ContinueButton(
                        isEnabled: selectedButtonIndex != nil,
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

    private func toggleSelection(_ index: Int) {
        if selectedButtonIndex == index {
            selectedButtonIndex = nil // Deselect if already selected
        } else {
            selectedButtonIndex = index // Select the new button
        }
    }

    private func convertPreferencesToJSON(completion: @escaping (String?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let preferences = OptionButtonConstants.buttons.indices.reduce(into: [String: Bool]()) { result, index in
                let jsonKey = OptionButtonConstants.buttons[index].jsonKey
                result[jsonKey] = index == selectedButtonIndex
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
                        self.updateTotalPages(preferences)
                        self.preferencesArray = preferences
                        self.navigationCoordinator.updatePreferences(with: preferences)
                        
                        UserPreferencesManager.storePreferences(preferences)
                        
                        withAnimation(.easeOut(duration: 0.5)) {
                            self.navigationCoordinator.path.append(NavigationDestinations.personalInfo)
                            self.navigationCoordinator.currentPage += 1
                        }
                    }
                }
            }
        }
    }

    private func updateTotalPages(_ preferences: [String: Bool]) {
        if preferences[JsonKey.here_to_explore] == true {
            navigationCoordinator.totalPages = 1
            navigationCoordinator.showPages = false
        } else if preferences[JsonKey.lease_sublease_property] == true || preferences[JsonKey.sell_buy_product] == true {
            navigationCoordinator.totalPages = 2
            navigationCoordinator.showPages = true
        } else if preferences[JsonKey.find_roomate] == true {
            navigationCoordinator.totalPages = 3
            navigationCoordinator.showPages = true
        } else {
            navigationCoordinator.path.removeLast()
        }
    }
}


#Preview {
    OptionsView(currentPage: .constant(0), totalPages: .constant(3), preferencesArray: .constant([:]))
        .environmentObject(NavigationCoordinator())
}
