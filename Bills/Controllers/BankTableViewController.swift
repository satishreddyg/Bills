//
//  BankTableViewController.swift
//  Bills
//
//  Created by Satish Garlapati on 6/7/19.
//  Copyright © 2019 Blackmoon. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class BankTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    var cards: [Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        view.backgroundColor = .lightText
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: "CardTableViewCell")
        
        setTitle()
        addFloatingButton()
        loadCardData()
        
        let signOutBarButton = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItem = signOutBarButton
    }
    
    @objc private func signOut() {
        do {
            try Auth.auth().signOut()
            navigationController?.popViewController(animated: true)
        } catch _ {}
    }

    private func loadCardData() {
        db.collection("cards").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot?.documents ?? [] {
                    print("\(document.documentID) => \(document.data())")
                    let card = Card(withDict: document.data())
                    self.cards.append(card)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    private func setTitle() {
        title = "Cards"
    }
    
    private func addFloatingButton() {
        let floatingButton = FloatingAddButton(frame: CGRect(x: view.frame.width - 80, y: view.frame.height - 80 - 44, width: 50, height: 50))
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(addNewCard), for: .touchUpInside)
    }

    @objc private func addNewCard() {
        let cardVC = AddCardViewController()
        cardVC.cardCallBack = { (card, _) in
            self.cards.append(card!)
            self.tableView.reloadData()
        }
        navigationController?.pushViewController(cardVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardTableViewCell", for: indexPath) as! CardTableViewCell
        let card = cards[indexPath.row]
        cell.configureCard(card)
        db.collection("transactions").whereField("onCardName", isEqualTo: "\(card.name!) - \(card.last4Digits!.description)").limit(to: 3).getDocuments() { (querySnapshot, err) in
            var str: String = ""
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot?.documents ?? [] {
                    print("\(document.documentID) => \(document.data())")
                    let transaction = Transaction(withDict: document.data())
                    str += "* \(transaction.place ?? "") - $\(transaction.cost?.description ?? "") \n"
                }
            }
            cell.subTitleLabel.text = str
            cell.subTitleLabel.setNeedsLayout()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = cards[indexPath.row]
        let vc = TransactionTableViewController.getTableViewController(forCard: card)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

