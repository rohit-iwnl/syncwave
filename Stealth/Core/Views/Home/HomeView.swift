//
//  HomeView.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/25/24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var appUserStateManager: AppUserManger
    
    var body: some View {
        Text("App user ID Token : \(appUserStateManager.appUser?.uid ?? "no user logged in")")
            .padding()
        Text("User email Id : \(appUserStateManager.appUser?.email ?? "No email")")
            .padding()
        Text("Home View")
            .padding()
        
        Button(action : {
            Task {
                do {
                    let signedOutUser = try await AuthManager.shared.signOut()
                    
                    await MainActor.run {
                        self.appUserStateManager.appUser = signedOutUser
                    }
                } catch {
                    print("DEBUG : Error signing out")
                }
            }
        }) {
            Text("Sign out")
        }

    }
}

#Preview {
    HomeView()
}
