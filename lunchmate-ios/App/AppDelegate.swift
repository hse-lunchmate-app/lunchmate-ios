//
//  AppDelegate.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 07.02.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().barTintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes =
        [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
        ]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor(named: "Base70")
        return true
    }

}

