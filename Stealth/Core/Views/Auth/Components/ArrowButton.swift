//
//  ArrowButton.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/26/24.
//

import SwiftUI

import SwiftUI

struct ProgressCircle: View {
    var progress: CGFloat // Progress should be between 0.0 and 1.0
    var size: CGFloat
    var lineWidth: CGFloat
    
    var body: some View {
        ZStack {
            // Outer Circle - Black Border
            Circle()
                .stroke(Color.black, lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            // Middle Circle - Progress Circle
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: lineWidth))
                .foregroundColor(.black)
                .rotationEffect(Angle(degrees: -90))
                .animation(.linear, value: progress)
                .frame(width: size - lineWidth * 2, height: size - lineWidth * 2)
            
            // Innermost Circle - Background Circle
            Circle()
                .stroke(Color.black)
                .fill(.clear)
                .frame(width: size - lineWidth * 3, height: size - lineWidth * 3)
            
        }
        .frame(width: size, height: size)
    }
}
struct ArrowButton: View {
    @Binding var progress: CGFloat // Binding to control the progress externally
    var size: CGFloat
    
    var body: some View {
        ZStack {
            ProgressCircle(progress: progress, size: size, lineWidth: 3)
            
            Image(systemName: "arrow.right")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size * 0.4, height: size * 0.4)
                .rotationEffect(Angle(degrees: progress == 1.0 ? -90 : 0)) // Rotate the arrow when complete
                .animation(.easeInOut(duration: 0.75), value: progress)
                .foregroundColor(progress == 1.0 ? .white : .black) // Change color when complete
                .scaleEffect(progress == 1.0 ? 1.0 : 1.0) // Ensure size does not change
        }
        .frame(width: size, height: size) // Fixed size for the entire component
        .background(progress == 1.0 ? Color.black : Color.clear) // Fill background when complete
        .clipShape(Circle())
        .animation(.easeInOut(duration: 1.25), value: progress) // Disable any implicit animation for background change
    }
}


#Preview {
    ArrowButton(progress: .constant(0.5), size: 80)
}
