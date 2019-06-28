//
//  AuthenticationView.swift
//  Bills
//
//  Created by Satish Garlapati on 6/24/19.
//  Copyright © 2019 Blackmoon. All rights reserved.
//

import UIKit
import FirebaseAuth

class AuthenticationView: UIView {
    private var usernameTF: UITextField!
    private var passwordTF: UITextField!
    private var signInButton: UIButton!
    
    var authenticationCallBack: ((_ success: Bool) -> ())!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        usernameTF = CustomTextField(frame: CGRect.zero)
        usernameTF.placeholder = "Enter your email"
        usernameTF.layer.borderWidth = 1
        usernameTF.layer.borderColor = UIColor.darkGray.cgColor
        usernameTF.layer.cornerRadius = 5
        usernameTF.tag = 0
        usernameTF.returnKeyType = .next
        usernameTF.delegate = self
        
        passwordTF = CustomTextField(frame: CGRect.zero)
        passwordTF.placeholder = "Enter your password"
        if #available(iOS 12.0, *) {
            passwordTF.textContentType = .newPassword
            passwordTF.passwordRules = UITextInputPasswordRules(descriptor: "required: upper; required: digit; max-consecutive: 2; minlength: 8;")
        } else {
            // Fallback on earlier versions
        }
        passwordTF.isSecureTextEntry = true
        passwordTF.layer.borderWidth = 1
        passwordTF.layer.borderColor = UIColor.darkGray.cgColor
        passwordTF.layer.cornerRadius = 5
        passwordTF.tag = 1
        passwordTF.returnKeyType = .done
        passwordTF.delegate = self
        
        signInButton = UIButton(frame: CGRect.zero)
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.addTarget(self, action: #selector(signIn(_:)), for: .touchUpInside)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.backgroundColor = .purple
        signInButton.layer.cornerRadius = 25
        
        isUserInteractionEnabled = true
        addSubview(usernameTF)
        addSubview(passwordTF)
        addSubview(signInButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        usernameTF.frame = CGRect(x: 15, y: 30, width: frame.width - 30, height: 50)
        passwordTF.frame = CGRect(x: 15, y: 100, width: frame.width - 30, height: 50)
        signInButton.frame = CGRect(x: 15, y: 180, width: frame.width - 30, height: 50)
    }
    
    @objc func signIn(_ sender: UIButton? = nil) {
        guard let username = usernameTF.text, !username.isEmpty,
            let password = passwordTF.text, !password.isEmpty else { return }
        
        Auth.auth().signIn(withEmail: username, password: password) { (result, error) in
            guard let _error = error else {
                //self.authenticationCallBack(true)
                
                return
            }
            if _error.localizedDescription.contains("no user record") {
                Auth.auth().createUser(withEmail: username, password: password) { (result, error) in
                    guard result?.user != nil else {
                        //self.authenticationCallBack(false)
                        return
                    }
                    //self.authenticationCallBack(true)
                }
            } else {
               //self.authenticationCallBack(false)
            }
        }
    }
}

extension AuthenticationView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            usernameTF.resignFirstResponder()
            passwordTF.becomeFirstResponder()
        case 1:
            passwordTF.resignFirstResponder()
            signIn()
        default: break
        }
        return true
    }
}

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTextField() {
        borderStyle = .none
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds)
        return bounds.insetBy(dx: 10, dy: 10);
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds)
        return bounds.insetBy(dx: 10, dy: 10);
    }
}
