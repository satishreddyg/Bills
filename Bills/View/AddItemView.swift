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
    private var happenedOnTF: UITextField!
    private var notesTextView: UITextView!
    private var addButton: UIButton!
    private var datePicker: UIDatePicker!

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
        amountTF = constructTextField(with: "\tEnter amount")
        amountTF.keyboardType = .decimalPad
        spentOnTF = constructTextField(with: "\tWhere did you spend?")
        happenedOnTF = constructTextField(with: "\tHappened on?")
        happenedOnTF.tag = 2
        notesTextView = UITextView(frame: CGRect(x: 15, y: 15, width: 15, height: 15))
        addSubview(amountTF)
        addSubview(spentOnTF)
        addSubview(happenedOnTF)
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
        
        addDatePicker()
    }
    
    private func addDatePicker() {
        datePicker = UIDatePicker(frame: CGRect.zero)
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        happenedOnTF.inputView = datePicker
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
        guard let happenedOnString = happenedOnTF.text, !happenedOnString.isEmpty else {
            callback(nil, .noSpentOn)
            return
        }
        let transaction = Transaction(withCost: amount, place: spentAt, notes: notesTextView.text, userId: Auth.auth().currentUser!.uid, addedOn: Date(), modifiedOn: Date(), happenedOn: happenedOnString)
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
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        happenedOnTF.text = "\t\(dateFormatter.string(from: sender.date))"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        datePicker.frame = CGRect(x: 0, y: superview!.frame.height - 290, width: superview!.frame.width, height: 290)
        amountTF.frame = CGRect(x: 15, y: 15 + 44, width: superview!.frame.width - 30, height: 50)
        spentOnTF.frame = CGRect(x: 15, y: 124, width: superview!.frame.width - 30, height: 50)
        happenedOnTF.frame = CGRect(x: 15, y: 189, width: superview!.frame.width - 30, height: 50)
        notesTextView.frame = CGRect(x: 15, y: 265, width: superview!.frame.width - 30, height: 100)
        addButton.frame = CGRect(x: 15, y: 395, width: superview!.frame.width - 30, height: 50)
    }
}
