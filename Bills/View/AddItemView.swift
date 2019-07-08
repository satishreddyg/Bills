//
//  AddItemView.swift
//  Bills
//
//  Created by Satish Garlapati on 6/22/19.
//  Copyright © 2019 Blackmoon. All rights reserved.
//

import UIKit
import FirebaseAuth

class AddItemView: UIView {
    
    private var amountTF: UITextField!
    private var spentOnTF: UITextField!
    private var notesTextView: UITextView!
    private var addButton: UIButton!

    var callback: ((_ transaction: Transaction?, _ error: CustomError?) -> ())!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        backgroundColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        amountTF = constructTextField(with: "  Enter amount")
        amountTF.keyboardType = .decimalPad
        spentOnTF = constructTextField(with: "  Where did you spend?")
        notesTextView = UITextView(frame: CGRect(x: 15, y: 15, width: 15, height: 15))
        addSubview(amountTF)
        addSubview(spentOnTF)
        addSubview(notesTextView)
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.borderColor = UIColor.darkGray.cgColor
        notesTextView.layer.cornerRadius = 10
        notesTextView.backgroundColor = .white
        
        addButton = UIButton()
        addButton.setTitle("Add Transaction", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.addTarget(self, action: #selector(addTransactionAndDismiss), for: .touchUpInside)
        addButton.layer.cornerRadius = 25
        addButton.backgroundColor = .purple
        addSubview(addButton)
    }
    
    @objc private func addTransactionAndDismiss() {
        guard let amountString = amountTF.text, !amountString.isEmpty else {
            callback(nil, .noAmount)
            return
        }
        guard let amount = Double(amountString) else {
            callback(nil, .invalidFormat)
            return
        }
        guard let spentAt = spentOnTF.text, !spentAt.isEmpty else {
            callback(nil, .noSpentOn)
            return
        }
        let transaction = Transaction(withCost: amount, place: spentAt, notes: notesTextView.text, userId: Auth.auth().currentUser!.uid, addedOn: Date(), modifiedOn: Date())
        callback(transaction, nil)
    }
    
    private func constructTextField(with placeholder: String = "") -> UITextField {
        let _textfield = UITextField(frame: CGRect.zero)
        _textfield.layer.borderWidth = 1
        _textfield.layer.borderColor = UIColor.darkGray.cgColor
        _textfield.layer.cornerRadius = 10
        _textfield.backgroundColor = .white
        _textfield.placeholder = placeholder
        return _textfield
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        amountTF.frame = CGRect(x: 15, y: 15 + 44, width: superview!.frame.width - 30, height: 50)
        spentOnTF.frame = CGRect(x: 15, y: 124, width: superview!.frame.width - 30, height: 50)
        notesTextView.frame = CGRect(x: 15, y: 200, width: superview!.frame.width - 30, height: 100)
        addButton.frame = CGRect(x: 15, y: 330, width: superview!.frame.width - 30, height: 50)
    }
}
