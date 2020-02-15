//
//  AppDelegate.swift
//  Bills
//
//  Created by Satish Garlapati on 6/7/19.
//  Copyright © 2019 Blackmoon. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseFirestore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        setRootViewController()
        return true
    }
    
    private func setRootViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: BankTableViewController())
        window?.makeKeyAndVisible()
    }
}

