//
//  TraitQuestionSelectorView.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/1/25.
//

import SwiftUI

struct TraitQuestionSelectorView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @State private var selectedAnswer: TraitOption?
    @State private var maxHeight: CGFloat = 50
    let options: [TraitOption]
    var onSelectionChanged: ((Int) -> Void)?
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Quesiton Text")
                    .font(.sora(.headline, weight: .bold))
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    .lineLimit(3)
                    .foregroundStyle(TextColors.primaryBlack.color)
                
                Spacer()
            }
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible(minimum: 100), spacing: 12),
                    GridItem(.flexible(minimum: 100), spacing: 12)
                ],
                alignment: .leading,
                spacing: 12
            ) {
                ForEach(options, id: \.optionText) { option in
                    Button(action: {
                        handleSelection(option)
                    }) {
                        Text(option.optionText)
                            .font(.sora(.body, weight: selectedAnswer == option ? .medium : .regular))
                            .foregroundColor(selectedAnswer == option ? TextColors.primaryWhite.color : TextColors.primaryBlack.color)
                            .lineLimit(3)
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                            .multilineTextAlignment(.leading)
                            .padding(12)
                            .frame(maxWidth: .infinity, minHeight: maxHeight, alignment: .leading)
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .onAppear {
                                            if geo.size.height > maxHeight {
                                                maxHeight = geo.size.height
                                            }
                                        }
                                        .onChange(of: geo.size.height) { newHeight in
                                            if newHeight > maxHeight {
                                                maxHeight = newHeight
                                            }
                                        }
                                }
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedAnswer == option ? Color.black : Color.gray.opacity(0.1))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(selectedAnswer == option ? Color.white : Color.gray, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    .sensoryFeedback(.selection, trigger: selectedAnswer)
                }
            }
        }
    }
    
    private func handleSelection(_ option: TraitOption) {
        if selectedAnswer == option {
            selectedAnswer = nil
            onSelectionChanged?(0)
        } else {
            selectedAnswer = option
            onSelectionChanged?(option.scoreValue)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}




#Preview {
    
    // Example
    let options : [TraitOption] = [
        TraitOption(optionText: "Answer1", scoreValue: 1),
        TraitOption(optionText: "Answer2", scoreValue: 2),
        TraitOption(optionText: "Answer3", scoreValue: 3),
        TraitOption(optionText: "Answer4", scoreValue: 4),
        TraitOption(optionText: "Answer5", scoreValue: 5),
    ]
    
    TraitQuestionSelectorView(options: options)
        .padding()
}
