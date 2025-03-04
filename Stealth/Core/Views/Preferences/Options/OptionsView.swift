//
//  OptionsView.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/10/24.
//

import SwiftUI

struct OptionsView: View {
    @EnvironmentObject var appUserStateManager : AppUserManger
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @State private var selectedButtonIndex: Int?
    @State private var isLoading = false
    @Binding var currentPage: Int
    @Binding var totalPages: Int
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @Binding var preferencesArray: [String: Bool]
    
    @State var showErrorAlert = false
    
    
    
    var body: some View {
        GeometryReader { geometry in
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
                    VStack(spacing: 16) {
                        ForEach(0..<OptionButtonConstants.buttons.count / 2, id: \.self) { rowIndex in
                            HStack(spacing: 16) {
                                ForEach(0..<2, id: \.self) { columnIndex in
                                    let index = rowIndex * 2 + columnIndex
                                    if index < OptionButtonConstants.buttons.count {
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
                                                    }
                                                }
                                                .frame(
                                                    maxWidth: max(geometry.size.width / 2 - 16, 0), // Ensure width is not negative
                                                    minHeight: max(geometry.size.height * 0.15, 0), // Ensure height is not negative
                                                    alignment: .topLeading
                                                )
                                                
                                                
                                                
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
                        }
                    }
                    .padding(.vertical, 4)
                }
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 5)
                
                
                
                Spacer()
                
                ContinueButton(
                    isEnabled: selectedButtonIndex != nil,
                    isLoading: isLoading
                ) {
                    Task {
                        performAPICallAndNavigate()
                    }
                }
            }
            .padding()
        }
    }
    
    private func provideHapticFeedback() {
        DispatchQueue.global(qos: .userInitiated).async {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
    
    private func toggleSelection(_ index: Int) {
        DispatchQueue.main.async {
            if selectedButtonIndex == index {
                selectedButtonIndex = nil // Deselect if already selected
            } else {
                selectedButtonIndex = index // Select the new button
            }
        }
    }
    
    private func convertPreferencesToJSON(completion: @escaping (String?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            // Create preferences dictionary
            let preferences = OptionButtonConstants.buttons.indices.reduce(into: [String: Bool]()) { result, index in
                let jsonKey = OptionButtonConstants.buttons[index].jsonKey
                result[jsonKey] = index == selectedButtonIndex
            }
            
            // Wrap preferences in an object
            let jsonObject = ["preferences": preferences]
            
            let jsonString: String?
            if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
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
           let jsonObject = try? JSONDecoder().decode([String: [String: Bool]].self, from: data),
           let preferences = jsonObject["preferences"] {
            return preferences
        }
        return [:]
    }
    
    private func performAPICallAndNavigate() {
        Task {
            do {
                isLoading = true
                
                guard let supabase_id = appUserStateManager.appUser?.uid?.lowercased() else {
                    print("Supabase ID is nil")
                    isLoading = false
                    return
                }
                
                let preferences = OptionButtonConstants.buttons.indices.reduce(into: [String: Bool]()) { result, index in
                    let jsonKey = OptionButtonConstants.buttons[index].jsonKey
                    result[jsonKey] = index == selectedButtonIndex
                }
                
                let payload = PreferencesPayload(supabase_id: supabase_id, preferences: preferences)
                
                // Print the payload for debugging
                do {
                    let payloadData = try JSONEncoder().encode(payload)
                    if let prettyPayload = String(data: payloadData, encoding: .utf8) {
                        print("Sending payload:\n\(prettyPayload)")
                    }
                } catch {
                    print("Error encoding payload: \(error)")
                    // Handle the error appropriately, e.g., show an alert to the user
                    self.showErrorAlert = true
                    return
                }
                
                // Use the NetworkService to send preferences
                try await NetworkService.shared.sendPreferences(preferences, supabaseID: supabase_id)
                
                // Handle successful response
                await MainActor.run {
                    self.isLoading = false
                    self.updateTotalPages(preferences)
                    self.preferencesArray = preferences
                    self.navigationCoordinator.updatePreferences(with: preferences)
                    UserPreferencesManager.storePreferences(preferences)
                    self.navigationCoordinator.path.append(NavigationDestinations.personalInfo)
                    self.navigationCoordinator.currentPage += 1
                }
                
                // Print the pretty JSON for debugging
                if let jsonData = try? JSONEncoder().encode(preferences),
                   let prettyPrintedString = String(data: jsonData, encoding: .utf8) {
                    print("Preferences sent:\n\(prettyPrintedString)")
                }
                
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    print("API call failed: \(error)")
                    // Handle error (e.g., show an alert to the user)
                    self.showErrorAlert = true
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
        .environmentObject(AppUserManger())
}
