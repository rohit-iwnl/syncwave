//
//  HomeView.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/25/24.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var appUser : AppUser?
    
    var body: some View {
        Text("App user ID Token : \(appUser?.uid ?? "no user logged in")")
            .padding()
        Text("User email Id : \(appUser?.email ?? "No email")")
            .padding()
        Text("Home View")
            .padding()
        
        Button(action : {
            Task {
                do {
                    let signedOutUser = try await AuthManager.shared.signOut()
                    
                    await MainActor.run {
                        self.appUser = signedOutUser
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
    HomeView(appUser: .constant(.init(uid: "1234", email: "rohitmanivel9@gmail.com")))
}
