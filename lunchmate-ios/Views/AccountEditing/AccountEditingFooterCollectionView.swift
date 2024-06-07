//
//  AccountEditingFooterCollectionView.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 07.06.2024.
//

import UIKit

protocol AccountEditingFooterCollectionViewDelegate: AnyObject {
    func openAuthenticationScreen()
}

class AccountEditingFooterCollectionView: UICollectionReusableView {
    
    // MARK: - Properties
    
    weak var delegate: AccountEditingFooterCollectionViewDelegate?
    
    // MARK: - Identifier
    
    static let identifier = "AccountEditingFooterCollectionView"
    
    // MARK: - Subviews
    
    lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "Red")?.cgColor
        button.setTitle("Выйти", for: .normal)
        button.setTitleColor(UIColor(named: "Red"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 16)
        button.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Methods
    
    @objc func logOut() {
        UserDefaults.standard.set(nil, forKey: "userId")
        UserDefaults.standard.set(nil, forKey: "token")
        delegate?.openAuthenticationScreen()
    }
    
    func configure() {
        self.addSubview(logOutButton)
        NSLayoutConstraint.activate([
            logOutButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            logOutButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            logOutButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            logOutButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }
}
