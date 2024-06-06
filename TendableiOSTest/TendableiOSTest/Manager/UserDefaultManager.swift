//
//  UserDefaultManager.swift
//  TendableiOSTest
//
//  Created by Shravan Gundawar on 06/06/24.
//

import Foundation

protocol UserDefaultCompatible {
    associatedtype ValueType
    static func get(from userDefaults: UserDefaults, forKey key: String) -> ValueType?
    static func set(_ value: ValueType?, in userDefaults: UserDefaults, forKey key: String)
}


class UserDefaultsManager {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func set<T: UserDefaultCompatible>(_ value: T?, forKey key: String) {
        T.set(value as? T.ValueType, in: userDefaults, forKey: key)
    }
    
    func get<T: UserDefaultCompatible>(forKey key: String) -> T? {
        return T.get(from: userDefaults, forKey: key) as? T
    }
}

//MARK: Type based extensions for UserDefaults storage
extension Int: UserDefaultCompatible {
    static func get(from userDefaults: UserDefaults, forKey key: String) -> Int? {
        return userDefaults.integer(forKey: key)
    }
    
    static func set(_ value: Int?, in userDefaults: UserDefaults, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
}

extension String: UserDefaultCompatible {
    static func get(from userDefaults: UserDefaults, forKey key: String) -> String? {
        return userDefaults.string(forKey: key)
    }
    
    static func set(_ value: String?, in userDefaults: UserDefaults, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
}

extension Bool: UserDefaultCompatible {
    static func get(from userDefaults: UserDefaults, forKey key: String) -> Bool? {
        return userDefaults.bool(forKey: key)
    }
    
    static func set(_ value: Bool?, in userDefaults: UserDefaults, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
}
