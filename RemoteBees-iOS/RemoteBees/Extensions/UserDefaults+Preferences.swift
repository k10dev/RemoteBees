//
//  UserDefaults+Preferences.swift
//  RemoteBees
//

import Foundation

protocol AppPreferences {
    var firstTimeUsed: Bool { get set }
}

extension UserDefaults : AppPreferences {

    static func preferences() -> AppPreferences {
        return UserDefaults.standard
    }
    
    var firstTimeUsed: Bool {
        get {
            guard let value = UserDefaults.standard.object(forKey: "firstTimeUsed") else {
                return true
            }
            return value as! Bool
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "firstTimeUsed")
        }
    }
    
}
