//
//  Hasher.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/11/24.
//

import SwiftUI
import CryptoKit // Import CryptoKit for MD5 hashing

struct Hasher: View {
    var body: some View {
        Button{
        } label: {
            Text("Hash")
        }
    }
    
    private func generateMD5Hash(from input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = Insecure.MD5.hash(data: inputData)
        
        // Convert hash to a hex string
        return hashed.map { String(format: "%02hhx", $0) }.joined()
    }
}

#Preview {
    Hasher()
}
