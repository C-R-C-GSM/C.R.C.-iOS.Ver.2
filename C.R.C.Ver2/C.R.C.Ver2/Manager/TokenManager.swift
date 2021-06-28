//
//  TokenManager.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/06/28.
//

import Foundation
import KeychainAccess

class TokenManager {
    static let keychain = Keychain(service: "com.yourcompany.C-R-C-Ver2")
    
    // Token
    class func saveToken(token: String) {
        keychain["token"] = token
    }
    
    class func getToken() -> String {
        if let token = keychain["token"] {
            return token
        } else {
            return ""
        }
    }
    
    class func removeToken() {
        keychain["token"] = nil
    }
}
