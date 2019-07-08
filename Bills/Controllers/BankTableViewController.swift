//
//  BankTableViewController.swift
//  Bills
//
//  Created by Satish Garlapati on 6/7/19.
//  Copyright © 2019 Blackmoon. All rights reserved.
//

import UIKit

class BankTableViewController: UITableViewController {
    
    var cards: [Card] = []
    private(set) var debitCards: [Card] = []
    private(set) var creditCards: [Card] = []
    private let sessionManager = SessionManager.shared
    
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
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        tableView.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
            let touchPoint = gesture.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                print("indexpath row is: \(indexPath.row)")
            }
        }
    }
    
    @objc private func signOut() {
        guard sessionManager.signOut() else {
            showAlert(withTitle: "Signout failed", andMessage: "unable to signout at this moment, please try again", andDefaultTitle: "OK", andCustomActions: nil)
            return
        }
        navigationController?.popViewController(animated: true)
    }

    private func loadCardData() {
        sessionManager.fetchCards { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let _cards):
                self.cards = _cards
                self.debitCards = _cards.filter({!$0.isCreditCard})
                self.creditCards = _cards.filter({$0.isCreditCard})
                self.tableView.reloadData()
            case .failure(let error):
                self.showAlert(withTitle: "Couldn't load cards", andMessage: error.localizedDescription, andDefaultTitle: "OK", andCustomActions: nil)
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Credit" : "Debit"
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let _view = UIV
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? creditCards.count : debitCards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardTableViewCell", for: indexPath) as! CardTableViewCell
        let card = indexPath.section == 0 ? creditCards[indexPath.row] : debitCards[indexPath.row]
        cell.configureCard(card)
        sessionManager.fetchTransactions(forCard: card) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let str):
                cell.subTitleLabel.text = str
                cell.subTitleLabel.setNeedsLayout()
            case .failure(let error):
                self.showAlert(withTitle: "Couldn't load transactions", andMessage: error.localizedDescription, andDefaultTitle: "OK", andCustomActions: nil)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = indexPath.section == 0 ? creditCards[indexPath.row] : debitCards[indexPath.row]
        let vc = TransactionTableViewController.getTableViewController(forCard: card)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

