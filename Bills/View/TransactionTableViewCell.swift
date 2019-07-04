//
//  TransactionTableViewCell.swift
//  Bills
//
//  Created by Satish Garlapati on 7/2/19.
//  Copyright © 2019 Blackmoon. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    var circularImageView: UIImageView = {
        let _imageView = UIImageView(frame: CGRect.zero)
        _imageView.contentMode = .scaleAspectFit
        _imageView.layer.masksToBounds = true
        _imageView.layer.cornerRadius = 25
        return _imageView
    }()
    
    var titleLabel: UILabel = {
       let _label = UILabel(frame: CGRect.zero)
        _label.textAlignment = .left
        _label.font = UIFont(name: "OpenSans-Semibold", size: 16)
        _label.textColor = .darkGray
        _label.sizeToFit()
        return _label
    }()
    
    var subTitleLabel: UILabel = {
       let _subTitleLabel = UILabel(frame: CGRect.zero)
        _subTitleLabel.minimumScaleFactor = 8.0
        _subTitleLabel.lineBreakMode = .byWordWrapping
        _subTitleLabel.numberOfLines = 2
        _subTitleLabel.adjustsFontSizeToFitWidth = true
        _subTitleLabel.font = UIFont.italicSystemFont(ofSize: 11)
        _subTitleLabel.textColor = .lightGray
        return _subTitleLabel
    }()
    
    var priceLabel: UILabel = {
        let _label = UILabel(frame: CGRect.zero)
        _label.adjustsFontSizeToFitWidth = false
        _label.textAlignment = .right
        _label.font = UIFont(name: "OpenSans", size: 18)
        _label.textColor = .darkGray
        return _label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(circularImageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(priceLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with transaction: Transaction) {
        circularImageView.image = getImage(byPlace: transaction.place! + transaction.notes!)
        titleLabel.text = transaction.place
        //titleLabel.backgroundColor = .blue
        subTitleLabel.text = transaction.notes
        //subTitleLabel.backgroundColor = .yellow
        priceLabel.text = "$\(transaction.cost?.description ?? "0.00")"
        
        circularImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            circularImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            circularImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            circularImageView.widthAnchor.constraint(equalToConstant: 50),
            circularImageView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.leadingAnchor.constraint(equalTo: circularImageView.trailingAnchor, constant: 5),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalToSystemSpacingAfter: priceLabel.leadingAnchor, multiplier: -15),
            
            subTitleLabel.leadingAnchor.constraint(equalTo: circularImageView.trailingAnchor, constant: 5),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            subTitleLabel.trailingAnchor.constraint(equalToSystemSpacingAfter: priceLabel.leadingAnchor, multiplier: -15),
            
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor)]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func getImage(byPlace place: String?) -> UIImage? {
        guard let _place = place?.lowercased() else { return nil }
        switch _place {
        case let str where str.contains("kroger"): return UIImage(named: "kroger")
        case let str where str.contains("smoothie"): return UIImage(named: "smoothie")
        case let str where str.contains("buffet"): return UIImage(named: "indian-buffet")
        case let str where str.contains("gas"): return UIImage(named: "costco-gas")
        case let str where str.contains("Smoothie"): return UIImage(named: "costco")
        default: return UIImage(named: "Kroger")
        }
    }
}
