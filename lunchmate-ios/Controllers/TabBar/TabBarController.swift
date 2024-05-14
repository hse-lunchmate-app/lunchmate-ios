//
//  TabBarController.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 27.02.2024.
//

import UIKit

protocol TabBarDelegate: AnyObject {
    func updateBadge()
    func getBadge() -> String
}

final class TabBarController: UITabBarController {
    
    // MARK: - Constants
    
    let titles = [
        "Главная",
        "Расписание",
        "Уведомления",
        "Профиль"
    ]
    
    let images = [
        UIImage(
            systemName: "house",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 16.0
            )
        ),
        UIImage(
            systemName: "calendar",
            withConfiguration: UIImage.SymbolConfiguration(
                scale: .large
            )
        ),
        UIImage(
            systemName: "bell",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 16.0
            )
        ),
        UIImage(
            systemName: "person.crop.circle",
            withConfiguration: UIImage.SymbolConfiguration(
                scale: .large
            )
        )
    ]
    
    let selectedImages = [
        UIImage(
            systemName: "house.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 16.0
            )
        ),
        UIImage(
            systemName: "calendar",
            withConfiguration: UIImage.SymbolConfiguration(
                scale: .large
            )
        ),
        UIImage(
            systemName: "bell.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 16.0
            )
        ),
        UIImage(
            systemName: "person.crop.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                scale: .large
            )
        )
    ]
    
    let controllers = [
        UINavigationController(
            rootViewController: MainViewController()
        ),
        UINavigationController(
            rootViewController: ScheduleViewController()
        ),
        UINavigationController(
            rootViewController: NotificationsViewController()
        ),
        UINavigationController(
            rootViewController: AccountViewController(viewModel: AccountViewModel())
        )
    ]
    
    // MARK: - Properties
    
    weak var tabBarDelegate: TabBarDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        configurateTab()
        
    }
    // MARK: - Methods
    
    func configurateTab() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor(named: "Base0")
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        for i in 0..<titles.count {
            controllers[i].navigationBar.prefersLargeTitles = false
            controllers[i].tabBarItem = .init(
                title: titles[i],
                image: images[i],
                selectedImage: selectedImages[i]
            )
            if titles[i] == "Уведомления" {
                tabBarDelegate = controllers[i].topViewController as? TabBarDelegate
                let badge = tabBarDelegate?.getBadge()
                configurateBadge(tabBarAppearance: tabBarAppearance)
                controllers[i].tabBarItem.badgeValue = badge
            }
        }
        
        setViewControllers(controllers, animated: true)
    }
    
    private func configurateBadge(tabBarAppearance: UITabBarAppearance) {
        tabBarAppearance.stackedLayoutAppearance.selected.badgeBackgroundColor = UIColor(named: "Yellow")
        tabBarAppearance.stackedLayoutAppearance.selected.badgeTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        tabBarAppearance.stackedLayoutAppearance.selected.badgePositionAdjustment = UIOffset(horizontal: 6, vertical: 1)
        
        tabBarAppearance.stackedLayoutAppearance.normal.badgeBackgroundColor = UIColor(named: "Yellow")
        tabBarAppearance.stackedLayoutAppearance.normal.badgeTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
        ]
        tabBarAppearance.stackedLayoutAppearance.normal.badgePositionAdjustment = UIOffset(horizontal: 6, vertical: 1)
    }
    
}

// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
