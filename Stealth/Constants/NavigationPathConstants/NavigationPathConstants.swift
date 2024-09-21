//
//  NavigationPathConstants.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/19/24.
//

import SwiftUI

class NavigationCoordinator : ObservableObject {
    @Published var path = NavigationPath()
    @Published var totalPages : Int = 3
    @Published var currentPage : Int = 0
    @Published var showPages : Bool = false
    
    func navigateToPersonalInfoView() {
        path.append("PersonalInfo")
    }
    
    func navigateToPreferences() {
        path.append("Preferences")
    }
    
    func resetToHome() {
        path = NavigationPath()
        path.append("Home")
        
    }
}
