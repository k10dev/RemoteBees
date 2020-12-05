//
//  SignUpContext.swift
//  RemoteBeesFlow
//

import Foundation

public struct SignUpContext: Hashable, Codable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    
    public init(firstName: String, lastName: String, email: String, password: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
    }
}
