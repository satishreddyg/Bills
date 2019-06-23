//
//  Card.swift
//  Bills
//
//  Created by Satish Garlapati on 6/7/19.
//  Copyright © 2019 Blackmoon. All rights reserved.
//

import Foundation

struct Card {
    let name: String?
    let last4Digits: Int?
    let isCreditCard: Bool?
    
    init(withDict dict: [String: Any]) {
        self.name = dict["name"] as? String
        self.last4Digits = dict["last4Digits"] as? Int
        self.isCreditCard = dict["isCreditCard"] as? Bool
    }
    
    init(withName name: String, last4Digits: Int, isCreditCard: Bool) {
        self.name = name
        self.last4Digits = last4Digits
        self.isCreditCard = isCreditCard
    }
}
