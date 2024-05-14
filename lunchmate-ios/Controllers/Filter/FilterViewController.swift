//
//  FilterViewController.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 06.03.2024.
//

import UIKit

class FilterViewController: UIViewController {
    
    // MARK: - Subviews

    private let navigationTitle: UILabel = {
        let navigationTitle = UILabel()
        navigationTitle.text = "Фильтр"
        navigationTitle.textColor = UIColor(named: "Base90")
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
        view.backgroundColor = UIColor(named: "Base0")
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
