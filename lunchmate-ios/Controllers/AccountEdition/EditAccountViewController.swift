//
//  EditAccountViewController.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 27.02.2024.
//

import UIKit

class EditAccountViewController: UIViewController {
    
    // MARK: - Subviews
    
    private let navigationTitle: UILabel = {
        let navigationTitle = UILabel()
        navigationTitle.text = "Редактирование профиля"
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(
                systemName: "checkmark",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 14.0,
                    weight: .semibold
                )
            ),
            style: .plain,
            target: self,
            action: #selector(saveChanges)
        )
    }
    
    @objc private func saveChanges() {
        navigationController?.popViewController(animated: true)
    }
    
}
