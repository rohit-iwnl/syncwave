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

struct TraitQuestionWithScore : Codable, Hashable {
    let id : String
    let questionText : String
    let category : TraitCategory
    let options : [TraitOption]
    
    init(questionText : String, options : [TraitOption], category : TraitCategory) {
        self.id = UUID().uuidString
        self.questionText = questionText
        self.options = options
        self.category = category
    }
}

struct TraitQuestionWithoutScore : Codable, Hashable {
    
    let questionText: String
    
    let id: String
    let options : [String]
    
    let allowMutlipleSelection : Bool
    
    
    init(questionText : String, options : [String], allowMultipleSelection : Bool = false) {
        self.id = UUID().uuidString
        self.questionText = questionText
        self.options = options
        self.allowMutlipleSelection = allowMultipleSelection
    }
}
