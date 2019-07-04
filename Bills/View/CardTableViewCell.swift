//
//  CardTableViewCell.swift
//  Bills
//
//  Created by Satish Garlapati on 7/3/19.
//  Copyright © 2019 Blackmoon. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {
    
    let cardImageView: UIImageView = {
        let _imageView = UIImageView(frame: CGRect.zero)
        _imageView.contentMode = .scaleAspectFit
        _imageView.layer.masksToBounds = true
        _imageView.layer.cornerRadius = 15
        return _imageView
    }()
    
    let cardTitleLabel: UILabel = {
        let _label = UILabel(frame: CGRect.zero)
        _label.textColor = .darkGray
        _label.textAlignment = .left
        _label.font = UIFont(name: "OpenSans-Semibold", size: 16)
        _label.sizeToFit()
        return _label
    }()
    
    let subTitleLabel: UILabel = {
        let _label = UILabel(frame: CGRect.zero)
        _label.minimumScaleFactor = 8.0
        _label.lineBreakMode = .byWordWrapping
        _label.numberOfLines = 0
        _label.adjustsFontSizeToFitWidth = true
        _label.font = UIFont.italicSystemFont(ofSize: 11)
        _label.textColor = .lightGray
        return _label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        throwExecutionError(.shouldNotImplementFromStoryboard)
    }
    
    func configureCard(_ card: Card) {
        cardImageView.image = getImage(by: card.name)
        cardImageView.layer.borderColor = getBorderColor(by: card.name)
        cardImageView.layer.borderWidth = 1
        
        cardTitleLabel.text = "\(card.name ?? "") - xxxx\(card.last4Digits?.description ?? "")"

        subTitleLabel.text = "\n\n\n"
    }
    
    private func setupCard() {
        layer.cornerRadius = 10
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
        
        addSubview(cardImageView)
        addSubview(cardTitleLabel)
        addSubview(subTitleLabel)
        
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        cardTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
        cardImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
        cardImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
        cardImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        cardImageView.widthAnchor.constraint(equalToConstant: 70),
        cardImageView.heightAnchor.constraint(equalToConstant: 70),
        
        cardTitleLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 15),
        cardTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
        cardTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
        
        subTitleLabel.topAnchor.constraint(equalTo: cardTitleLabel.bottomAnchor, constant: 5),
        subTitleLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 15),
        subTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    private func getImage(by cardName: String?) -> UIImage? {
        guard let _card = cardName?.lowercased() else { return nil }
        switch _card {
        case let str where str.contains("bofa"): return UIImage(named: "bofa")
        case let str where str.contains("citi"): return UIImage(named: "citi")
        case let str where str.contains("costco"): return UIImage(named: "citi-costco")
        case let str where str.contains("gas"): return UIImage(named: "costco-gas")
        case let str where str.contains("Smoothie"): return UIImage(named: "costco")
        default: return UIImage(named: "Kroger")
        }
    }
    
    private func getBorderColor(by cardName: String?) -> CGColor? {
        guard let _card = cardName?.lowercased() else { return nil }
        switch _card {
        case let str where str.contains("bofa"): return UIColor.red.cgColor
        case let str where str.contains("citi"): return UIColor.blue.cgColor
        case let str where str.contains("costco"): return UIColor.blue.cgColor
        case let str where str.contains("gas"): return UIColor.red.cgColor
        case let str where str.contains("Smoothie"): return UIColor.red.cgColor
        default: return UIColor.red.cgColor
        }
    }
}
