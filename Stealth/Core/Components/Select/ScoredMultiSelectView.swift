//
//  ScoredMultiSelectView.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/4/25.
//

import SwiftUI


struct ScoredMultiSelectQuestionView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    let question: TraitQuestionWithScore
    var onSelectionChanged: ((TraitOption) -> Void)?
    @Binding var selectedOption: TraitOption?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(question.questionText)
                    .font(.sora(.title3, weight: .semibold))
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    .lineLimit(3)
                    .foregroundStyle(TextColors.primaryBlack.color)
                Spacer()
            }
            
            FlowLayout(
                alignment: .leading, horizontalSpacing: 10, verticalSpacing: 15
            ) {
                ForEach(question.options, id: \.optionText) { option in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            handleSelection(option)
                        }
                    }) {
                        Text(option.optionText)
                            .font(.sora(.subheadline))
                            .minimumScaleFactor(
                                dynamicTypeSize.customMinScaleFactor
                            )
                            .lineLimit(3)
                            .multilineTextAlignment(.center)
                            .foregroundColor(
                                selectedOption?.optionText == option.optionText
                                    ? .white : .black
                            )
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .frame(maxWidth: .infinity) // Constrain width
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        selectedOption?.optionText == option.optionText
                                            ? TextColors.primaryBlack.color
                                            : Color.gray.opacity(0.1)
                                    )
                                    .animation(.easeInOut(duration: 0.2), value: selectedOption?.optionText == option.optionText)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        selectedOption?.optionText == option.optionText
                                            ? TextColors.primaryWhite.color
                                            : TextColors.primaryBlack.color,
                                        lineWidth: 1
                                    )
                                    .animation(.easeInOut(duration: 0.2), value: selectedOption?.optionText == option.optionText)
                            )
                    }
                    .buttonStyle(ScaleButtonStyle()) // Add a custom button style for tap animation
                    .padding(.vertical, 4)
                    
                    
                }
            }
            .frame(maxWidth: .infinity) // Ensure the layout respects screen boundaries
        }
    }

    private func handleSelection(_ option: TraitOption) {
        // For scored questions, we only allow single selection
        selectedOption = option
        onSelectionChanged?(option)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

#Preview {
    let scoredQuestion = TraitQuestionWithScore(
        questionText: "How do you handle unexpected changes to plans?",
        options: [
            TraitOption(optionText: "I strongly prefer sticking to established routines", scoreValue: 1),
            TraitOption(optionText: "I'm somewhat uncomfortable with sudden changes", scoreValue: 2),
            TraitOption(optionText: "I can adapt if necessary", scoreValue: 3),
            TraitOption(optionText: "I'm usually open to new approaches", scoreValue: 4),
            TraitOption(optionText: "I thrive on spontaneity and new experiences", scoreValue: 5)
        ],
        category: .openness
    )

    return ScoredMultiSelectQuestionView(question: scoredQuestion, selectedOption: .constant(nil))
        .padding()
}
