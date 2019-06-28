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
    let place: String?
    let date: Date?
    let notes: String?
    let onCardName: String?
    let userId: String?
    
    init(withDict dict: [String: Any]) {
        self.cost = dict["cost"] as? Double
        self.place = dict["place"] as? String
        self.date = dict["date"] as? Date
        self.notes = dict["notes"] as? String
        self.onCardName = dict["onCardName"] as? String
        self.userId = dict["userId"] as? String
    }
    
    init(withCost cost: Double, place: String, date: Date, notes: String, cardName: String = "", userId: String) {
        self.cost = cost
        self.place = place
        self.date = date
        self.notes = notes
        self.onCardName = cardName
        self.userId = userId
    }
}
