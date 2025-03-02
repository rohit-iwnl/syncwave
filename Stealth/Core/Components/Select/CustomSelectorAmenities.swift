//
//  CustomSelectorAmenities.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/13/24.
//

import SwiftUI

struct CustomSelectorAmenities: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    @Binding var selectedOptions: Set<String>
    let options: [String]
    
    var body: some View {
        FlowLayout(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 5) {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    toggleSelection(option)
                }) {
                    Text(option)
                        .font(.sora(.subheadline))
                        .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                        .foregroundColor(selectedOptions.contains(option) ? TextColors.primaryWhite.color : TextColors.primaryBlack.color)
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
                .padding(.vertical, 4)
                .fixedSize()
            }
            
        }
    }
    
    private func toggleSelection(_ option: String) {
        if selectedOptions.contains(option) {
            selectedOptions.remove(option)
        } else {
            selectedOptions.insert(option)
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

#Preview {
    CustomSelectorAmenities(selectedOptions: .constant(["Swimming Pool"]),
                            options: ["Bicycle Parking", "Swimming Pool", "Covered Parking", "Open Parking", "Smoking Area", "In-House Laundry", "Common Laundry", "Workspace", "Recreational Area", "Accessible", "Gym"])
    
}
