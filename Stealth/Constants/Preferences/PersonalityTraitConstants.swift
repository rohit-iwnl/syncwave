//
//  PersonalityTraitConstants.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/2/25.
//

import Foundation

struct PersonalityTraitConstants {
    struct PersonalTraits {
        let questionSet: [TraitQuestionWithoutScore] = [
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
                    "33+",
                ],
                allowMultipleSelection: true  // Multi select
            ),
        ]
    }

    struct IdealTraits {

    }
}
