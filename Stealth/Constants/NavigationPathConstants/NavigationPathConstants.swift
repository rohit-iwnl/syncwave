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
    @Published var currentPage : Int = -1
    @Published var showPages : Bool = false
    
    @Published var preferencesArray : [String : Bool] = [:]
    
    
    func navigateToPersonalInfoView() {
        path.append("PersonalInfo")
    }
    
    func navigateToPreferences() {
        path.append(NavigationDestinations.preferences)
    }
    
    func resetToHome() {
        path = NavigationPath()
        path.append("Home")
    }
    
    func updatePreferences(with newPreferences: [String : Bool]) {
        self.preferencesArray = newPreferences
    }
}
