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
        changeSearchBarAppearance()
        UserDefaults.standard.set(true, forKey: "isPresentAlert")
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    func changeSearchBarAppearance() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes =
        [
            NSAttributedString.Key.foregroundColor: UIColor(named: "Base90") ?? .black,
            NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
        ]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor(named: "Base80")
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(
            string: "Найти по имени",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "Base30") ?? UIColor.lightGray,
                NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
            ]
        )
        let cancelButton = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        cancelButton.title = "Отмена"
        cancelButton.setTitlePositionAdjustment(
            UIOffset(horizontal: 0, vertical: 5),
            for: .default
        )
        cancelButton.setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
            ],
            for: .normal
        )
    }
}

