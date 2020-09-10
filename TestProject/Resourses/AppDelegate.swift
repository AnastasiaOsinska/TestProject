//
//  AppDelegate.swift
//  TestProject
//
//  Created by Anastasiya Osinskaya on 9/4/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import UIKit
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let cocktailController = CocktailsTableViewController()
        let navigationController = UINavigationController(rootViewController: cocktailController)
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = navigationController
        return true
    }

}

