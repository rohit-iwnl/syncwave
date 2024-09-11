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
    
    private var isContinueEnabled: Bool {
        selectedCountry != PersonalInfoConstants.residentialStatusCountry.placeholder &&
        selectedState != PersonalInfoConstants.residentialStatusState.placeholder &&
        !selectedGender.isEmpty &&
        selectedPronouns != PersonalInfoConstants.pronouns.placeholder &&
        selectedField != PersonalInfoConstants.fields.placeholder
    }
    
    var body: some View {
        ZStack {
            TopographyPattern()
                .fill(TextColors.primaryBlack.color)
                .opacity(PreferencesScreenConstants.topoPatternOpacity)
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Tell us a bit about yourself!")
                            .font(.sora(.largeTitle, weight: .semibold))
                            .foregroundColor(.black)
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                            .lineLimit(2)
                            .padding(.bottom)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            InfoField(title: PersonalInfoConstants.residentialStatusCountry.title, selection: $selectedCountry, options: PersonalInfoConstants.residentialStatusCountry.options)
                            InfoField(title: PersonalInfoConstants.residentialStatusState.title, selection: $selectedState, options: PersonalInfoConstants.residentialStatusState.options)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Your Gender")
                                    .font(.sora(.subheadline))
                                    .foregroundColor(.gray)
                                HStack {
                                    ForEach(PersonalInfoConstants.genders.options, id: \.self) { gender in
                                        Button(action: { selectedGender = gender }) {
                                            Text(gender)
                                                .font(.sora(.body))
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(selectedGender == gender ? Color.black : Color.white)
                                                .foregroundColor(selectedGender == gender ? .white : .black)
                                                .cornerRadius(20)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.gray, lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                            }
                            
                            InfoField(title: PersonalInfoConstants.pronouns.title, selection: $selectedPronouns, options: PersonalInfoConstants.pronouns.options)
                            InfoField(title: PersonalInfoConstants.fields.title, selection: $selectedField, options: PersonalInfoConstants.fields.options)
                        }
                    }
                    .padding()
                }
                
                Spacer(minLength: 20)
                
                Button(action: {
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
    }
}



struct InfoField: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.sora(.subheadline))
                .foregroundColor(.gray)
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) {
                        selection = option
                    }
                }
            } label: {
                HStack {
                    Text(selection)
                        .font(.sora(.body))
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
        }
    }
}


#Preview {
    PersonalInfoView(currentPage: .constant(2))
}
