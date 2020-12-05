//
//  UserDefaults+Preferences.swift
//  RemoteBees
//

import Foundation

protocol AppPreferences {
    var firstTimeUsed: Bool { get set }
}

extension UserDefaults : AppPreferences {

    private static let keyFirstTimeUsed = "firstTimeUsed"

    static func preferences() -> AppPreferences {
        return UserDefaults.standard
    }
    
    var firstTimeUsed: Bool {
        get {
            guard let value = UserDefaults.standard.object(forKey: Self.keyFirstTimeUsed) else {
                return true
            }
            return value as! Bool
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Self.keyFirstTimeUsed)
        }
    }
    
}
