//
//  ContinueButton.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/10/24.
//

import SwiftUI

struct ContinueButton: View {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        Button {
            
        } label : {
            HStack {
                Spacer()
                
                Text("Continue")
                    .font(.sora(.title3))
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    .lineLimit(1)
                    .padding()

                Spacer()
            }
            .foregroundStyle(TextColors.primaryWhite.color)
            .background(TextColors.primaryBlack.color)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    ContinueButton()
        .padding()
}
