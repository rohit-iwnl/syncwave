//
//  UserPreferencesState.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/3/25.
//

import Foundation


class UserPreferencesViewModel : ObservableObject {
    @Published var preferences: [UserPreferencesStateKeys: Bool] = [
        .here_to_explore : false,
        .lease_sublease_property : false,
        .find_roommate : false,
        .sell_buy_product : false
    ]
    
    func getPreferenceSetToTrue() -> UserPreferencesStateKeys {
        for (key, value) in preferences {
            if value == true {
                return key
            }
        }
        
        return .here_to_explore
    }
    
    
    
    func setPreferenceToTrue(keyToSet key : UserPreferencesStateKeys){
        if preferences[key] == true {
            return
        }
        
        preferences = preferences.mapValues({ _ in
            false
        })
        
        preferences[key] = true
    }
}

enum UserPreferencesStateKeys : String {
    case here_to_explore = "here_to_explore"
    case lease_sublease_property = "lease_property"
    case find_roommate = "find_roommate"
    case sell_buy_product = "sell_buy_product"
}
