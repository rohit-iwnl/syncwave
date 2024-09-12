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
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

#Preview {
    VStack{
        PreferencesToolbar(currentPage: .constant(0), totalPages: .constant(3))
    }
    .background(.black)
}

