//
//  CustomMultipleOptions.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/13/24.
//

import SwiftUI

struct CustomSelector: View {
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
            .frame(height: 40) // Adjust this value as needed
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
                    .font(.sora(.subheadline))
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
        if selectedOptions.contains(option) {
            selectedOptions.remove(option)
        } else {
            if option == "Any" {
                selectedOptions.removeAll()
            } else if selectedOptions.contains("Any") {
                selectedOptions.remove("Any")
            }
            selectedOptions.insert(option)
        }
    }
}

struct CustomSelector_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomSelector(selectedOptions: .constant(["2 BR"]), options: ["1 BR", "2 BR", "3 BR", "4+ BR", "Any"], isScrollable: true, lineLimit: 1)
                .previewDisplayName("Scrollable")
            
            CustomSelector(selectedOptions: .constant(["2 BR"]), options: ["1 BR", "2 BR", "3 BR", "4+ BR", "Any"], isScrollable: false, lineLimit: 1)
                .previewDisplayName("Wrapping")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
