//
//  PersonalInfoView.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/10/24.
//

//
//  PersonalInfoView.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/10/24.
//

import SwiftUI



struct PersonalInfoView: View {
    @Binding var currentPage: Int
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @State private var selectedCountry = PersonalInfoConstants.residentialStatusCountry.placeholder
    @State private var selectedState = PersonalInfoConstants.residentialStatusState.placeholder
    @State private var selectedGender = ""
    @State private var selectedPronouns = PersonalInfoConstants.pronouns.placeholder
    @State private var selectedField = PersonalInfoConstants.fields.placeholder
    @State private var activeField: String?
    
    @EnvironmentObject var appUserStateManger : AppUserManger
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var isHereToExploreSelected : Bool = false
    
    @Binding var preferencesArray : [String : Bool]
    
    @EnvironmentObject var navigationCoordinator : NavigationCoordinator
    
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    private var isContinueEnabled: Bool {
        selectedCountry != PersonalInfoConstants.residentialStatusCountry.placeholder &&
        selectedState != PersonalInfoConstants.residentialStatusState.placeholder &&
        selectedPronouns != PersonalInfoConstants.pronouns.placeholder &&
        selectedField != PersonalInfoConstants.fields.placeholder
    }
    
    var body: some View {
        VStack(spacing: 0) {
            PreferencesToolbar(currentPage: $navigationCoordinator.currentPage, totalPages: $navigationCoordinator.totalPages, showPages: $navigationCoordinator.showPages, onBackTap: handleBackTap)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Tell us a bit about yourself!")
                        .font(.sora(.largeTitle, weight: .semibold))
                        .foregroundColor(.black)
                        .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                        .lineLimit(2)
                        .padding(.bottom)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        InfoField(title: PersonalInfoConstants.residentialStatusCountry.title,
                                  selection: $selectedCountry,
                                  options: PersonalInfoConstants.residentialStatusCountry.options,
                                  isActive: Binding(
                                    get: { activeField == PersonalInfoConstants.residentialStatusCountry.title },
                                    set: { if $0 { activeField = PersonalInfoConstants.residentialStatusCountry.title } else { activeField = nil } }
                                  ))
                        InfoField(title: PersonalInfoConstants.residentialStatusState.title,
                                  selection: $selectedState,
                                  options: PersonalInfoConstants.residentialStatusState.options,
                                  isActive: Binding(
                                    get: { activeField == PersonalInfoConstants.residentialStatusState.title },
                                    set: { if $0 { activeField = PersonalInfoConstants.residentialStatusState.title } else { activeField = nil } }
                                  ))
                        
                        // Gender buttons remain unchanged
                        
                        InfoField(title: PersonalInfoConstants.pronouns.title,
                                  selection: $selectedPronouns,
                                  options: PersonalInfoConstants.pronouns.options,
                                  isActive: Binding(
                                    get: { activeField == PersonalInfoConstants.pronouns.title },
                                    set: { if $0 { activeField = PersonalInfoConstants.pronouns.title } else { activeField = nil } }
                                  ))
                        InfoField(title: PersonalInfoConstants.fields.title,
                                  selection: $selectedField,
                                  options: PersonalInfoConstants.fields.options,
                                  isActive: Binding(
                                    get: { activeField == PersonalInfoConstants.fields.title },
                                    set: { if $0 { activeField = PersonalInfoConstants.fields.title } else { activeField = nil } }
                                  ))
                    }
                }
                .padding()
            }
            
            Spacer(minLength: 20)
            
            Button(action: {
                Task {
                    await handleSetPersonalDetailsRequest()
                }
            }) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Continue")
                            .font(.sora(.body, weight: .medium))
                        Image(systemName: "arrow.right")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(isContinueEnabled ? Color.black : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(!isContinueEnabled || isLoading)
            .padding(.horizontal)
            .padding(.bottom, 20)
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func handleBackTap() {
        withAnimation(.easeInOut(duration: 0.5)) {
            if !navigationCoordinator.path.isEmpty {
                
                if(UserPreferencesManager.getPreferences() == [:]){
                    UserPreferencesManager.clearPreferences()
                }
                
                navigationCoordinator.showPages = false
                navigationCoordinator.path.removeLast()
                navigationCoordinator.currentPage = navigationCoordinator.currentPage - 1
            } else {
                dismiss()
            }
        }
    }
    
    private func handleSetPersonalDetailsRequest() async {
        isLoading = true
        
        do{
            
            guard let jsonString = await convertPersonalDetailsToJson() else {
                errorMessage = "Failed to create request data"
                showError = true
                isLoading = false
                return
            }
            
            
            guard let url = URL(string: "http://159.89.222.41:8000/api/onboarding/set-personal-details") else {
                errorMessage = "Invalid URL"
                showError = true
                isLoading = false
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer Naandhaandaungoppan", forHTTPHeaderField: "Authorization")
            request.httpBody = jsonString.data(using: .utf8)
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                isLoading = false
                if httpResponse.statusCode == 200 {
                    if (preferencesArray["here_to_explore"] == true) {
                        self.navigationCoordinator.resetToHome()
                    } else if (preferencesArray["find_roommate"] == true) {
                        self.navigationCoordinator.path.append(NavigationDestinations.roomdecider)
                    } else {
                        self.navigationCoordinator.path.append(NavigationDestinations.housing)
                    }
                    currentPage += 1
                } else if httpResponse.statusCode == 404 {
                    errorMessage = "Server error. Please try again later."
                    showError = true
                }
                else {
                    errorMessage = "Server error: \(httpResponse.statusCode)"
                    showError = true
                }
            }
            
        } catch {
            errorMessage = "Error setting personal details"
            showError = true
        }
    }
    
    
    private func convertPersonalDetailsToJson() async -> String? {
        guard let supabase_id = appUserStateManger.appUser?.uid else {
            return nil
        }
        
        let personalDetailsRequest = PersonalDetailsRequest(
            supabase_id: supabase_id.lowercased(),
            personal_details: PersonalDetailsRequest.PersonalDetails(
                country: selectedCountry == PersonalInfoConstants.residentialStatusCountry.placeholder ? "" : selectedCountry,
                state: selectedState == PersonalInfoConstants.residentialStatusState.placeholder ? "" : selectedState,
                gender: selectedGender.isEmpty ? nil : selectedGender,
                field: selectedField == PersonalInfoConstants.fields.placeholder ? "" : selectedField,
                pronouns: selectedPronouns == PersonalInfoConstants.pronouns.placeholder ? "" : selectedPronouns
            )
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
        
        if let jsonData = try? encoder.encode(personalDetailsRequest),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        
        return nil
    }
    
    
    
    
    
    
    
    struct InfoField: View {
        
        @Environment(\.dynamicTypeSize) var dynamicTypeSize
        
        let title: String
        @Binding var selection: String
        let options: [String]
        @Binding var isActive: Bool
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.sora(.subheadline))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    .foregroundColor(.gray)
                Menu {
                    ForEach(options, id: \.self) { option in
                        Button(option) {
                            selection = option
                            isActive = false
                        }
                    }
                } label: {
                    HStack {
                        Text(selection)
                            .font(.sora(.body))
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.black)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.white)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                            .offset(y: 4),
                        alignment: .bottom
                    )
                }
                .onTapGesture {
                    isActive = true
                }
            }
        }
    }
}





#Preview {
    PersonalInfoView(currentPage: .constant(2), preferencesArray: .constant([:]))
        .environmentObject(NavigationCoordinator())
        .environmentObject(AppUserManger())
}
