//
//  PersonalityTraitConstants.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/2/25.
//

import Foundation

struct PersonalityTraitConstants {
    struct PersonalTraits {
        
        /// Unscored Questions (Basic filtering shiii)
        static let basicQuestionsSet: [TraitQuestionWithoutScore] = [
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
        
        
        /// Scored Questions (Personality shii)
        ///
        // OPENNESS QUESTIONS
        static let opennessQuestions = [
            TraitQuestionWithScore(
                questionText: "How do you handle unexpected changes to plans?",
                options: [
                    TraitOption(optionText: "I strongly prefer sticking to established routines", scoreValue: 1),
                    TraitOption(optionText: "I'm somewhat uncomfortable with sudden changes", scoreValue: 2),
                    TraitOption(optionText: "I can adapt if necessary", scoreValue: 3),
                    TraitOption(optionText: "I'm usually open to new approaches", scoreValue: 4),
                    TraitOption(optionText: "I thrive on spontaneity and new experiences", scoreValue: 5)
                ],
                category: .openness
            ),
            TraitQuestionWithScore(
                questionText: "How important is trying new activities with roommates?",
                options: [
                    TraitOption(optionText: "I prefer familiar routines we all know", scoreValue: 1),
                    TraitOption(optionText: "I occasionally enjoy new experiences", scoreValue: 2),
                    TraitOption(optionText: "I like a balance of familiar and new", scoreValue: 3),
                    TraitOption(optionText: "I often suggest new places and activities", scoreValue: 4),
                    TraitOption(optionText: "I'm constantly seeking novel experiences", scoreValue: 5)
                ],
                category: .openness
            ),
            TraitQuestionWithScore(
                questionText: "How do you feel about trying unconventional living arrangements?",
                options: [
                    TraitOption(optionText: "I prefer traditional, proven setups", scoreValue: 1),
                    TraitOption(optionText: "I'm hesitant but could consider it", scoreValue: 2),
                    TraitOption(optionText: "I'm open to reasonable alternatives", scoreValue: 3),
                    TraitOption(optionText: "I enjoy creative living solutions", scoreValue: 4),
                    TraitOption(optionText: "I actively seek unique living experiences", scoreValue: 5)
                ],
                category: .openness
            ),
            TraitQuestionWithScore(
                questionText: "How do you approach unfamiliar foods and cuisines?",
                options: [
                    TraitOption(optionText: "I stick to foods I know and like", scoreValue: 1),
                    TraitOption(optionText: "I try new things occasionally", scoreValue: 2),
                    TraitOption(optionText: "I'm willing to sample most dishes", scoreValue: 3),
                    TraitOption(optionText: "I actively seek out new culinary experiences", scoreValue: 4),
                    TraitOption(optionText: "I'll try absolutely anything once", scoreValue: 5)
                ],
                category: .openness
            )
        ]

        // CONSCIENTIOUSNESS QUESTIONS
        static let conscientiousnessQuestions = [
            TraitQuestionWithScore(
                questionText: "How do you approach shared cleaning responsibilities?",
                options: [
                    TraitOption(optionText: "I clean when things become visibly messy", scoreValue: 1),
                    TraitOption(optionText: "I tidy up occasionally when reminded", scoreValue: 2),
                    TraitOption(optionText: "I do my part in regular cleaning", scoreValue: 3),
                    TraitOption(optionText: "I follow a consistent cleaning schedule", scoreValue: 4),
                    TraitOption(optionText: "I maintain spotless spaces with detailed systems", scoreValue: 5)
                ],
                category: .conscientiousness
            ),
            TraitQuestionWithScore(
                questionText: "How do you handle shared expenses and deadlines?",
                options: [
                    TraitOption(optionText: "I pay when reminded multiple times", scoreValue: 1),
                    TraitOption(optionText: "I sometimes need a reminder", scoreValue: 2),
                    TraitOption(optionText: "I usually pay on time", scoreValue: 3),
                    TraitOption(optionText: "I consistently pay before deadlines", scoreValue: 4),
                    TraitOption(optionText: "I set up automatic payments and track all expenses", scoreValue: 5)
                ],
                category: .conscientiousness
            ),
            TraitQuestionWithScore(
                questionText: "How organized is your personal space?",
                options: [
                    TraitOption(optionText: "Chaotic but I know where things are", scoreValue: 1),
                    TraitOption(optionText: "Somewhat cluttered but functional", scoreValue: 2),
                    TraitOption(optionText: "Generally tidy with occasional mess", scoreValue: 3),
                    TraitOption(optionText: "Well-organized with designated places", scoreValue: 4),
                    TraitOption(optionText: "Meticulously organized and labeled", scoreValue: 5)
                ],
                category: .conscientiousness
            ),
            TraitQuestionWithScore(
                questionText: "How do you approach shared food in the refrigerator?",
                options: [
                    TraitOption(optionText: "I use what I need without tracking", scoreValue: 1),
                    TraitOption(optionText: "I try to remember what I've used", scoreValue: 2),
                    TraitOption(optionText: "I replace items when I notice they're low", scoreValue: 3),
                    TraitOption(optionText: "I keep track and replace what I use", scoreValue: 4),
                    TraitOption(optionText: "I label everything and maintain detailed inventory", scoreValue: 5)
                ],
                category: .conscientiousness
            )
        ]

        // EXTRAVERSION QUESTIONS
        static let extraversionQuestions = [
            TraitQuestionWithScore(
                questionText: "What's your ideal social environment at home?",
                options: [
                    TraitOption(optionText: "Quiet space with minimal interaction", scoreValue: 1),
                    TraitOption(optionText: "Occasional brief conversations", scoreValue: 2),
                    TraitOption(optionText: "Regular casual hangouts with roommates", scoreValue: 3),
                    TraitOption(optionText: "Frequent social gatherings at home", scoreValue: 4),
                    TraitOption(optionText: "Constant social activity and visitors", scoreValue: 5)
                ],
                category: .extraversion
            ),
            TraitQuestionWithScore(
                questionText: "How often do you prefer having guests over?",
                options: [
                    TraitOption(optionText: "Rarely or never", scoreValue: 1),
                    TraitOption(optionText: "Once or twice a month", scoreValue: 2),
                    TraitOption(optionText: "Weekends only", scoreValue: 3),
                    TraitOption(optionText: "Several times per week", scoreValue: 4),
                    TraitOption(optionText: "Almost daily", scoreValue: 5)
                ],
                category: .extraversion
            ),
            TraitQuestionWithScore(
                questionText: "After a long day, you prefer to:",
                options: [
                    TraitOption(optionText: "Recharge alone in my room", scoreValue: 1),
                    TraitOption(optionText: "Have quiet time with minimal interaction", scoreValue: 2),
                    TraitOption(optionText: "Chat briefly then have personal time", scoreValue: 3),
                    TraitOption(optionText: "Hang out with roommates to unwind", scoreValue: 4),
                    TraitOption(optionText: "Go out and socialize to energize", scoreValue: 5)
                ],
                category: .extraversion
            ),
            TraitQuestionWithScore(
                questionText: "How do you feel about shared meals with roommates?",
                options: [
                    TraitOption(optionText: "I prefer eating alone", scoreValue: 1),
                    TraitOption(optionText: "Occasional shared meals are fine", scoreValue: 2),
                    TraitOption(optionText: "Weekly dinners together are nice", scoreValue: 3),
                    TraitOption(optionText: "I enjoy regular meals together", scoreValue: 4),
                    TraitOption(optionText: "I want to share most meals and cooking", scoreValue: 5)
                ],
                category: .extraversion
            )
        ]

        // AGREEABLENESS QUESTIONS
        static let agreeablenessQuestions = [
            TraitQuestionWithScore(
                questionText: "How do you typically handle conflicts with roommates?",
                options: [
                    TraitOption(optionText: "I stand my ground firmly on my position", scoreValue: 1),
                    TraitOption(optionText: "I reluctantly compromise if necessary", scoreValue: 2),
                    TraitOption(optionText: "I try to find middle ground solutions", scoreValue: 3),
                    TraitOption(optionText: "I usually prioritize harmony over being right", scoreValue: 4),
                    TraitOption(optionText: "I'm very flexible and accommodating", scoreValue: 5)
                ],
                category: .agreeableness
            ),
            TraitQuestionWithScore(
                questionText: "How do you respond when roommates borrow your things?",
                options: [
                    TraitOption(optionText: "I don't allow anyone to use my belongings", scoreValue: 1),
                    TraitOption(optionText: "I'm uncomfortable but might allow it", scoreValue: 2),
                    TraitOption(optionText: "I'm okay if they ask permission first", scoreValue: 3),
                    TraitOption(optionText: "I'm generally fine with sharing most items", scoreValue: 4),
                    TraitOption(optionText: "I freely share almost everything I own", scoreValue: 5)
                ],
                category: .agreeableness
            ),
            TraitQuestionWithScore(
                questionText: "When a roommate is going through a tough time, you:",
                options: [
                    TraitOption(optionText: "Keep to myself - their problems aren't mine", scoreValue: 1),
                    TraitOption(optionText: "Offer basic support if they ask directly", scoreValue: 2),
                    TraitOption(optionText: "Check in and listen if they want to talk", scoreValue: 3),
                    TraitOption(optionText: "Actively offer help and emotional support", scoreValue: 4),
                    TraitOption(optionText: "Go all out to support them however needed", scoreValue: 5)
                ],
                category: .agreeableness
            ),
            TraitQuestionWithScore(
                questionText: "When there's a disagreement about apartment temperature:",
                options: [
                    TraitOption(optionText: "My comfort needs come first", scoreValue: 1),
                    TraitOption(optionText: "I'll adjust slightly but stand firm", scoreValue: 2),
                    TraitOption(optionText: "I'll meet halfway on a compromise", scoreValue: 3),
                    TraitOption(optionText: "I'm flexible about temperature settings", scoreValue: 4),
                    TraitOption(optionText: "I'll adapt to whatever makes others comfortable", scoreValue: 5)
                ],
                category: .agreeableness
            )
        ]

        // NEUROTICISM QUESTIONS
        static let neuroticismQuestions = [
            TraitQuestionWithScore(
                questionText: "How do you handle unexpected financial pressures?",
                options: [
                    TraitOption(optionText: "I get extremely anxious and overwhelmed", scoreValue: 5),
                    TraitOption(optionText: "I worry significantly but manage", scoreValue: 4),
                    TraitOption(optionText: "I feel moderate stress but adapt", scoreValue: 3),
                    TraitOption(optionText: "I stay relatively calm with minor worry", scoreValue: 2),
                    TraitOption(optionText: "I remain completely calm and solution-focused", scoreValue: 1)
                ],
                category: .neuroticism
            ),
            TraitQuestionWithScore(
                questionText: "How do you react when living spaces become messy?",
                options: [
                    TraitOption(optionText: "I get extremely stressed and must clean immediately", scoreValue: 5),
                    TraitOption(optionText: "I feel noticeably anxious until it's addressed", scoreValue: 4),
                    TraitOption(optionText: "I'm somewhat bothered but can manage", scoreValue: 3),
                    TraitOption(optionText: "I notice but remain mostly unbothered", scoreValue: 2),
                    TraitOption(optionText: "I'm completely relaxed regardless of mess", scoreValue: 1)
                ],
                category: .neuroticism
            ),
            TraitQuestionWithScore(
                questionText: "When a roommate is late returning home:",
                options: [
                    TraitOption(optionText: "I imagine worst-case scenarios and panic", scoreValue: 5),
                    TraitOption(optionText: "I feel worried and check in multiple times", scoreValue: 4),
                    TraitOption(optionText: "I notice and might text once to check", scoreValue: 3),
                    TraitOption(optionText: "I'm aware but not particularly concerned", scoreValue: 2),
                    TraitOption(optionText: "I don't track others' schedules at all", scoreValue: 1)
                ],
                category: .neuroticism
            ),
            TraitQuestionWithScore(
                questionText: "How do you handle criticism about shared living habits?",
                options: [
                    TraitOption(optionText: "I take it very personally and get upset", scoreValue: 5),
                    TraitOption(optionText: "I feel defensive but try to listen", scoreValue: 4),
                    TraitOption(optionText: "I'm initially uncomfortable but consider it", scoreValue: 3),
                    TraitOption(optionText: "I can usually take feedback constructively", scoreValue: 2),
                    TraitOption(optionText: "I welcome all feedback as an opportunity", scoreValue: 1)
                ],
                category: .neuroticism
            )
        ]

        // Method to get random questions from each category
        static func getRandomQuestionSet(questionsPerCategory: Int = 2) -> [TraitQuestionWithScore] {
            var randomQuestions: [TraitQuestionWithScore] = []
            
            // Get random questions from each category
            randomQuestions.append(contentsOf: opennessQuestions.shuffled().prefix(questionsPerCategory))
            randomQuestions.append(contentsOf: conscientiousnessQuestions.shuffled().prefix(questionsPerCategory))
            randomQuestions.append(contentsOf: extraversionQuestions.shuffled().prefix(questionsPerCategory))
            randomQuestions.append(contentsOf: agreeablenessQuestions.shuffled().prefix(questionsPerCategory))
            randomQuestions.append(contentsOf: neuroticismQuestions.shuffled().prefix(questionsPerCategory))
            
            return randomQuestions
        }

        // Use this instead of the static property that was causing the error
        static let scoredQuestionSet: [TraitQuestionWithScore] = getRandomQuestionSet()



    }

    struct IdealTraits {

    }
}
