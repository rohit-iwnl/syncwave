//
//  TagView.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/2/25.
//

import SwiftUI

struct TagView: View {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    let tag: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Text(tag)
                .font(.sora(.subheadline, weight: .medium))
                .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                .foregroundColor(.black)

            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black.opacity(0.5), lineWidth: 1)
        )
        .fixedSize()
    }
}

#Preview {
    TagView(tag: "Example Tag", onRemove: {})
        
}
