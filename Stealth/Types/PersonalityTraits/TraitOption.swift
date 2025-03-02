//
//  PersonalityQuestionTraitOption.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/1/25.
//

import Foundation


enum TraitCategory : String, Codable {
    case openness = "Openness"
    case conscientiousness = "Conscientiousness"
    case extraversion = "Extraversion"
    case agreeableness = "Agreeableness"
    case neuroticism = "Neuroticism"
}

struct TraitOption: Codable, Hashable {
    var optionText : String
    var scoreValue : Int
}

struct TraitQuestion : Codable, Hashable {
    let questionText : String
    let category : TraitCategory
    let options : [TraitOption]
}
