//
//  CustomSlider.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/12/24.
//

import SwiftUI
import Sliders

struct CustomSlider: View {
    @Binding var defaultMinValue: Double
    @Binding var defaultMaxValue: Double
    
    var minValue: Double
    var maxValue: Double
    
    var steps: Double.Stride
    
    @State private var isDragging = false
    
    var body: some View {
        RangeSlider(range: Binding(
            get: { defaultMinValue...defaultMaxValue },
            set: { newValue in
                defaultMinValue = newValue.lowerBound
                defaultMaxValue = newValue.upperBound
                if isDragging {
                    provideHapticFeedback()
                }
            }
        ), in: minValue...maxValue, step: steps)
        .rangeSliderStyle(
            HorizontalRangeSliderStyle(
                track: HorizontalRangeTrack(
                    view: Capsule().foregroundColor(TextColors.primaryBlack.color)
                )
                .background(Capsule().foregroundColor(.gray.opacity(0.4)))
                .frame(height: 6),
                lowerThumb: RoundedRectangle(cornerRadius: 4).foregroundStyle(TextColors.primaryBlack.color),
                upperThumb: RoundedRectangle(cornerRadius: 4).foregroundStyle(TextColors.primaryBlack.color),
                lowerThumbSize: CGSize(width: 20, height: 20),
                upperThumbSize: CGSize(width: 20, height: 20)
            )
            
        )
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isDragging = true
                }
                .onEnded { _ in
                    isDragging = false
                }
        )
    }
    
    private func provideHapticFeedback() {
        let impact = UIImpactFeedbackGenerator(style: .rigid)
        impact.impactOccurred()
    }
}
