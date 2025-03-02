//
//  FlowLayout.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/2/25.
//

import SwiftUI

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
        
        var yOffset = bounds.minY
        
        for (rowIndex, row) in result.rows.enumerated() {
            let rowHeight = row.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
            var xOffset = bounds.minX
            
            for item in row {
                let itemSize = item.sizeThatFits(.unspecified)
                item.place(at: CGPoint(x: xOffset, y: yOffset), proposal: .unspecified)
                xOffset += itemSize.width + horizontalSpacing
            }
            
            // Only add vertical spacing between rows, not after the last row
            if rowIndex < result.rows.count - 1 {
                yOffset += rowHeight + verticalSpacing
            } else {
                yOffset += rowHeight
            }
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var rows: [[LayoutSubviews.Element]] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, horizontalSpacing: CGFloat, verticalSpacing: CGFloat) {
            var row: [LayoutSubviews.Element] = []
            var rowWidth: CGFloat = 0
            var rowHeight: CGFloat = 0
            var totalHeight: CGFloat = 0
            
            for subview in subviews {
                let itemSize = subview.sizeThatFits(.unspecified)
                
                // If adding this item would exceed the max width, finalize the current row
                if rowWidth + itemSize.width > maxWidth && !row.isEmpty {
                    // Add the current row height to the total height
                    totalHeight += rowHeight
                    
                    // Add vertical spacing if this isn't the first row
                    if !rows.isEmpty {
                        totalHeight += verticalSpacing
                    }
                    
                    // Store the row and reset row variables
                    rows.append(row)
                    size.width = max(size.width, rowWidth - horizontalSpacing)
                    row = []
                    rowWidth = 0
                    rowHeight = 0
                }
                
                // Add the item to the current row
                row.append(subview)
                rowWidth += itemSize.width + horizontalSpacing
                rowHeight = max(rowHeight, itemSize.height)
            }
            
            // Handle the last row if it's not empty
            if !row.isEmpty {
                totalHeight += rowHeight
                
                // Add vertical spacing if this isn't the first row
                if !rows.isEmpty {
                    totalHeight += verticalSpacing
                }
                
                rows.append(row)
                size.width = max(size.width, rowWidth - horizontalSpacing)
            }
            
            size.height = totalHeight
        }
    }
}
