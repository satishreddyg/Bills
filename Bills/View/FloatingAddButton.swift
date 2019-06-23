//
//  FloatingAddButton.swift
//  Bills
//
//  Created by Satish Garlapati on 6/7/19.
//  Copyright © 2019 Blackmoon. All rights reserved.
//

import UIKit

class FloatingAddButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        layer.cornerRadius = 25
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
        setTitle("ADD", for: .normal)
        setTitleColor(.black, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
