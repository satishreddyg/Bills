//
//  TransactionTableViewController.swift
//  Bills
//
//  Created by Satish Garlapati on 6/22/19.
//  Copyright © 2019 Blackmoon. All rights reserved.
//

import UIKit
import FirebaseFirestore

class TransactionTableViewController: UITableViewController {
    
    //passing on variables
    private static var card: Card!
    private let db = Firestore.firestore()
    private var transactions: [Transaction] = []
    
    static func getTableViewController(forCard card: Card) -> TransactionTableViewController {
        self.card = card
        return TransactionTableViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        tableView.tableFooterView = UIView()
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "TransactionTableViewCell")
        
        setTitle()
        addFloatingButton()
        getTransactionsForCard()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func setTitle() {
        title = "\(TransactionTableViewController.card.name ?? "") Transactions"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func getTransactionsForCard() {
        guard let card = TransactionTableViewController.card else {return}
        db.collection("transactions").whereField("onCardName", isEqualTo: "\(card.name!) - \(card.last4Digits!.description)").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot?.documents ?? [] {
                    print("\(document.documentID) => \(document.data())")
                    let transaction = Transaction(withDict: document.data())
                    self.transactions.append(transaction)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    private func addFloatingButton() {
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTransaction))
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    @objc private func addNewTransaction() {
        let cardVC = AddCardViewController()
        cardVC.card = TransactionTableViewController.card
        cardVC.cardCallBack = { (_, transaction) in
            self.transactions.append(transaction!)
            self.tableView.reloadData()
        }
        navigationController?.pushViewController(cardVC, animated: true)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        cell.configureCell(with: transactions[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
