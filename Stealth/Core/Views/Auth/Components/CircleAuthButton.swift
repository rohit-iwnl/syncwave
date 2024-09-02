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
                
        }
    }
}

#Preview {
    CircleAuthButton(image: "AuthIcons/apple") {
        
    }
    .colorInvert()
}
