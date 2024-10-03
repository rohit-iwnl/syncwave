//
//  PreferencesView.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/9/24.
//

import SwiftUI
import NavigationTransitions

struct PreferencesView: View {
    @StateObject private var keychainVM = KeychainViewModel()
    @State private var isShowingHousingPreferences: Bool = false
    @State private var showPages: Bool = true
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var preferencesArray : [String : Bool] = [:]
    
    @EnvironmentObject var navigationCoordinator : NavigationCoordinator
    
    var body: some View {
        VStack(spacing: 0) {
            PreferencesToolbar(
                currentPage : $navigationCoordinator.currentPage,
                totalPages: $navigationCoordinator.totalPages,
                showPages: $navigationCoordinator.showPages,
                onBackTap: handleBackTap
            )
            
            OptionsView(currentPage: $navigationCoordinator.currentPage, totalPages: $navigationCoordinator.totalPages, preferencesArray: $preferencesArray)
        }
        .environmentObject(navigationCoordinator)
    }
    
    private func handleBackTap() {
        dismiss()
    }
}


#Preview {
    PreferencesView()
        .environmentObject(NavigationCoordinator())
}
