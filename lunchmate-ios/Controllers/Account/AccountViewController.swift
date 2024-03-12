//
//  AccountViewController.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 27.02.2024.
//

import UIKit

class AccountViewController: UIViewController {
    
    var viewModel: AccountViewModel
    
    init(viewModel: AccountViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    
    private let navigationTitle: UILabel = {
        let navigationTitle = UILabel()
        navigationTitle.text = "Профиль"
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
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        navigationItem.titleView = navigationTitle
        if viewModel.isCanEdit {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(
                    systemName: "square.and.pencil",
                    withConfiguration: UIImage.SymbolConfiguration(
                        pointSize: 16.0
                    )
                ),
                style: .plain,
                target: self,
                action: #selector(openEditAccountView)
            )
        }
    }
    
    @objc func openEditAccountView() {
        let controller = EditAccountViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

}
