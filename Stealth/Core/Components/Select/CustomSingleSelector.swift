//
//  SingleSelector.swift
//  Stealth
//
//  Created by Rohit Manivel on 11/2/24.
//


import SwiftUI

struct CustomSingleSelector: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Binding var selectedOptions: Set<String>
    let options: [String]
    let isScrollable: Bool  // New flag to determine layout type
    
    let lineLimit : Int
    
    private let columns = [
        GridItem(.adaptive(minimum: 80, maximum: .infinity), spacing: 10)
    ]
    
    var body: some View {
        Group {
            if isScrollable {
                scrollableLayout
            } else {
                wrappingLayout
            }
        }
    }
    
    private var scrollableLayout: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: columns, alignment: .center, spacing: 10) {
                optionButtons
            }
            .frame(height: 40)
            .padding(.leading, 5)
        }
    }
    
    private var wrappingLayout: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
            optionButtons
        }
    }
    
    private var optionButtons: some View {
        ForEach(options, id: \.self) { option in
            Button(action: {
                toggleSelection(option)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }) {
                Text(option)
                    .font(.sora(.headline, weight: (selectedOptions.contains(option) ? .medium : .regular)))
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    .foregroundColor(selectedOptions.contains(option) ? TextColors.primaryWhite.color : TextColors.primaryBlack.color)
                    .lineLimit(lineLimit)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(selectedOptions.contains(option) ? TextColors.primaryBlack.color : Color.gray.opacity(0.1))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(selectedOptions.contains(option) ? TextColors.primaryWhite.color : TextColors.primaryBlack.color, lineWidth: 1)
                    )
            }
            .sensoryFeedback(.selection, trigger: option)
        }
    }
    private func toggleSelection(_ option: String) {
        // Clear the set and add only the new selection
        selectedOptions.removeAll()
        selectedOptions.insert(option)
    }
}

struct CustomSigleSelector_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            CustomSingleSelector(selectedOptions: .constant(["2 BR"]), options: ["1 BR", "2 BR", "3 BR", "4+ BR", "Any"], isScrollable: true, lineLimit: 1)
                .previewDisplayName("Scrollable")
            
            CustomSingleSelector(selectedOptions: .constant(["2 BR"]), options: ["1 BR", "2 BR", "3 BR", "4+ BR", "Any"], isScrollable: false, lineLimit: 1)
                .previewDisplayName("Wrapping")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
