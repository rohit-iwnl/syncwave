//
//  SignInViewModel.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/26/24.
//

import Foundation
import SwiftUI

class SignInViewModel : ObservableObject {
    
    let appleSignInUtils = AppleSignInUtils()
    
    func signInWithApple() async throws -> AppUser{
        let appleResult = try await appleSignInUtils.startSignInWithAppleFlow()
        return try await AuthManager.shared.signInWithApple(idToken: appleResult.idToken, nonce: appleResult.nonce)
    }
    
    func isFormValid(email : String, password : String) -> Bool {
        guard email.isValidEmail(), password.isValidPassword() else {
            return false
        }
        
        return true
    }
    
    func registerNewUserWithEmail(email : String, password : String) async throws -> AppUser {
        if isFormValid(email: email, password: password){
            return try await AuthManager.shared.registerNewUserWithEmailAndPassword(emailID: email, password: password)
        } else {
            print("Registration Form is invalid")
            throw NSError()
        }
    }
    
    func checkIfUserExists(email : String) async throws -> Bool {
        return true
    }
    
    func signInWithEmail(email : String, password : String) async throws -> AppUser {
        if isFormValid(email: email, password: password){
            return try await AuthManager.shared.signInWithEmailAndPassword(emailID: email, password: password)
        } else {
            print("Registration Form is invalid")
            throw NSError()
        }
    }
    
    func signInWithGoogle() {
        
    }
    
    func signInWithEmailAndPassword() {
        
    }
}
