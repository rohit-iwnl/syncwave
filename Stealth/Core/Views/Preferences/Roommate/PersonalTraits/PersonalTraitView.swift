//
//  PersonalTraitView.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/2/25.
//

import SwiftUI

struct PersonalTraitView: View {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var navigationCoordinator : NavigationCoordinator
    
    @Binding var currentPage: Int
    @Binding var totalPages: Int
    
    @State private var showSkipAlert : Bool = false
    @State private var showIncompleteFieldsAlert = false
    @State private var incompleteFields: [String] = []
    
    // Add state for tracking selections
    @State private var selections: [String: Set<String>] = [:]
    
    // Get the questions from PersonalityTraitConstants
    private let personalTraitQuestions = PersonalityTraitConstants.PersonalTraits.questionSet
    
    var body: some View {
        VStack {
            VStack {
                PreferencesToolbar(currentPage: $navigationCoordinator.currentPage, totalPages: $navigationCoordinator.totalPages, showPages: .constant(true), onBackTap: handleBackTap) {
                    showSkipAlert = true
                }
                
                ScrollView {
                    VStack(spacing: 32) {
                        //MARK : - Header
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Let's get to know basics about you")
                                .font(.sora(.largeTitle, weight: .semibold))
                                .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                .lineLimit(3)
                            
                            Text("This helps us find the best matches for you")
                                .font(.sora(.callout, weight: .regular))
                                .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                .lineLimit(2)
                                .foregroundStyle(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // MARK : - Non scored questions
                        VStack(spacing: 24) {
                            ForEach(personalTraitQuestions, id: \.questionText) { question in
                                MultiSelectQuestionView(
                                    question: question,
                                    selectedOptions: Binding(
                                        get: { selections[question.questionText] ?? [] },
                                        set: { selections[question.questionText] = $0 }
                                    )
                                )
                            }
                        }
                        
                        Spacer()
                        
                        // Continue Button
                        Button(action: {
                            // Validate and continue
                            validateAndContinue()
                        }) {
                            Text("Continue")
                                .font(.sora(.headline, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(TextColors.primaryBlack.color)
                                .cornerRadius(12)
                        }
                        .padding(.bottom, 16)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .alert(isPresented: $showSkipAlert) {
            Alert(
                title: Text("Skip personal traits preferences"),
                message: Text("Are you sure? This may lead to fewer hyperpersonalized matches. Don't worry you can complete it later in settings"),
                primaryButton: .default(Text("Proceed")) {
                    handleSkip()
                },
                secondaryButton: .cancel()
            )
        }
        .alert("Please complete all fields", isPresented: $showIncompleteFieldsAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(incompleteFields.joined(separator: "\n"))
        }
    }
    
    private func validateAndContinue() {
        incompleteFields = []
        
        for question in personalTraitQuestions {
            if selections[question.questionText]?.isEmpty ?? true {
                incompleteFields.append("• \(question.questionText)")
            }
        }
        
        if incompleteFields.isEmpty {
            // All fields are complete, proceed to next screen
            withAnimation {
                navigationCoordinator.currentPage += 1
                // Navigate to next screen
                
                for key in selections.keys {
                    print("Question: \(key)")
                    let selectedOptions = selections[key]
                    if selectedOptions?.count == 1 {
                        print("Selected Option: \(selectedOptions?.first ?? "")")
                    } else {
                        print("Selected Options: [\(selectedOptions?.joined(separator: ", ") ?? "")]")
                    }
                }
                
                
                
                // navigationCoordinator.path.append(...)
            }
        } else {
            showIncompleteFieldsAlert = true
        }
    }
    
    private func handleBackTap() {
        withAnimation {
            if !navigationCoordinator.path.isEmpty {
                navigationCoordinator.path.removeLast()
                navigationCoordinator.currentPage -= 1
            } else {
                dismiss()
            }
        }
    }
    
    private func handleSkip() {
        // Handle skip logic
        withAnimation {
            navigationCoordinator.currentPage += 1
            // Navigate to next screen
            // navigationCoordinator.path.append(...)
        }
    }
}

#Preview {
    PersonalTraitView(currentPage: .constant(1), totalPages: .constant(3))
        .environmentObject(NavigationCoordinator())
}
