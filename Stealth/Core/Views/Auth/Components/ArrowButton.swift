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
    @Binding var progress: CGFloat
    var size: CGFloat
    
    @State private var isAnimating: Bool = false
    
    var body: some View {
        ZStack {
            ProgressCircle(progress: progress, size: size, lineWidth: 3)
            
            Image(systemName: "arrow.right")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size * 0.4, height: size * 0.4)
                .foregroundColor(progress == 1.0 ? .white : .black)
                .rotationEffect(Angle(degrees: isAnimating ? -90 : 0))
        }
        .frame(width: size, height: size)
        .background(progress == 1.0 ? Color.black : Color.clear)
        .animation(.easeIn, value: progress)
        .clipShape(Circle())
        .modifier(ProgressChangeModifier(progress: progress, isAnimating: $isAnimating))
    }
}

struct ProgressChangeModifier: ViewModifier {
    let progress: CGFloat
    @Binding var isAnimating: Bool
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.onChange(of: progress) { oldValue, newValue in
                handleProgressChange(newValue: newValue)
            }
        } else {
            content.onChange(of: progress) { newValue in
                handleProgressChange(newValue: newValue)
            }
        }
    }
    
    private func handleProgressChange(newValue: CGFloat) {
        withAnimation(.easeInOut(duration: 0.5)) {
            isAnimating = (newValue == 1.0)
        }
    }
}



#Preview {
    ArrowButton(progress: .constant(0.5), size: 80)
}
