//
//  SignInViewModel.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/26/24.
//

import Foundation
import GoogleSignIn
import CryptoKit


@MainActor
class SignInViewModel : ObservableObject {
    
    let appleSignInUtils = AppleSignInUtils()
    
    func signInWithApple() async throws -> AppUser{
        let appleResult = try await appleSignInUtils.startSignInWithAppleFlow()
        return try await AuthManager.shared.signInWithApple(idToken: appleResult.idToken, nonce: appleResult.nonce)
    }
    
    func isFormValid(email : String, password : String) -> Bool {
        guard email.isValidEmail(), password.isValidPassword() else {
            print("Form Invalid")
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
    
    func signInWithGoogle() async throws -> AppUser {
        let googleUtils = GoogleAuthUtils()
        let googleSignInResult = try await googleUtils.startSignInWithGoogleFlow()
        
        return try await AuthManager.shared.singInWithGoogleAuth(idToken: googleSignInResult.idToken, nonce: googleSignInResult.nonce)
    }
    
    func signInWithEmailAndPassword() {
        
    }
}

struct GoogleSignInResult {
    let idToken : String
    let nonce : String
}

@MainActor
class GoogleAuthUtils {
    
    func startSignInWithGoogleFlow() async throws -> GoogleSignInResult {
        try await withCheckedThrowingContinuation({ [weak self] continuation in
            self?.signInWithGoogleFlow { result in
                continuation.resume(with: result)
            }
            
        })
    }
    
    
    func signInWithGoogleFlow(completion : @escaping (Result<GoogleSignInResult, Error>) -> Void) {
        guard let topVC = UIApplication.shared.topViewController() else {
            completion(.failure(NSError()))
            return
        }
        
        
        let nonce = randomNonceString()
        
        GIDSignIn.sharedInstance.signIn(withPresenting: topVC){ signInResult, error in
            guard let user = signInResult?.user, let idToken = user.idToken else {
                completion(.failure(NSError()))
                return
            }
            
            //SUCCESS handle here
            print("DEBUG VIEW MODEL LEVEL : \(user)")
            completion(.success(.init(idToken: idToken.tokenString, nonce: nonce)))
            
            
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
