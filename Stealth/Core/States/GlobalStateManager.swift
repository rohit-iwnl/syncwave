//
//  GlobalStateManger.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/3/25.
//

import Foundation
import Combine

class GlobalStateManager : ObservableObject {
    @Published var count : Int = 0
    @Published var userPreferences: UserPreferencesViewModel
    
    
    init() {
        self.userPreferences = UserPreferencesViewModel()
    }
    
    func incrementCount(){
        self.count += 1
    }
    
    func decrementCount(){
        self.count -= 1
    }
}


