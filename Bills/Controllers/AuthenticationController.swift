//
//  AuthenticationController.swift
//  Bills
//
//  Created by Satish Garlapati on 6/24/19.
//  Copyright © 2019 Blackmoon. All rights reserved.
//

import UIKit
import FirebaseAuth

class AuthenticationController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAuthenticationView()
        Auth.auth().addStateDidChangeListener() { auth, user in
            guard user != nil else { return }
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(BankTableViewController(), animated: true)
            }
        }
    }
    
    func configureAuthenticationView() {
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .white
        let authenticatedView = AuthenticationView(frame: CGRect(x: 0, y: 15 + 64, width: view.frame.width, height: 200))
        view.addSubview(authenticatedView)
    }
}
