//
//  SignInView.swift
//  StealthKekw10$

//  Created by Rohit Manivel on 8/30/24.
//

import SwiftUI

struct SignInView: View {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        ZStack{
            Color(TextColors.primaryBlack.color)
                .ignoresSafeArea()
            
            VStack{
                HStack{
                    Spacer()
                    Image("Logo/white")
                    Spacer()
                }
                .padding(.vertical)
                
                SignInSheet(
                    appUser: .constant(nil)
                )
            }
            .padding(.horizontal)
            .foregroundStyle(TextColors.primaryWhite.color)
        }
        
    }
}

#Preview {
    SignInView()
        
}
