//
//  RoomDeciderView.swift
//  Stealth
//
//  Created by Rohit Manivel on 11/1/24.
//

import SwiftUI

struct RoomDeciderView: View {
    @State private var showSkipAlert = false
    @State private var selectedButton: Int? = nil
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 20) {
                PreferencesToolbar(
                    currentPage: $navigationCoordinator.currentPage,
                    totalPages: $navigationCoordinator.totalPages,
                    showPages: .constant(false),
                    onBackTap: handleBackTap
                )
                VStack {
                    VStack(alignment: .leading) {
                        Text("What's your goal?")
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
                    .alignment(.leading)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            // Two main buttons in HStack
                            HStack(spacing: 16) {
                                ForEach(0..<2) { index in
                                    let button = OptionButtonConstants.roomDecidingButtons[index]
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
                                                    Image("Preferences/RoomDecider/\(button.illustration)")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: geometry.size.width / 4, height: geometry.size.width / 4)
                                                        .scaleEffect(selectedButton == index ? 1.2 : 1.0)
                                                }
                                            }
                                            .frame(
                                                maxWidth: max(geometry.size.width / 2 - 8, 0),
                                                minHeight: max(geometry.size.height * 0.15, 0),
                                                alignment: .topLeading
                                            )
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(selectedButton == index ? button.pressableColor : button.backgroundColor)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(selectedButton == index ? Color.black : Color.gray.opacity(0.2), lineWidth: selectedButton == index ? 1.2 : 1)
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                        }
                                    }
                                    .buttonStyle(PressableButtonStyle(
                                        backgroundColor: button.backgroundColor,
                                        pressedColor: button.pressableColor,
                                        isSelected: selectedButton == index
                                    ))
                                    .sensoryFeedback(.selection, trigger: selectedButton == index)
                                }
                            }
                            
                            // Looking for both button
                            Button(action: {
                                toggleSelection(2)
                            }) {
                                Text("Looking for both")
                                    .font(.sora(.headline))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedButton == 2 ? Color(hex: "#D0F7C3") : .white)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedButton == 2 ? Color.black : Color.gray.opacity(0.2),
                                                    lineWidth: selectedButton == 2 ? 1.2 : 1)
                                    )
                                
                            }
                            .buttonStyle(PressableButtonStyle(
                                backgroundColor: .white,
                                pressedColor: Color(hex: "#F5F5F5"),
                                isSelected: selectedButton == 2
                            ))
                            .sensoryFeedback(.selection, trigger: selectedButton == 2)
                        }
                        .padding(.vertical, 4)
                    }
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 5)
                    
                    ContinueButton(
                        isEnabled: isContinueEnabled,
                        isLoading: isLoading
                    ) {
                        Task{
                            await performAPICallAndNavigate()
                        }
                    }
                    .padding(.bottom, 20)
                    .alert("Error", isPresented: $showError) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(errorMessage)
                    }
                }
                .padding(.horizontal)
                
            }
            
            
        }}
    
    private var isContinueEnabled: Bool {
        return selectedButton != nil
    }
    
    
    private func toggleSelection(_ index: Int) {
        DispatchQueue.main.async {
            if selectedButton == index {
                selectedButton = nil  // Deselect if tapping the same button
            } else {
                selectedButton = index  // Select new button, automatically deselects others
            }
        }
    }
    
    private func createPreferencesJSON(supabase_id: String) throws -> Data {
        let room_preferences = FindRoomPreferences(
            supabase_id: supabase_id.lowercased(),
            find_room_preferences: FindRoomPreferences.RoomPreferences(
                need_room: selectedButton == 0 ? true : false,
                need_roommate: selectedButton == 1 ? true : false,
                looking_for_both: selectedButton == 2 ? true : false
            )
        )
        
        let encode = JSONEncoder()
        return try encode.encode(room_preferences)
    }

    private func performAPICallAndNavigate() async {
        isLoading = true
        
        guard let supabaseId = try? await AuthManager.shared.getCurrentSession(),
              let userId = supabaseId.uid else {
            print("Error: No user ID found")
            isLoading = false
            return
        }
        
        // Convert preferences to JSON
        let jsonData: Data
        do {
            jsonData = try createPreferencesJSON(supabase_id: userId)
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                showError = true
                isLoading = false
            
            }
            return
        }
        
        guard let url = URL(string: "http://159.89.222.41:8000/api/onboarding/set-find-room-preferences") else {
            print("Invalid URL")
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer Naandhaandaungoppan", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData // Direct assignment since jsonData is already encoded
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw URLError(.badServerResponse)
            }
            
            await MainActor.run {
                isLoading = false
                navigationCoordinator.currentPage += 1
                navigationCoordinator.path.append(NavigationDestinations.sellingProperty)
            }
            
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                showError = true
                isLoading = false
            }
        }
    }

    
    
    private func handleBackTap() {
        withAnimation(.easeInOut(duration: 0.5)) {
            if !navigationCoordinator.path.isEmpty {
                navigationCoordinator.path.removeLast()
                navigationCoordinator.currentPage -= 1
            } else {
                dismiss()
            }
        }
    }
}

struct FindRoomPreferences: Codable {
    let supabase_id: String
    let find_room_preferences: RoomPreferences
    
    struct RoomPreferences: Codable {
        let need_room: Bool?
        let need_roommate: Bool?
        let looking_for_both: Bool?
    }
}


#Preview {
    RoomDeciderView()
        .environmentObject(NavigationCoordinator())
}
