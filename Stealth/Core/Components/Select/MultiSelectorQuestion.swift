//
//  MultiSelector.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/2/25.
//

import SwiftUI

struct MultiSelectQuestionView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @State private var selectedOptions: Set<String> = []
    let question: TraitQuestionWithoutScore
    var onSelectionsChanged: ((Set<String>) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            HStack {

                Text(question.questionText)
                    .font(.sora(.headline, weight: .bold))
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    .lineLimit(3)
                    .foregroundStyle(TextColors.primaryBlack.color)
                Spacer()
            }
            FlowLayout(
                alignment: .leading, horizontalSpacing: 10, verticalSpacing: 10
            ) {
                ForEach(question.options, id: \.self) { option in
                    Button(action: {
                        handleSelection(option)
                    }) {
                        Text(option)
                            .font(.sora(.subheadline))
                            .minimumScaleFactor(
                                dynamicTypeSize.customMinScaleFactor
                            )
                            .foregroundColor(
                                selectedOptions.contains(option)
                                    ? .white : .black
                            )
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        selectedOptions.contains(option)
                                            ? TextColors.primaryBlack.color
                                            : Color.gray.opacity(0.1))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        selectedOptions.contains(option)
                                            ? TextColors.primaryWhite.color
                                            : TextColors.primaryBlack.color,
                                        lineWidth: 1)
                            )
                    }
                    .padding(.vertical, 4)
                    .fixedSize()
                }
            }
        }
    }

    private func handleSelection(_ optionText: String) {
        if selectedOptions.contains(optionText) {
            selectedOptions.remove(optionText)
        } else {
            // If single select mode, clear other selections first
            if !question.allowMutlipleSelection {
                selectedOptions.removeAll()
            }
            selectedOptions.insert(optionText)
        }
        onSelectionsChanged?(selectedOptions)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

#Preview {
    let genderQuestion = TraitQuestionWithoutScore(
        questionText: "Preferred gender of roommate",
        options: ["Male", "Female", "Any"],
        allowMultipleSelection: false
    )

    let interestsQuestion = TraitQuestionWithoutScore(
        questionText: "Select all that apply:",
        options: [
            "Option 1",
            "Option 2 with longer text",
            "Third choice",
            "Fourth selection item",
            "Fifth alternative",
        ],
        allowMultipleSelection: true
    )

    VStack(spacing: 40) {
        MultiSelectQuestionView(question: genderQuestion)
        MultiSelectQuestionView(question: interestsQuestion)
    }
    .padding()
}
