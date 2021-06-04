//
//  SignUpManager.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/06/03.
//

import Foundation
import KeychainAccess

class SignUpManager {
    static let keychain = Keychain(service: "com.yourcompany.C-R-C-Ver2")
    
    // email
    class func saveEmail(email: String) {
        keychain["email"] = email
    }
    
    class func getEmail() -> String {
        if let email = keychain["email"] {
            return email
        } else {
            return ""
        }
    }
    
    class func removeEmail() {
        keychain["email"] = nil
    }
    
    
    // password
    class func savePassword(password: String) {
        keychain["password"] = password
    }
    
    class func getPassword() -> String {
        if let password = keychain["password"] {
            return password
        } else {
            return ""
        }
    }
    
    class func removePassword() {
        keychain["password"] = nil
    }
    
    // name
    class func saveName(name: String) {
        keychain["name"] = name
    }
    
    class func getName() -> String {
        if let name = keychain["name"] {
            return name
        } else {
            return ""
        }
    }
    
    class func removeName() {
        keychain["name"] = nil
    }
}
