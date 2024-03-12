//
//  ScheduleViewController.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 27.02.2024.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    // MARK: - Subviews
    
    private let navigationTitle: UILabel = {
        let navigationTitle = UILabel()
        navigationTitle.text = "Расписание"
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
    
    func setupView() {
        view.backgroundColor = .white
        navigationItem.titleView = navigationTitle
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(
                systemName: "plus",
                withConfiguration: UIImage.SymbolConfiguration(
                    scale: .large
                )
            ),
            style: .plain,
            target: self,
            action: #selector(openSlotSelection)
        )
    }
    
    @objc func openSlotSelection() {
        let slotAdditionController = SlotAdditionViewController()
        navigationController?.pushViewController(slotAdditionController, animated: true)
    }

}
