//
//  LoginContext.swift
//  RemoteBeesFlow
//

import Foundation

public struct LoginContext: Hashable, Codable {
    let email: String
    let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
