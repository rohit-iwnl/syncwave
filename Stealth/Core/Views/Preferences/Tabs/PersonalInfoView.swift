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
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var isHereToExploreSelected : Bool = false
    
    @Binding var preferencesArray : [String : Bool]
    
    @EnvironmentObject var navigationCoordinator : NavigationCoordinator
    
    private var isContinueEnabled: Bool {
        selectedCountry != PersonalInfoConstants.residentialStatusCountry.placeholder &&
        selectedState != PersonalInfoConstants.residentialStatusState.placeholder &&
        selectedPronouns != PersonalInfoConstants.pronouns.placeholder &&
        selectedField != PersonalInfoConstants.fields.placeholder
    }
    
    var body: some View {
        
        
        VStack(spacing: 0) {
            
            PreferencesToolbar(currentPage: $navigationCoordinator.currentPage, totalPages: $navigationCoordinator.totalPages, showSkipButton: .constant(false), showPages: .constant(true), onBackTap: handleBackTap)
            
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
                if (preferencesArray["here_to_explore"] == true){
                    self.navigationCoordinator.resetToHome()
                } else {
                    self.navigationCoordinator.path.append(NavigationDestinations.housing)
                }
                currentPage += 1
            }) {
                HStack {
                    Text("Continue")
                        .font(.sora(.body, weight: .medium))
                    Image(systemName: "arrow.right")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(isContinueEnabled ? Color.black : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(!isContinueEnabled)
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
    
    private func handleBackTap() {
        withAnimation(.easeInOut(duration: 0.5)) {
            if !navigationCoordinator.path.isEmpty {
                if navigationCoordinator.path.count == 1 {
                    navigationCoordinator.showPages = false
                }
                navigationCoordinator.path.removeLast()
                navigationCoordinator.currentPage = navigationCoordinator.path.count
                
            } else {
                dismiss()
            }
        }
    }
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





#Preview {
    PersonalInfoView(currentPage: .constant(2), preferencesArray: .constant([:]))
        .environmentObject(NavigationCoordinator())
}
