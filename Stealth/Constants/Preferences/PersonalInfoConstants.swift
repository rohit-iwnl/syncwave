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
        title: "Residential Status",
        placeholder: "Select country",
        options: [
            "USA",
            "Canada",
            "Mexico",
            // Add more countries as needed
        ]
    )
    
    static let residentialStatusState = DropDownModel(
        title: "Residential Status",
        placeholder: "Select state",
        options: [
            "California",
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
            // Add more pronoun options as needed
        ]
    )
    
    static let fields = DropDownModel(
        title: "What do you do for work or study?",
        placeholder: "What's your field?",
        options: [
            "Engineering",
            "Design",
            "Healthcare",
            "Education",
            // Add more fields as needed
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
