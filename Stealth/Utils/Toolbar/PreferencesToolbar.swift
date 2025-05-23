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
    
    @Binding var showPages: Bool
    
    var onBackTap: () -> Void
    var onSkipTap: (() -> Void)?
    
    // Add EnvironmentObject to access NavigationCoordinator
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: onBackTap) {
                    Image(systemName: "chevron.left")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.horizontal,10)
                        .padding(.vertical,10)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.black, lineWidth: 2)
                        )
                }
                
                Spacer()
            }
            
            if showPages {
                HStack(spacing: 4) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.black : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .overlay(
                                Circle()
                                    .fill(index == currentPage ? Color.black : Color.gray.opacity(0.3))
                                    .stroke(.black.opacity(0.75), lineWidth: 1)
                            )
                    }
                }
            }
            
            if let skipAction = onSkipTap {
                HStack{
                    Spacer()
                    
                    Button(action: skipAction) {
                        Text("Skip")
                            .font(.sora(.headline))
                            .foregroundStyle(.black)
                            .padding(.horizontal)
                            .padding(.vertical,8)
                    }
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(.black, lineWidth: 2))
                    .animation(.easeInOut, value: onSkipTap != nil)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .onChange(of: showPages) { oldValue, newValue in
            if newValue == false {
                // Reset the navigation coordinator's page count when showPages is set to false
                navigationCoordinator.resetPageCount()
            }
        }
    }
}

#Preview {
    @Previewable @State var currentPage: Int = 1
    
    VStack{
        PreferencesToolbar(currentPage: $currentPage, totalPages: .constant(4), showPages: .constant(true)) {
            
        }
        .environmentObject(NavigationCoordinator()) // Add this for the preview
        
        Button {
            currentPage.self += 1
        } label : {
            Text("Increment")
        }
        .padding()
        
        Button {
            currentPage.self = 1
        } label : {
            Text("Decrement")
        }
        .padding()
    }
    .background(.white)
}
