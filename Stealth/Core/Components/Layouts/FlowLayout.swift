import SwiftUI

struct FlowLayout: Layout {
    var alignment: HorizontalAlignment = .leading
    var horizontalSpacing: CGFloat = 10
    var verticalSpacing: CGFloat = 15
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var totalHeight: CGFloat = 0
        var currentRowWidth: CGFloat = 0
        var currentRowHeight: CGFloat = 0
        
        for subview in subviews {
            let itemSize = subview.sizeThatFits(.unspecified)
            
            if currentRowWidth + itemSize.width + horizontalSpacing > maxWidth {
                // New row
                totalHeight += currentRowHeight + verticalSpacing
                currentRowWidth = 0
                currentRowHeight = 0
            }
            
            currentRowWidth += itemSize.width + horizontalSpacing
            currentRowHeight = max(currentRowHeight, itemSize.height)
        }
        
        // Add last row height
        totalHeight += currentRowHeight
        
        return CGSize(
            width: maxWidth,
            height: totalHeight
        )
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var currentRowHeight: CGFloat = 0
        
        for subview in subviews {
            let itemSize = subview.sizeThatFits(.unspecified)
            
            if x + itemSize.width > bounds.maxX {
                // New row
                x = bounds.minX
                y += currentRowHeight + verticalSpacing
                currentRowHeight = 0
            }
            
            subview.place(
                at: CGPoint(x: x, y: y),
                anchor: .topLeading,
                proposal: .init(
                    width: min(itemSize.width, bounds.width),
                    height: itemSize.height
                )
            )
            
            x += itemSize.width + horizontalSpacing
            currentRowHeight = max(currentRowHeight, itemSize.height)
        }
    }
}
