//
//  Transaction.swift
//  Bills
//
//  Created by Satish Garlapati on 6/22/19.
//  Copyright © 2019 Blackmoon. All rights reserved.
//

import Foundation

struct Transaction {
    let cost: Double?
    let place, notes, onCardName, userId, happenedOn: String?
    let addedOn, modifiedOn: Date?
    
    init(withDict dict: [String: Any]) {
        self.cost = dict["cost"] as? Double
        self.place = dict["place"] as? String
        self.notes = dict["notes"] as? String
        self.onCardName = dict["onCardName"] as? String
        self.userId = dict["userId"] as? String
        self.addedOn = dict["addedOn"] as? Date
        self.modifiedOn = dict["modifiedOn"] as? Date
        self.happenedOn = dict["happenedOn"] as? String
    }
    
    init(withCost cost: Double, place: String, notes: String, cardName: String = "", userId: String, addedOn: Date, modifiedOn: Date, happenedOn: String) {
        self.cost = cost
        self.place = place
        self.notes = notes
        self.onCardName = cardName
        self.userId = userId
        self.addedOn = addedOn
        self.modifiedOn = modifiedOn
        self.happenedOn = happenedOn
    }
}
