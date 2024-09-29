//
//  StealthApp.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/25/24.
//

import SwiftUI
import GoogleSignIn

@main
struct StealthApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                ContentView()
                    .onOpenURL { url in
                        GIDSignIn.sharedInstance.handle(url)
                    }
            }
        }
    }
}
