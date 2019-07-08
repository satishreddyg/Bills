//
//  Card.swift
//  Bills
//
//  Created by Satish Garlapati on 6/7/19.
//  Copyright © 2019 Blackmoon. All rights reserved.
//

import Foundation

struct Card {
    let name, last4Digits, userId: String?
    let isCreditCard: Bool
    let addedOn, modifiedOn: Date?
    
    init(withDict dict: [String: Any]) {
        self.name = dict["name"] as? String
        self.last4Digits = dict["last4Digits"] as? String
        self.isCreditCard = dict["isCreditCard"] as! Bool
        self.userId = dict["userId"] as? String
        self.addedOn = dict["addedOn"] as? Date
        self.modifiedOn = dict["modifiedOn"] as? Date
    }
    
    init(withName name: String, last4Digits: String, isCreditCard: Bool, userId: String, addedOn: Date, modifiedOn: Date) {
        self.name = name
        self.last4Digits = last4Digits
        self.isCreditCard = isCreditCard
        self.userId = userId
        self.addedOn = addedOn
        self.modifiedOn = modifiedOn
    }
}
