//
//  PreferencesService.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/5/24.
//

import Foundation
import Supabase

struct PreferenceRPCs {
    struct checkPreferencesCompletedRPC {
        static let funcName = "check_preferences_completed"
        static let UUIDParam = "user_id"
    }
    struct setPreferencesCompletedRPC {
        static let funcName = "set_preferences_completed"
        static let UUIDParam = "user_id"
    }
    
    struct getUserFullNameRPC {
        static let funcName = "get_user_full_name"
        static let UUIDParam = "user_id"
    }
}


class PreferencesService {
    static let shared = PreferencesService()
    
    private init() {}
    
    func checkIfUserCompletedPreferences(userID : String) async -> Bool {
        do {
            let response : Bool = try await AuthManager.shared.executeRPC(functionName: PreferenceRPCs.checkPreferencesCompletedRPC.funcName, params: [PreferenceRPCs.checkPreferencesCompletedRPC.UUIDParam : userID])
            
            return response
        } catch {
            print("Error checking if user completed preferences: \(error)")
            return false
        }
    }
    
    func getUserFullName(userID : String) async throws -> String {
        do {
            let fullName: String = try await AuthManager.shared.executeRPC(
                functionName: PreferenceRPCs.getUserFullNameRPC.funcName,
                params: [PreferenceRPCs.getUserFullNameRPC.UUIDParam: userID]
            )
            return fullName
        } catch {
            throw error
        }
    }
}
