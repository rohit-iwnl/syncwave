//
//  PersonalInfoConstants.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/10/24.
//

import Foundation

struct DropDownModel {
    let title: String
    let placeholder: String
    let options: [String]
}

struct PersonalInfoConstants {
    static let residentialStatusCountry = DropDownModel(
        title: "Residential Info",
        placeholder: "Select country",
        options: [
            "USA",
            "Canada",
            "UK"
        ]
    )
    
    static let residentialStatusState = DropDownModel(
        title: "Residential Info",
        placeholder: "Select state",
        options: [
            "California",
            "Arizona",
            "North Carolina",
            "New Jersey",
            "Texas",
            "New York",
            // Add more states as needed
        ]
    )
    
    static let genders = DropDownModel(
        title: "Your Gender",
        placeholder: "Select gender",
        options: [
            "Male",
            "Female",
            "Other"
        ]
    )
    
    static let pronouns = DropDownModel(
        title: "Pronouns",
        placeholder: "How do you identify yourself?",
        options: [
            "He/Him",
            "She/Her",
            "They/Them",
            "Prefer not to say"
            // Add more pronoun options as needed
        ]
    )
    
    static let fields = DropDownModel(
        title: "What do you do for work or study?",
        placeholder: "What's your field?",
        options: [
            "Engineering",
            "Finance",
            "Business",
            "Design",
            "Healthcare",
            "Education",
            "Arts",
        ]
    )
    
    static let languages = DropDownModel(
        title: "Languages you know",
        placeholder: "What do you speak?",
        options: [
            "English",
            "Spanish",
            "French",
            "Mandarin",
            // Add more languages as needed
        ]
    )
}
