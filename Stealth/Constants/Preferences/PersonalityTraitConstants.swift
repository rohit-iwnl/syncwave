//
//  PersonalityTraitConstants.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/2/25.
//

import Foundation

struct PersonalityTraitConstants {
    struct PersonalTraits {
        static let questionSet: [TraitQuestionWithoutScore] = [
            TraitQuestionWithoutScore(
                questionText: "Preferred gender of roommate",
                options: [
                    "Male",
                    "Female",
                    "Any",
                ],
                allowMultipleSelection: false  // Single select
            ),

            TraitQuestionWithoutScore(
                questionText: "Preferred age range of roommate",
                options: [
                    "18-22",
                    "23-27",
                    "28-32",
                    "Any"
                ],
                allowMultipleSelection: false  // Multi select
            ),

            TraitQuestionWithoutScore(
                questionText: "Do you smoke?",
                options: [
                    "Yes",
                    "No",
                    "Occasionally",
                ],
                allowMultipleSelection: false
            ),
            
            TraitQuestionWithoutScore(
                questionText : "Do you drink?",
                options: [
                    "Yes",
                    "No",
                    "Occasionally",
                ]
            ),
            
            TraitQuestionWithoutScore(
                questionText: "What's your noise tolerance level?",
                options : [
                    "Quiet",
                    "Regular",
                    "Moderate",
                    "Loud",
                ]
            ),
            
            TraitQuestionWithoutScore(
                questionText: "What's your cleanliness quotient",
                options : [
                    "Tidy",
                    "Weekend Clean",
                    "Casual",
                    "Messy",
                ]
            )
        ]
    }

    struct IdealTraits {

    }
}
