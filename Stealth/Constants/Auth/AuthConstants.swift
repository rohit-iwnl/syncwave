//
//  AuthConstants.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/29/24.
//

import Foundation


struct CheckUserExistParams {
    static let emailParam : String = "provided_email"
}

struct CheckEmailUserExists {
    static let rpc_func_name : String = "check_email_user_exists"
    static let emailParamater : String = "email_to_check"
    
    struct ApiReponse {
        static let Found: String = "exists"
        static let Not_Found: String = "not_found"
        static let OAuth: String = "OAuth"
        static let Error: String = "error"
    }
}
