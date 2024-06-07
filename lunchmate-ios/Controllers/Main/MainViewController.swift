//
//  MainViewController.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 07.02.2024.
//

import UIKit

class MainViewController: DefaultViewController {
    
    // MARK: - Properties
    
    private var viewModel = MainViewModel()
    private var timer: Timer?
    
    // MARK: - Init
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("AccountInfoDidChange"), object: nil)
    }
    
    // MARK: - Subviews
    
    private let navigationTitle: UILabel = {
        let navigationTitle = UILabel()
        navigationTitle.text = "Поиск коллег"
        navigationTitle.textColor = UIColor(named: "Base90")
        navigationTitle.font = UIFont(name: "SFPro-Semibold", size: 17)
        navigationTitle.sizeToFit()
        return navigationTitle
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchTextField.layer.borderWidth = 1
        searchController.searchBar.searchTextField.layer.cornerRadius = 8
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.changeSearchBarColor(color: .white)
        searchController.searchBar.searchTextField.leftView?.tintColor = UIColor(named: "Base80")
        searchController.searchBar.searchTextField.layer.borderColor = UIColor(named: "Base20")?.cgColor
        searchController.searchBar.setImage(UIImage(systemName: "xmark"), for: .clear, state: .normal)
        return searchController
    }()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navigationItem.searchController != nil {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        getUserWithRetry()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateFilter), name: Notification.Name("AccountInfoDidChange"), object: nil)
        bindViewModel()
        setupView()
    }
    
    // MARK: - Methods
    
    override func setupView() {
        super.setupView()
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        setupNavigationItem()
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func setupNavigationItem() {
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
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
    }
    
    private func getUserWithRetry() {
        viewModel.getUser() { [weak self] error in
            if error?.code == 1 {
                if UserDefaults.standard.bool(forKey: "isPresentAlert") == true {
                    self?.presentAlert()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self?.getUserWithRetry()
                }
            } else if error == nil {
                self?.getUsersWithRetry()
                UserDefaults.standard.set(true, forKey: "isPresentAlert")
                DispatchQueue.main.async {
                    if self?.presentedViewController != nil {
                        self?.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    private func getUsersWithRetry() {
        viewModel.getUsers() { [weak self] error in
            if error?.code == 1 {
                if UserDefaults.standard.bool(forKey: "isPresentAlert") == true {
                    self?.presentAlert()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self?.getUsersWithRetry()
                }
            } else if error == nil {
                UserDefaults.standard.set(true, forKey: "isPresentAlert")
                DispatchQueue.main.async {
                    if self?.presentedViewController != nil {
                        self?.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    private func presentAccountViewController(id: String) {
        let accountViewModel = AccountViewModel()
        accountViewModel.changeIsCanEdit()
        accountViewModel.setUserId(newValue: id)
        let accountViewController = AccountViewController(viewModel: accountViewModel)
        navigationController?.pushViewController(accountViewController, animated: true)
    }
    
    private func bindViewModel() {
        viewModel.isLoading.bind({ [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicatorView.startAnimating()
                } else {
                    self?.activityIndicatorView.stopAnimating()
                }
            }
        })
        viewModel.filteredData.bind({ [weak self] (users) in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
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
    
    @objc private func updateFilter() {
        DispatchQueue.main.async { [weak self] in
            if self?.navigationItem.rightBarButtonItem?.tintColor == .gray {
                self?.viewModel.filterOfficeId = nil
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
        cell.configure(person: viewModel.filteredData.value[indexPath.row])
        return cell
    }
}

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
        presentAccountViewController(id: viewModel.filteredData.value[indexPath.row].id)
    }
}

// MARK: - UISearchResultsUpdating

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterUsers(text: searchController.searchBar.text)
    }
}

// MARK: - FilterViewControllerDelegate

extension MainViewController: FilterViewControllerDelegate {
    func updateData(filterOfficeId: Int) {
        if filterOfficeId != viewModel.user?.office.id {
            navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "Yellow")
        } else {
            navigationItem.rightBarButtonItem?.tintColor = .gray
        }
        if filterOfficeId != viewModel.filterOfficeId {
            viewModel.filterOfficeId = filterOfficeId
            getUsersWithRetry()
        }
    }
}

