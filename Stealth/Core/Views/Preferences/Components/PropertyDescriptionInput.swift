//
//  SmartWrite.swift
//  Stealth
//
//  Created by Rohit Manivel on 11/2/24.
//

import SwiftUI

struct PropertyDescriptionInput: View {
    @Binding var description: String
    let maxCharacters: Int = 350
    @State private var showSmartWrite: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Write about your property here*")
                .font(.sora(.body))
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $description)
                    .font(.sora(.body))
                    .frame(height: 150)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3))
                    )
                
                if description.isEmpty {
                    Text("Describe briefly about your property.")
                        .font(.sora(.body))
                        .foregroundColor(.gray.opacity(0.5))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 18)
                }
                

            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack{
                    Text("5 personalizations available")
                        .font(.sora(.caption))
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                    Spacer()
                    Text("\(maxCharacters - description.count) Characters left")
                        .font(.sora(.caption))
                        .foregroundColor(.gray)
                        .padding(8)
                        .background(Color.white)
                }
                Text("Can't think of writing a beautiful description? Our Smart Write feature will construct beautiful description based on the preferences you give.")
                    .font(.sora(.callout))
                    .foregroundColor(.gray)
                
                
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        // Your smart write action here
                    }) {
                        HStack(spacing: 8) {
                            Text("Smart write")
                                .font(.sora(.body))
                            Image(systemName: "sparkles")
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(TextColors.primaryBlack.color)
                        )
                        .foregroundColor(.white)
                    }
                    

                }
            }
        }
    }
}


#Preview {
    PropertyDescriptionInput(description: .constant(""))
        .padding()
}
