//
//  PreferencesToolbar.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/9/24.
//

import SwiftUI

struct PreferencesToolbar: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var currentPage: Int
    @Binding var totalPages: Int
    
    @Binding var showSkipButton : Bool
    
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    if(currentPage == 0){
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        currentPage -= 1
                    }
                    
                }) {
                    Image(systemName: "chevron.left")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(8)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                
                Spacer()
            }
            
            HStack(spacing: 4) {
                ForEach(0..<totalPages, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.black : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            
            if showSkipButton {
                HStack{
                    Spacer()
                    
                    Button {
                        
                    } label : {
                        Text("Skip")
                            .font(.sora(.headline))
                            .foregroundStyle(.black)
                            .padding(.horizontal)
                            .padding(.vertical,8)
                    }
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(.black, lineWidth: 2))
                    .animation(.easeInOut, value: showSkipButton)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

#Preview {
    VStack{
        PreferencesToolbar(currentPage: .constant(3), totalPages: .constant(4), showSkipButton: .constant(true))
    }
    .background(.white)
}

