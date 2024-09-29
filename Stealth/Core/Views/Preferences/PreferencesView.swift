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
    //    @StateObject var navigationCoordinator = NavigationCoordinator()
    @Environment(\.dismiss) private var dismiss
    
    @State private var preferencesArray : [String : Bool] = [:]
    
    @ObservedObject var navigationCoordinator : NavigationCoordinator
    
    var body: some View {
        VStack(spacing: 0) {
            PreferencesToolbar(
                currentPage : $navigationCoordinator.currentPage,
                totalPages: $navigationCoordinator.totalPages,
                showSkipButton: $isShowingHousingPreferences,
                showPages: $navigationCoordinator.showPages,
                onBackTap: handleBackTap
            )
            
            OptionsView(currentPage: $navigationCoordinator.currentPage, totalPages: $navigationCoordinator.totalPages, preferencesArray: $preferencesArray)
        }
        .environmentObject(navigationCoordinator)
    }
    
    private func handleBackTap() {
        withAnimation(.easeInOut(duration: 0.5)) {
            if !navigationCoordinator.path.isEmpty {
                if navigationCoordinator.path.count == 1 {
                    navigationCoordinator.showPages = false
                }
                navigationCoordinator.path.removeLast()
                navigationCoordinator.currentPage = navigationCoordinator.path.count
                
            } else {
                dismiss()
            }
        }
    }
}


#Preview {
    PreferencesView(navigationCoordinator: NavigationCoordinator())
        .environmentObject(NavigationCoordinator())
}
