//
//  SlotAdditionViewController.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 06.03.2024.
//

import UIKit

class SlotAdditionViewController: UIViewController {
    
    // MARK: - Subviews
    
    private let navigationTitle: UILabel = {
        let navigationTitle = UILabel()
        navigationTitle.text = "Слот"
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
