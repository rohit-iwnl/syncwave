//
//  PersonalityQuestionTraitOption.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/1/25.
//

import Foundation

enum TraitCategory: String, Codable {
    case openness = "Openness"
    case conscientiousness = "Conscientiousness"
    case extraversion = "Extraversion"
    case agreeableness = "Agreeableness"
    case neuroticism = "Neuroticism"
}

struct TraitOption: Codable, Hashable {
    var optionText: String
    var scoreValue: Int
}

struct TraitQuestionWithScore: Codable, Hashable {
    let id: String
    let questionText: String
    let category: TraitCategory
    let options: [TraitOption]

    init(questionText: String, options: [TraitOption], category: TraitCategory)
    {
        self.id = UUID().uuidString
        self.questionText = questionText
        self.options = options
        self.category = category
    }
}

struct TraitQuestionWithoutScore: Codable, Hashable {
    let questionText: String
    let payloadKey: QuestionPayloadKey
    let id: String
    let options: [String]
    let allowMultipleSelection: Bool

    init(
        questionText: String,
        payloadKey: QuestionPayloadKey,  // Add payloadKey parameter
        options: [String],
        allowMultipleSelection: Bool = false
    ) {
        self.id = UUID().uuidString
        self.questionText = questionText
        self.payloadKey = payloadKey
        self.options = options
        self.allowMultipleSelection = allowMultipleSelection
    }
}
