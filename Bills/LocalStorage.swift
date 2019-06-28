//
//  LocalStorage.swift
//  Bills
//
//  Created by Satish Garlapati on 6/24/19.
//  Copyright © 2019 Blackmoon. All rights reserved.
//

import Foundation

let localStorage = UserDefaults.standard

enum DefaultKeys: String {
    case userId
}

extension UserDefaults {
    
    private func value(forKey key: DefaultKeys) -> Any? {
        return value(forKey: key.rawValue)
    }
    
    private func set(value: Any?, forKey key: DefaultKeys) {
        set(value, forKey: key.rawValue)
    }
    
//    var userId: String? {
//        get {
//            return value(forKey: .userId) as? String
//        }
//        set {
//            set(value: newValue, forKey: .userId)
//        }
//    }
}
