//
//  AlignmentExtension.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/25/24.
//

import SwiftUI

extension View {
    @ViewBuilder
    
    func alignment(_ alignment : FrameAlignment) -> some View {
        switch alignment {
        case .top:
            self.frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .top)
        case .bottom:
            self.frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .bottom)
        case .leading:
            self.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        case .trailing:
            self.frame(maxWidth : .infinity, alignment: .trailing)
        case .center:
            self.frame(maxWidth: .infinity, alignment: .center)
        case .topRight:
            self.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .topTrailing)
        case .topLeft:
            self.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .topLeading)
        case .bottomLeft:
            self.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .bottomLeading)
        case .bottomRight:
            self.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .bottomTrailing)
        }
    }
}
