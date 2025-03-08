//
//  BasicInfoView.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/2/25.
//

import SwiftUI

struct BasicInfoSubmission: Codable {
    let supabase_id : String
    let basicInfo: [String: String]
    let interests: [String]

    init(supabase_id : String, basicInfo: [QuestionPayloadKey: String], interests: [String]) {
        self.supabase_id = supabase_id
        self.basicInfo = Dictionary(uniqueKeysWithValues: basicInfo.map { ($0.rawValue, $1) })
        self.interests = interests
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(supabase_id, forKey: .supabase_id)
        try container.encodeIfPresent(basicInfo, forKey: .basicInfo)
        try container.encodeIfPresent(interests, forKey: .interests)
    }
}





struct BasicInfoView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @EnvironmentObject var appUserStateManager : AppUserManger
    
    @State private var isLoading : Bool = false

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
            headerText: "What's your interests",
            placeholderText: "Enter your interests here",
            tags: $hobbyTags
        )
        .padding(.vertical, 8)
    }

    private func ContinueButtonSection() -> some View {
        ContinueButton(isEnabled: true, isLoading: isLoading) {
            validateAndContinue()
        }
    }

    private func validateAndContinue() {
        isLoading = true
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
                Task {
                                await createPayload()
                            }
                navigationCoordinator.path.append(NavigationDestinations.personalTraitsFirstScreen)
            }
        } else {
            isLoading = false
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

    private func createPayload() async {
        var payloadDict = [QuestionPayloadKey: String]()
                
        for key in QuestionPayloadKey.allCases {
            if let selectedOption = selections[key]?.first {
                payloadDict[key] = selectedOption.lowercased()
            } else {
                payloadDict[key] = "undefined"
            }
        }
        guard let supabase_id = appUserStateManager.appUser?.uid?.lowercased() else {
            print("Supabase ID is nil")
            return
        }
        
        let submission = BasicInfoSubmission(supabase_id: supabase_id, basicInfo: payloadDict, interests: hobbyTags)
        
        do {
            try await NetworkService.shared.storeUserTraits(basicInfoSubmission: submission, supabaseID: supabase_id)
            isLoading = false
        } catch {
            isLoading = false
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
        .environmentObject(AppUserManger())
}
