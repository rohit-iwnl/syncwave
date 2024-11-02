//
//  PersonalDetailsRequest.swift
//  Stealth
//
//  Created by Rohit Manivel on 10/31/24.
//

import Foundation

struct PersonalDetailsRequest : Codable {
    let supabase_id : String
    
    let personal_details : PersonalDetails
    
    struct PersonalDetails: Codable {
        let country: String
        let state: String
        let gender: String?
        let field: String
        let pronouns: String
    }
}
    
    
