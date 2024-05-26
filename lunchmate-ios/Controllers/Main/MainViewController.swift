//
//  MainViewController.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 07.02.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private var users: [MainCellViewModel] = []
    private var viewModel = MainViewModel()
    
    // MARK: - Subviews
    
    private let navigationTitle: UILabel = {
        let navigationTitle = UILabel()
        navigationTitle.text = "Поиск коллег"
        navigationTitle.textColor = UIColor(named: "Base90")
        navigationTitle.font = UIFont(name: "SFPro-Semibold", size: 17)
        navigationTitle.sizeToFit()
        return navigationTitle
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchTextField.layer.borderWidth = 1
        searchController.searchBar.searchTextField.layer.cornerRadius = 8
        searchController.searchBar.searchTextField.layer.borderColor = UIColor(named: "Base20")?.cgColor
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.changeSearchBarColor(color: .white)
        searchController.searchBar.searchTextField.leftView?.tintColor = UIColor(named: "Base80")
        searchController.definesPresentationContext = false
        if let xmarkImage = UIImage(systemName: "xmark") {
            searchController.searchBar.setImage(xmarkImage, for: .clear, state: .normal)
        }
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Найти по имени",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "Base30") ?? UIColor.lightGray,
                NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
            ]
        )
        let cancelButton = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        cancelButton.title = "Отмена"
        let offset = UIOffset(horizontal: 0, vertical: 5)
        cancelButton.setTitlePositionAdjustment(offset, for: .default)
        cancelButton.setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
            ],
            for: .normal
        )
        return searchController
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(named: "Base0")
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInsetReference = .fromLayoutMargins
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let searchController = navigationItem.searchController {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            definesPresentationContext = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getUser()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupView()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "Base0")
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        navigationItem.titleView = navigationTitle
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(
                systemName: "line.3.horizontal.decrease",
                withConfiguration: UIImage.SymbolConfiguration(
                    scale: .medium
                )
            ),
            style: .plain,
            target: self,
            action: #selector(openFilter)
        )
        navigationItem.rightBarButtonItem?.tintColor = .gray
        view.addSubview(collectionView)
        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 50),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func bindViewModel() {
        viewModel.isLoading.bind({ [weak self] isLoading in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                if isLoading {
                    self.activityIndicatorView.startAnimating()
                } else {
                    self.activityIndicatorView.stopAnimating()
                }
            }
        })
        viewModel.filteredData.bind({ [weak self] (users) in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.users = users
                self.collectionView.reloadData()
            }
        })
    }
    
    @objc private func openFilter() {
        if let id = viewModel.filterOfficeId {
            let filterViewModel = FilterViewModel(userOfficeId: id)
            let filterController = FilterViewController(viewModel: filterViewModel)
            filterController.delegate = self
            present(filterController, animated: true, completion: nil)
        }
    }
    
    private func openModalView(id: String) {
        viewModel.retrieveUser(with: id) { [weak self] user, error in
            if let error = error {
                // Обработка ошибки
            } else if let user = user {
                DispatchQueue.main.async {
                    let accountViewModel = AccountViewModel()
                    accountViewModel.changeIsCanEdit()
                    let accountViewController = AccountViewController(viewModel: accountViewModel)
                    accountViewModel.user.value = user
                    self?.navigationController?.pushViewController(accountViewController, animated: true)
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(person: users[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
            let referenceHeight: CGFloat = 100
            let referenceWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
                - sectionInset.left
                - sectionInset.right
                - collectionView.contentInset.left
                - collectionView.contentInset.right
            return CGSize(width: referenceWidth, height: referenceHeight)
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.openModalView(id: viewModel.filteredData.value[indexPath.row].id)
    }
}

// MARK: - UISearchResultsUpdating

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterUsers(text: searchController.searchBar.text)
    }
}

extension MainViewController: FilterViewControllerDelegate {
    func updateData(filterOfficeId: Int) {
        if filterOfficeId != viewModel.user?.office.id {
            navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "Yellow")
        } else {
            navigationItem.rightBarButtonItem?.tintColor = .gray
        }
        if filterOfficeId != viewModel.filterOfficeId {
            viewModel.filterOfficeId = filterOfficeId
            viewModel.getUsers()
        }
    }
}

