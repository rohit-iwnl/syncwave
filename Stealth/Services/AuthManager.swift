//
//  AuthManager.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/26/24.
//

import Foundation
import Supabase

struct AppUser{
    let uid : String
    let email : String?
}

struct User : Decodable {
    let email : String
}

struct SupabaseConfig {
    static let SUPABASE_URL = "SUPABASE_URL"
    static let SUPABASE_KEY = "SUPABASE_ANON_KEY"
}

class AuthManager {
    static let shared = AuthManager()
    
    private var client : SupabaseClient?
    
    //    private init() {
    //        if let supabaseURL = Bundle.main.object(forInfoDictionaryKey: SupabaseConfig.SUPABASE_URL) as? String {
    //            if let supabaseAnonKey = Bundle.main.object(forInfoDictionaryKey: SupabaseConfig.SUPABASE_KEY) as? String {
    //                client = SupabaseClient(supabaseURL: URL(string: supabaseURL)!, supabaseKey: supabaseAnonKey)
    //            } else {
    //                print("Error: Supabase API Key is missing from the Info.plist")
    //                // Handle the missing key case here, e.g., set a default value or alert the user
    //            }
    //        } else {
    //            print("Error: Supabase URL is missing from the Info.plist")
    //            // Handle the missing URL case here, e.g., set a default value or alert the user
    //        }
    //    }
    
    private init () {
        client = SupabaseClient(
            supabaseURL: URL(string: "https://uvnclhfhccqtipmrvlxb.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV2bmNsaGZoY2NxdGlwbXJ2bHhiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM5NTY2MTksImV4cCI6MjAzOTUzMjYxOX0.en805gbeA8KdRJ1bDJpXpLA8u1XhJdL7wIuRANyBSv8"
        )
    }
    
    
    
    func getClient() -> SupabaseClient? {
        return client
    }
    
    func registerNewUserWithEmailAndPassword(emailID : String, password : String) async throws -> AppUser {
        let registrationAuthResponse = try await client?.auth.signUp(email: emailID, password: password)
        guard let session = registrationAuthResponse?.session else {
            print("No session created while registering user with email and password")
            throw NSError()
        }
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
    }
    
    
    // Sign in with email
    func signInWithEmailAndPassword(emailID : String, password : String) async throws -> AppUser {
        let session = try await client?.auth.signIn(email: emailID, password: password)
        return AppUser(uid: session?.user.id.uuidString ?? "Test Email UUID", email: session?.user.email ?? "test@test.com")
    }
    
    func getCurrentSession() async throws -> AppUser{
        let session = try await client?.auth.session
        return AppUser(uid: session?.user.id.uuidString ?? "1234", email: session?.user.email ?? "No Email")
    }
    
    func signInWithApple(idToken : String, nonce : String) async throws -> AppUser {
        let session = try await client?.auth.signInWithIdToken(credentials: .init(provider: .apple, idToken: idToken, nonce: nonce))
        print(session?.user ?? "Session has not been created")
        
        return AppUser(uid: session?.user.id.uuidString ?? "1234", email: session?.user.email ?? "No Email")
    }
    
    func checkIfUserExist(email: String) async throws -> Bool {
        guard email.isValidEmail() else {
            print("Invalid email format")
            return false
        }
        
        do {
            // Query the Supabase table to check if the user exists
            let response = try await client?
                .rpc("check_user_exists", params: [CheckUserExistParams.emailParam : email.lowercased()])
                .execute()
            if let data = response?.data {
                let decodedJson = try JSONDecoder().decode(Bool.self, from: data)
                print("Decoded JSON: \(decodedJson)")
                return decodedJson
            } else {
                return false
            }
        } catch {
            print("Error executing query: \(error.localizedDescription)")
            throw error
        }
    }
    
}
