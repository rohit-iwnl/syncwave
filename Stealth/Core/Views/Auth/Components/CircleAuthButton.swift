//
//  CircleAuthButton.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/26/24.
//

import SwiftUI

struct CircleAuthButton: View {
    let image : String
    let action : () -> Void
    var body: some View {
        Button(action : action){
            Image(image)
                .resizable()
                .scaledToFit()
                .padding()
                .containerRelativeFrame(.horizontal, { length, _ in
                    return length/6
                })
                
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5)
        }
    }
}

#Preview {
    CircleAuthButton(image: "AuthIcons/apple") {
        
    }
    .colorInvert()
}
