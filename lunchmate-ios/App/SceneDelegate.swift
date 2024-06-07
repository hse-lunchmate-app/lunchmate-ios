//
//  SceneDelegate.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 07.02.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        //UserDefaults.standard.set(nil, forKey: "userId")
        if UserDefaults.standard.string(forKey: "userId") == nil {
            window?.rootViewController = AuthenticationViewController()
        } else {
            window?.rootViewController = TabBarController()
        }
        window?.makeKeyAndVisible()
    }

}

