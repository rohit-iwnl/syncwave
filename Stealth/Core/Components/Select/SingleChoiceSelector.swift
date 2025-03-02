//
//  SwiftUIView.swift
//  Stealth
//
//  Created by Rohit Manivel on 2/28/25.
//

import SwiftUI

struct SingleChoiceSelector: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    let questionText: String

    // Options for the selector
    let options: [String]

    @Binding var selectedOption: Set<String>

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(questionText)
                    .font(.sora(.subheadline, weight: .regular))
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)

                Spacer()
            }
            
            // Options View Here
            CustomSingleSelector(selectedOptions: $selectedOption, options: options, isScrollable: false, lineLimit: 3)
        }
    }
}

#Preview {
    SingleChoiceSelector(
        questionText: "What is your favorite color?",
        options: [
            "Red", "Blue", "Green", "Yellow",
        ],
        selectedOption: .constant(["Red"])
    )
    .padding()
}
