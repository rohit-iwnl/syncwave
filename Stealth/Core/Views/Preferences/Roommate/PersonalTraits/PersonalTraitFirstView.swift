//
//  PersonalTraitFirstView.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/4/25.
//

import SwiftUI

struct PersonalTraitFirstView: View {

    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator

    //    @State private var showSkipAlert: Bool = false
    @State private var showIncompleteFieldsAlert = false
    @State private var incompleteFields: [String] = []

    @Binding var currentPage: Int
    @Binding var totalPages: Int
    
    
    private let scoredQuestions : [TraitQuestionWithScore] = PersonalityTraitConstants.PersonalTraits.getRandomQuestionSet(questionsPerCategory: 1)
    
    @State private var selectedOptions: [String: TraitOption?] = [:]
    
    @State private var isLoading : Bool = false

    
    
    private func handleBackTap() {
        navigationCoordinator.decrementPage()
    }
    
    
    
    

    var body: some View {
        VStack(spacing: 0) {
            PreferencesToolbar(
                currentPage: $navigationCoordinator.currentPage,
                totalPages: $navigationCoordinator.totalPages,
                showPages: .constant(true), onBackTap: handleBackTap
            ) {
                
            }
            
            ScrollView {
                VStack(spacing: 10) {
                    // Header Section
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Let's get to know you")
                            .font(.sora(.largeTitle, weight: .semibold))
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                            .lineLimit(3)
                        
                        Text("These questions help us match you with compatible roommates")
                            .font(.sora(.callout, weight: .regular))
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                            .lineLimit(2)
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical,8)
                    
                    
                    ForEach(scoredQuestions, id: \.self.id) { question in
                        ScoredMultiSelectQuestionView(
                            question: question,
                            selectedOption: Binding(
                                get: { selectedOptions[question.id] ?? nil },
                                set: { selectedOptions[question.id] = $0 }
                            )
                        )
                        .padding(.vertical, 8)
                        .listStyle(.automatic)
                    }
                    
                    Divider()
                        .padding(.vertical)
                    ContinueButton(isEnabled: true, isLoading: isLoading) {
                        
                    }
                    
                    
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    PersonalTraitFirstView(currentPage: .constant(1), totalPages: .constant(5))
        .environmentObject(NavigationCoordinator())
}
