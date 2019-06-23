//
//  UIViewControllerExtension.swift
//  Bills
//
//  Created by Satish Garlapati on 6/22/19.
//  Copyright © 2019 Blackmoon. All rights reserved.
//

import UIKit

extension UIViewController {
    public func showAlert(withTitle title: String, andMessage message: String, andDefaultTitle defaultTitle: String, andCustomActions actions: [UIAlertAction]?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let customActions = actions {
            customActions.forEach({[weak alertController] in
                alertController?.addAction($0)})
        }
        let defaultAction = UIAlertAction(title: defaultTitle, style: actions == nil ? .cancel : .default, handler: nil)
        alertController.addAction(defaultAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
