//
//  MultiSelector.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/2/25.
//

import SwiftUI

struct MultiSelectQuestionView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    let question: TraitQuestionWithoutScore
    var onSelectionsChanged: ((Set<String>) -> Void)?
    @Binding var selectedOptions: Set<String>

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(question.questionText)
                    .font(.sora(.headline, weight: .medium))
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
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            handleSelection(option)
                        }
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
                                            : Color.gray.opacity(0.1)
                                    )
                                    .animation(.easeInOut(duration: 0.2), value: selectedOptions.contains(option))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        selectedOptions.contains(option)
                                            ? TextColors.primaryWhite.color
                                            : TextColors.primaryBlack.color,
                                        lineWidth: 1
                                    )
                                    .animation(.easeInOut(duration: 0.2), value: selectedOptions.contains(option))
                            )
                    }
                    .buttonStyle(ScaleButtonStyle()) // Add a custom button style for tap animation
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
            if !question.allowMultipleSelection {
                selectedOptions.removeAll()
            }
            selectedOptions.insert(optionText)
        }
        onSelectionsChanged?(selectedOptions)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

// Custom button style for scale animation on press
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}


#Preview {
    let genderQuestion = TraitQuestionWithoutScore(
        questionText: "Preferred gender of roommate",
        payloadKey: .preferredGender,
        options: ["Male", "Female", "Any"],
        allowMultipleSelection: false
    )

    let interestsQuestion = TraitQuestionWithoutScore(
        questionText: "Select all that apply:",
        payloadKey: .preferredGender,
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
        MultiSelectQuestionView(question: genderQuestion, selectedOptions: .constant([]))
        MultiSelectQuestionView(question: interestsQuestion, selectedOptions: .constant([]))
    }
    .padding()
}
