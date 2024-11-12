//
//  StealthApp.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/25/24.
//

import GoogleSignIn
import SwiftUI

@main
struct StealthApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .onOpenURL { url in
//                    GIDSignIn.sharedInstance.handle(url)
//                }
            RoomTestView()
        }
    }
}
