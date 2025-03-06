//
//  BasicInfoView.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/2/25.
//

import SwiftUI

struct BasicInfoSubmission: Codable {
    let basicInfo: [QuestionPayloadKey: String]
    let hobbies: [String]
}

struct BasicInfoView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator

    @Binding var currentPage: Int
    @Binding var totalPages: Int

    @State private var showIncompleteFieldsAlert = false
    @State private var incompleteFields: [String] = []

    @State private var selections: [QuestionPayloadKey: Set<String>] = [:]
    @State private var hobbyTags: [String] = []

    private let personalTraitQuestions = PersonalityTraitConstants.PersonalTraits.basicQuestionsSet

    var body: some View {
        VStack(spacing: 0) {
            PreferencesToolbar(
                currentPage: $navigationCoordinator.currentPage,
                totalPages: $navigationCoordinator.totalPages,
                showPages: .constant(true), onBackTap: handleBackTap
            )

            ScrollView {
                VStack(spacing: 10) {
                    HeaderSection()
                    QuestionsSection()
                    HobbiesSection()
                    ContinueButtonSection()
                }
                .padding(.horizontal, 16)
            }
            .background(Color.clear)
        }
        .alert("Please complete all fields", isPresented: $showIncompleteFieldsAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(incompleteFields.joined(separator: "\n"))
        }
    }

    private func HeaderSection() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Let's start off with the basics")
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
        .padding(.vertical)
    }

    private func QuestionsSection() -> some View {
        ForEach(personalTraitQuestions, id: \.questionText) { question in
            MultiSelectQuestionView(
                question: question,
                selectedOptions: Binding(
                    get: { selections[question.payloadKey] ?? [] },
                    set: { selections[question.payloadKey] = $0 }
                )
            )
            .padding(.vertical, 8)
        }
    }

    private func HobbiesSection() -> some View {
        TagInputView(
            headerText: "What's your hobbies",
            placeholderText: "Enter your hobbies here",
            tags: $hobbyTags
        )
        .padding(.vertical, 8)
    }

    private func ContinueButtonSection() -> some View {
        Button(action: validateAndContinue) {
            Text("Continue")
                .font(.sora(.headline, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(TextColors.primaryBlack.color)
                .cornerRadius(12)
        }
        .padding(.vertical, 16)
    }

    private func validateAndContinue() {
        incompleteFields = []

        for question in personalTraitQuestions {
            if selections[question.payloadKey]?.isEmpty ?? true {
                incompleteFields.append("• \(question.payloadKey.displayText)")
            }
        }

        if hobbyTags.isEmpty {
            incompleteFields.append("• Hobbies")
        }

        if incompleteFields.isEmpty {
            withAnimation {
                navigationCoordinator.incrementPage()
                debugPrintSelections()
                createPayload()
                navigationCoordinator.path.append(NavigationDestinations.personalTraitsFirstScreen)
            }
        } else {
            showIncompleteFieldsAlert = true
        }
    }

    private func debugPrintSelections() {
        for key in selections.keys {
            print("Question: \(key)")
            let selectedOptions = selections[key]
            if selectedOptions?.count == 1 {
                print("Selected Option: \(selectedOptions?.first ?? "")")
            } else {
                print("Selected Options: [\(selectedOptions?.joined(separator: ", ") ?? "")]")
            }
        }
        print("Hobbies: [\(hobbyTags.joined(separator: ", "))]")
    }

    private func createPayload() {
        var payloadDict = [QuestionPayloadKey: String]()
        
        for question in personalTraitQuestions {
            guard let selectedOption = selections[question.payloadKey]?.first else {
                payloadDict[question.payloadKey] = "Undefined"
                continue
            }
            payloadDict[question.payloadKey] = selectedOption
        }
        
        let submission = BasicInfoSubmission(basicInfo: payloadDict, hobbies: hobbyTags)
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let jsonData = try encoder.encode(submission)
            print(String(data: jsonData, encoding: .utf8) ?? "")
        } catch {
            print("Encoding error: \(error.localizedDescription)")
        }
    }


    private func handleBackTap() {
        withAnimation {
            if !navigationCoordinator.path.isEmpty {
                navigationCoordinator.path.removeLast()
                navigationCoordinator.decrementPage()
            } else {
                dismiss()
            }
        }
    }
}

#Preview {
    BasicInfoView(currentPage: .constant(1), totalPages: .constant(3))
        .environmentObject(NavigationCoordinator())
}
