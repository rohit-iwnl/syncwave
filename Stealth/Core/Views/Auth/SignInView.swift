//
//  SignInView.swift
//  StealthKekw10$

//  Created by Rohit Manivel on 8/30/24.
//

import SwiftUI

struct SignInView: View {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    @Binding var appUser : AppUser?
    
    var body: some View {
        ZStack{
            Color(TextColors.primaryBlack.color)
                .ignoresSafeArea()
            
            VStack{
                HStack{
                    Spacer()
                    Image("Logo/white")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 48, height: 48)
                    Spacer()
                }
                .padding(.vertical)

                
                SignInSheet(
                    appUser: $appUser
                )
            }
            .padding(.horizontal)
            .foregroundStyle(TextColors.primaryWhite.color)
        }
        
    }
}


#Preview {
    SignInView(appUser: .constant(nil))
        
}
