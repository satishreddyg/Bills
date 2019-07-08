//
//  AddCardViewController.swift
//  Bills
//
//  Created by Satish Garlapati on 6/7/19.
//  Copyright © 2019 Blackmoon. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AddCardViewController: UIViewController {
    
    var cardCallBack: ((_ card: Card?, _ transaction: Transaction?) -> ())!
    let db = Firestore.firestore()
    var card: Card?

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        setupUI()
    }
    
    private func setTitle() {
        title = "\(card == nil ? "Adding New Card" : "Adding \(card?.name ?? "") Transaction")"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    fileprivate func presentAddingCardError(_ error: CustomError?) {
        guard let _error = error else { return }
        switch _error {
        case .noCardName:
            self.showAlert(withTitle: "Card Name Missing", andMessage: "Please enter a card name and continue..", andDefaultTitle: "Got it", andCustomActions: nil)
        case .noLast4Digits:
            self.showAlert(withTitle: "Card Name Missing", andMessage: "Please enter last 4 digits of your card and continue..", andDefaultTitle: "Got it", andCustomActions: nil)
        case .invalidFormat:
            self.showAlert(withTitle: "Invalid last 4 digits", andMessage: "Please enter VALID last 4 digits of your card and continue..", andDefaultTitle: "Got it", andCustomActions: nil)
        case .noAmount:
            self.showAlert(withTitle: "Amount Missing", andMessage: "Please enter how much you spent and continue..", andDefaultTitle: "Got it", andCustomActions: nil)
        case .noSpentOn:
            self.showAlert(withTitle: "Spent at?", andMessage: "Please enter where did you spend and continue..", andDefaultTitle: "Got it", andCustomActions: nil)
        case .message(let errorMessage):
            self.showAlert(withTitle: "Error", andMessage: errorMessage, andDefaultTitle: "Got it", andCustomActions: nil)
        case .unknown:
            self.showAlert(withTitle: "Unknown Error", andMessage: "Please try again later", andDefaultTitle: "OK", andCustomActions: nil)
        }
    }
    
    fileprivate func configureAddCardView() {
        let cardView = AddCardView(frame: CGRect(x: 0, y: navigationController?.navigationBar.frame.height ?? 44, width: view.frame.width, height: view.frame.height))
        cardView.callback = { (card, error) in
            guard let _card = card else {
                self.presentAddingCardError(error)
                return
            }
            self.addCardAndDismiss(card: _card)
        }
        view.addSubview(cardView)
    }
    
    private func setupUI() {
        guard card != nil else {
            configureAddCardView()
            return
        }
        let cardView = AddItemView(frame: CGRect(x: 0, y: navigationController?.navigationBar.frame.height ?? 44, width: view.frame.width, height: view.frame.height))
        cardView.callback = { (transaction, error) in
            guard let _transaction = transaction else {
                self.presentAddingCardError(error)
                return
            }
            self.addTransactionAndDismiss(transaction: _transaction)
        }
        view.addSubview(cardView)
    }
    
    private func addCardAndDismiss(card: Card) {
        var ref: DocumentReference? = nil
        ref = db.collection("cards").addDocument(data: [
            "name": card.name!,
            "last4Digits": card.last4Digits!,
            "isCreditCard": card.isCreditCard,
            "userId": card.userId!,
            "addedOn": card.addedOn!,
            "modifiedOn": card.modifiedOn!
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
                self.showAlert(withTitle: "Couldn't save card", andMessage: "We couldn't save the card at this moment because of the error: \(err.localizedDescription). Please try again", andDefaultTitle: "OK", andCustomActions: nil)
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.cardCallBack(card, nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func updateCardAndDismiss(card: Card) {
        
    }
    
    private func addTransactionAndDismiss(transaction: Transaction) {
        var ref: DocumentReference? = nil
        ref = db.collection("transactions").addDocument(data: [
            "cost": transaction.cost!,
            "place": transaction.place!,
            "notes": transaction.notes!,
            "onCardName": "\(card?.name ?? "") - \(card?.last4Digits?.description ?? "")",
            "userId": transaction.userId!,
            "addedOn": transaction.addedOn!,
            "modifiedOn": transaction.modifiedOn!
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
                self.showAlert(withTitle: "Couldn't add transaction", andMessage: "We couldn't add transaction at this moment because of the error: \(err.localizedDescription). Please try again", andDefaultTitle: "OK", andCustomActions: nil)
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.cardCallBack(nil, transaction)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

}
