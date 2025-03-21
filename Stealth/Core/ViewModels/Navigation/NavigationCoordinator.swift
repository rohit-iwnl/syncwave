//
//  NavigationPathConstants.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/19/24.
//

import SwiftUI

class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var totalPages: Int = 3
    @Published var currentPage: Int = -1
    @Published var showPages: Bool = false

    @Published var preferencesArray: [String: Bool] = [:]

    func incrementPage() {
        if currentPage < totalPages - 1 {
            currentPage += 1
        } else {
            // Handle reaching the end (optional)
            print("Already at the last page")
        }
    }

    func decrementPage() {
        if currentPage > 0 {
            currentPage -= 1
        } else {
            // Handle reaching the beginning (optional)
            print("Already at the first page")
        }
    }
    
    
    func resetPageCount() {
            currentPage = -1
            print("Page count reset to 0")
        }

    func setPage(_ page: Int) {
        if page >= 0 && page < totalPages {
            currentPage = page
        } else {
            print(
                "Attempted to set invalid page: \(page). Valid range is 0-\(totalPages-1)"
            )
        }
    }

    func navigateToPersonalInfoView() {
        path.append(NavigationDestinations.personalInfo)
        setPage(0)
    }

    func navigateToPreferences() {
        path.append(NavigationDestinations.preferences)
    }
    

    func resetToHome() {
        path = NavigationPath()
        path.append(NavigationDestinations.home)
    }

    func updatePreferences(with newPreferences: [String: Bool]) {
        self.preferencesArray = newPreferences
    }
}
