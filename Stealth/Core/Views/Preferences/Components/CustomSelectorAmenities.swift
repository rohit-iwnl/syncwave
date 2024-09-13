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
        FlowLayout(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 15) {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    toggleSelection(option)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }) {
                    Text(option)
                        .font(.sora(.subheadline))
                        .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                        .foregroundColor(selectedOptions.contains(option) ? .white : .black)
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
    }
}

struct FlowLayout: Layout {
    var alignment: HorizontalAlignment = .leading
    var horizontalSpacing: CGFloat = 10
    var verticalSpacing: CGFloat = 15
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, horizontalSpacing: horizontalSpacing, verticalSpacing: verticalSpacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, horizontalSpacing: horizontalSpacing, verticalSpacing: verticalSpacing)
        var itemOffset: CGPoint = .zero
        for row in result.rows {
            itemOffset.x = bounds.minX // Start from the leading edge
            for item in row {
                let itemSize = item.sizeThatFits(.unspecified)
                item.place(at: CGPoint(x: itemOffset.x, y: itemOffset.y + bounds.minY), proposal: .unspecified)
                itemOffset.x += itemSize.width + horizontalSpacing
            }
            itemOffset.y += row.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0 + verticalSpacing
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var rows: [[LayoutSubviews.Element]] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, horizontalSpacing: CGFloat, verticalSpacing: CGFloat) {
            var row: [LayoutSubviews.Element] = []
            var rowWidth: CGFloat = 0
            var rowHeight: CGFloat = 0
            
            for subview in subviews {
                let itemSize = subview.sizeThatFits(.unspecified)
                
                if rowWidth + itemSize.width > maxWidth, !row.isEmpty {
                    finalizeRow(horizontalSpacing: horizontalSpacing, verticalSpacing: verticalSpacing)
                }
                
                row.append(subview)
                rowWidth += itemSize.width + horizontalSpacing
                rowHeight = max(rowHeight, itemSize.height)
            }
            
            if !row.isEmpty {
                finalizeRow(horizontalSpacing: horizontalSpacing, verticalSpacing: verticalSpacing)
            }
            
            size.height -= verticalSpacing
            
            func finalizeRow(horizontalSpacing: CGFloat, verticalSpacing: CGFloat) {
                rows.append(row)
                size.width = max(size.width, rowWidth - horizontalSpacing)
                size.height += rowHeight + verticalSpacing
                row = []
                rowWidth = 0
                rowHeight = 0
            }
        }
    }
}


#Preview {
    CustomSelectorAmenities(selectedOptions: .constant(["Swimming Pool"]),
                            options: ["Bicycle Parking", "Swimming Pool", "Covered Parking", "Open Parking", "Smoking Area", "In-House Laundry", "Common Laundry", "Workspace", "Recreational Area", "Accessible", "Gym"])
    
}
