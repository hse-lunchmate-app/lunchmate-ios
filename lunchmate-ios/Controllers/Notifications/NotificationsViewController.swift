//
//  NotificationsViewController.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 27.02.2024.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel = NotificationsViewModel()
    
    // MARK: - Subviews
    
    private let navigationTitle: UILabel = {
        let navigationTitle = UILabel()
        navigationTitle.text = "Уведомления"
        navigationTitle.textColor = UIColor(named: "Base90")
        navigationTitle.font = UIFont(name: "SFPro-Semibold", size: 17)
        navigationTitle.sizeToFit()
        return navigationTitle
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let items = ["Приглашения", "История"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NotificationsCollectionViewCell.self, forCellWithReuseIdentifier: NotificationsCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(named: "Base0")
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInsetReference = .fromLayoutMargins
        return collectionView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getLunches()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "Base0")
        navigationItem.titleView = navigationTitle
        [collectionView, segmentedControl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func bind() {
        viewModel.lunches.bind { [weak self] value in
            DispatchQueue.main.async {
                self?.updateBadge()
                self?.collectionView.reloadData()
            }
        }
    }
    
    @objc func segmentedControlValueChanged() {
        collectionView.reloadData()
    }
}

// MARK: - TabBarDelegate

extension NotificationsViewController: TabBarDelegate {
    func updateBadge() {
        let notificationCount = viewModel.getNotificationsCountForBadge()
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
    
    func getBadge() -> Int {
        let notificationCount = viewModel.getNotificationsCountForBadge()
        return notificationCount
    }
    
}

extension NotificationsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getNotificationsCount(index: segmentedControl.selectedSegmentIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationsCollectionViewCell.identifier, for: indexPath) as? NotificationsCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(lunch: viewModel.lunchesForCollectionView[indexPath.row], selectedIndex: segmentedControl.selectedSegmentIndex)
        cell.delegate = self
        return cell
    }
    
}

extension NotificationsViewController: UICollectionViewDelegateFlowLayout {
    
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
    
}

extension NotificationsViewController: NotificationsCollectionViewCellDelegate {
    func reloadCollectionView(decline: Bool) {
        viewModel.getLunches()
        var message = "Приглашение успешно отклонено"
        if decline == false {
            message = "Приглашение успешно принято"
        }
        let alert = UIAlertController(title: "Успех", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
