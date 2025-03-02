//
//  NavigationViewModel.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/2/25.
//

import Foundation
import SwiftUI


class NavigationViewModel: ObservableObject {
    
    @EnvironmentObject var navigationCoordinator : NavigationCoordinator
    @Environment(\.dismiss) private var dismiss
    
    
    private func handleBackTap() {
        withAnimation(.easeInOut(duration : 0.5)){
            if !navigationCoordinator.path.isEmpty {
                navigationCoordinator.path.removeLast()
                navigationCoordinator.currentPage -= 1
            } else {
                dismiss()
            }
        }
    }
}
