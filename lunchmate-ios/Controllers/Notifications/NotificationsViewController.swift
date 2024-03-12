//
//  NotificationsViewController.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 27.02.2024.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    // MARK: - Variables
    
    private var notificationCount = 1
    
    // MARK: - Subviews
    
    private let navigationTitle: UILabel = {
        let navigationTitle = UILabel()
        navigationTitle.text = "Уведомления"
        navigationTitle.textColor = .black
        navigationTitle.font = UIFont(name: "SFPro-Semibold", size: 17)
        navigationTitle.sizeToFit()
        return navigationTitle
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.titleView = navigationTitle
    }
    
    private func changeCount() {
        notificationCount += 1
        updateBadge()
    }
}

// MARK: - TabBarDelegate

extension NotificationsViewController: TabBarDelegate {
    
    func updateBadge() {
        if notificationCount == 0 {
            tabBarController?.tabBar.items?[2].badgeValue = nil
        }
        else {
            if notificationCount < 100 {
                tabBarController?.tabBar.items?[2].badgeValue = "\(notificationCount)"
            }
            else {
                tabBarController?.tabBar.items?[2].badgeValue = "99+"
            }
        }
    }
    
    func getBadge() -> String {
        return String(notificationCount)
    }
    
}
