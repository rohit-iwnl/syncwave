//
//  NavigationDestinations.swift
//  Stealth
//
//  Created by Rohit Manivel on 10/1/24.
//

import Foundation

/// The enum `NavigationDestinations` defines the different destinations in the app's navigation system.

enum NavigationDestinations : String, Hashable {
    case home = "home"
    case settings = "settings"
    case personalInfo = "personalInfo"
    case preferences = "preferences"
    case welcome = "welcome"
    case signIn = "signIn"
    case signUp = "signUp"
    case onboarding = "onboarding"
    case housing = "housing"
    case roomdecider = "roomdecider"
    case sellingProperty = "sellingProperty"
    case roomplan = "roomplan"
    case lookingForRoommate = "lookingForRoommate"
    case personalTraitsFirstScreen = "personalTraitsFirstView"
    
}
