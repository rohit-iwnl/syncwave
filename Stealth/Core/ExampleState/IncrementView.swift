//
//  IncrementView.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/3/25.
//

import SwiftUI

struct IncrementView: View {
    @EnvironmentObject var globalState : GlobalStateManager
    
    var body: some View {
        Text("Current Count: \(globalState.count)")
            .font(.sora(.title, weight: .bold))
            .padding()
        
        Button {
            globalState.incrementCount()
        } label: {
            Text("Increment Count")
        }
        
        Button {
            globalState.decrementCount()
        } label: {
            Text("Decrement Count")
        }

    }
}

#Preview {
    IncrementView()
        .environmentObject(GlobalStateManager())
}
