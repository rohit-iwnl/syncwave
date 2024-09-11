//
//  PreferencesView.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/9/24.
//

import SwiftUI

struct PreferencesView: View {
    @State private var currentPage = 0
    @State private var totalPages = 3
    
    
    var body: some View {
        VStack(spacing: 0) {
            PreferencesToolbar(currentPage: $currentPage, totalPages: $totalPages)
            
            ZStack {
                OptionsView(currentPage: $currentPage, totalPages: $totalPages)
                    .opacity(currentPage == 0 ? 1 : 0)
                    .animation(.easeInOut, value: currentPage)
                
                PersonalInfoView(currentPage: $currentPage)
                    .opacity(currentPage == 1 ? 1 : 0)
                    .animation(.easeInOut, value: currentPage)
                
                Text("Third Screen")
                    .opacity(currentPage == 2 ? 1 : 0)
                    .animation(.easeInOut, value: currentPage)
            }
        }
        .toolbar(.hidden)
    }
}



#Preview {
    PreferencesView()
}
