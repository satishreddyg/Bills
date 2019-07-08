//
//  FirebaseManager.swift
//  Bills
//
//  Created by Satish Garlapati on 7/5/19.
//  Copyright © 2019 Blackmoon. All rights reserved.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation

class SessionManager {
    static let shared = SessionManager()
    private init() {}
    
    private let db = Firestore.firestore()

    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch _ {
            return false
        }
    }
    
    func fetchCards(completionHandler: @escaping (_ result: Result<[Card], CustomError>) -> ()) {
        db.collection("cards").getDocuments() { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                if let error = err as? CustomError {
                    completionHandler(.failure(error))
                } else {
                    completionHandler(.failure(.unknown))
                }
                return
            }
            var cards = [Card]()
            for document in documents {
                let card = Card(withDict: document.data())
                cards.append(card)
            }
            completionHandler(.success(cards))
        }
    }
    
    func fetchTransactions(forCard card: Card, withLimit limit: Int = 3, completionHandler: @escaping ((_ result: Result<String, CustomError>) -> ())) {
        db.collection("transactions").whereField("onCardName", isEqualTo: "\(card.name!) - \(card.last4Digits!.description)").limit(to: limit).getDocuments() { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                if let error = err as? CustomError {
                    completionHandler(.failure(error))
                } else {
                    completionHandler(.failure(.unknown))
                }
                return
            }
            var str: String = ""
            for document in documents {
                let transaction = Transaction(withDict: document.data())
                str += "* \(transaction.place ?? "") - $\(transaction.cost?.description ?? "") \n"
            }
            completionHandler(.success(str))
        }
    }
    
}
