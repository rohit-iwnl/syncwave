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
    let options: [TraitOption]
    var onSelectionChanged: ((Int) -> Void)?  // Callback with selected score
    
    
    
    
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            
            // question goes here
            HStack{
                Text("Quesiton Text")
                    .font(.sora(.headline, weight: .bold))
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    .lineLimit(2)
                    .foregroundStyle(TextColors.primaryBlack.color)
                
                Spacer()
            }
            
            
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 100, maximum: 200), spacing: 12)
                ],
                spacing: 12
            ) {
                ForEach(options, id: \.optionText) { option in
                    Button(action: {
                        handleSelection(option)
                    }) {
                        Text(option.optionText)
                            .font(.sora(.body, weight: selectedAnswer == option ? .medium : .regular))
                            .foregroundColor(selectedAnswer == option ? TextColors.primaryWhite.color : TextColors.primaryBlack.color)
                            .lineLimit(2)
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
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
