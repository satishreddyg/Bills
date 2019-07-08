//
//  AddCardView.swift
//  Bills
//
//  Created by Satish Garlapati on 6/7/19.
//  Copyright © 2019 Blackmoon. All rights reserved.
//

import UIKit
import FirebaseAuth

enum CustomError: Error {
    case noCardName, noLast4Digits, invalidFormat, noAmount, noSpentOn, message(errorMessage: String), unknown
}

class AddCardView: UIView {
    
    var bankNameTF: UITextField!
    var last4DigitsTF: UITextField!
    private var isCreditCard: UISwitch!
    private var isCreditCardLabel: UILabel!
    private var addButton: UIButton!
    
    var callback: ((_ card: Card?, _ error: CustomError?) -> ())!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        backgroundColor = .lightText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        bankNameTF = constructTextField(with: "  Enter card name")
        last4DigitsTF = constructTextField(with: "  Enter last 4 digits")
        isCreditCard = UISwitch(frame: CGRect.zero)
        addSubview(bankNameTF)
        addSubview(last4DigitsTF)
        addSubview(isCreditCard)
        isCreditCardLabel = UILabel(frame: CGRect.zero)
        isCreditCardLabel.text = "is Credit Card"
        addSubview(isCreditCardLabel)
        addButton = UIButton()
        addButton.setTitle("Add Card", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.addTarget(self, action: #selector(addCardAndDismiss), for: .touchUpInside)
        addButton.layer.cornerRadius = 25
        addButton.backgroundColor = .purple
        addSubview(addButton)
    }
    
    @objc private func addCardAndDismiss() {
        guard let cardName = bankNameTF.text, !cardName.isEmpty else {
            callback(nil, .noCardName)
            return
        }
        guard let _last4DigitsString = last4DigitsTF.text, !_last4DigitsString.isEmpty else {
            callback(nil, .noLast4Digits)
            return
        }
        guard let _last4Digits = Int(_last4DigitsString) else {
            callback(nil, .invalidFormat)
            return
        }
        let todayDate = Date()
        let card = Card(withName: cardName, last4Digits: _last4Digits.description, isCreditCard: isCreditCard.isOn, userId: Auth.auth().currentUser!.uid, addedOn: todayDate, modifiedOn: todayDate)
        callback(card, nil)
    }
    
    private func constructTextField(with placeholder: String = "") -> UITextField {
        let _textfield = UITextField(frame: CGRect.zero)
        _textfield.layer.borderWidth = 1
        _textfield.layer.borderColor = UIColor.darkGray.cgColor
        _textfield.layer.cornerRadius = 25
        _textfield.backgroundColor = .white
        _textfield.placeholder = placeholder
        return _textfield
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bankNameTF.frame = CGRect(x: 15, y: 15 + 44, width: superview!.frame.width - 30, height: 50)
        last4DigitsTF.frame = CGRect(x: 15, y: 124, width: superview!.frame.width - 30, height: 50)
        isCreditCard.frame = CGRect(x: superview!.frame.width - 65, y: 200, width: 100, height: 50)
        isCreditCard.setOn(true, animated: true)
        isCreditCardLabel.frame = CGRect(x: 20, y: 200, width: 200, height: 30)
        addButton.frame = CGRect(x: 15, y: 250, width: superview!.frame.width - 30, height: 50)
    }
}
