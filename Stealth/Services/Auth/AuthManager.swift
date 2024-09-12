//
//  AuthManager.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/26/24.
//

import Foundation
import Supabase


struct AppUser : Equatable {
    let uid : String?
    let email : String?
}

struct User : Decodable {
    let email : String
}

struct SupabaseConfig {
    static let SUPABASE_URL = "SUPABASE_URL"
    static let SUPABASE_KEY = "SUPABASE_ANON_KEY"
}

enum UserRPCs {
    static let updateFullNameRPC = (funcName: "update_user_full_name", userIDParam: "user_id", fullNameParam: "new_full_name")
}

struct UpdateFullNameResponse: Codable {
    let success: Bool
    let message: String
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
    
    func getCurrentSession() async throws -> AppUser? {
        
        
        guard let session = try await client?.auth.session,
              !session.user.id.uuidString.isEmpty else {
            return nil
        }
        
        print("DEBUG SESSION : \(session)")
        
        let userExists = try await checkIfUserExist(email: session.user.email ?? "")
        if userExists == CheckEmailUserExists.ApiReponse.Found || userExists == CheckEmailUserExists.ApiReponse.OAuth {
            return AppUser(uid: session.user.id.uuidString, email: session.user.email)
        } else {
            return nil
        }
    }
    
    
    
    
    func signInWithApple(idToken : String, nonce : String) async throws -> AppUser {
        let session = try await client?.auth.signInWithIdToken(credentials: .init(provider: .apple, idToken: idToken, nonce: nonce))
        print(session?.user ?? "Session has not been created")
        
        return AppUser(uid: session?.user.id.uuidString ?? "1234", email: session?.user.email ?? "No Email")
    }
    
    func checkIfUserExist(email: String) async throws -> String {
        guard email.isValidEmail() else {
            return "Invalid email format"
        }
        
        do {
            // Query the Supabase table to check if the user exists
            let response = try await client?
                .rpc(CheckEmailUserExists.rpc_func_name, params: [CheckEmailUserExists.emailParamater : email.lowercased()])
                .execute()
            if let data = response?.data {
                let decodedJson = try JSONDecoder().decode(String.self, from: data)
                print("Decoded JSON: \(decodedJson)")
                return decodedJson
            } else {
                return "Error fetching the user details"
            }
        } catch {
            print("Error executing query: \(error.localizedDescription)")
            throw error
        }
    }
    
    func singInWithGoogleAuth(idToken : String, nonce : String) async throws -> AppUser {
        let session = try await client?.auth.signInWithIdToken(credentials: .init(provider: .google, idToken: idToken, nonce: nonce))
        print(session ?? "No session")
        print(session?.user ?? "No user")
        
        return AppUser(uid: session?.user.id.uuidString ?? "nil", email: session?.user.email ?? "no email")
    }
    
    func signOut() async throws -> AppUser {
        try await client?.auth.signOut()
        
        return AppUser(uid: "", email: nil)
    }
    
    func updateUserFullName(userID: String, fullName: String) async throws -> Bool {
        do {
            let response: UpdateFullNameResponse = try await executeRPC(
                functionName: UserRPCs.updateFullNameRPC.funcName,
                params: [
                    UserRPCs.updateFullNameRPC.userIDParam: userID,
                    UserRPCs.updateFullNameRPC.fullNameParam: fullName
                ]
            )
            if !response.success {
                print("Failed to update user's full name: \(response.message)")
            }
            return response.success
        } catch {
            print("Error updating user's full name: \(error)")
            throw error
        }
    }
    
    
}

extension AuthManager {
    func executeRPC<T: Decodable, E: Encodable & Sendable>(functionName: String, params: [String: E]) async throws -> T {
        guard let client = client else {
            throw NSError(domain: "AuthManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Supabase client is not initialized"])
        }
        
        return try await client.rpc(functionName, params: params)
            .single()
            .execute()
            .value
    }
}
