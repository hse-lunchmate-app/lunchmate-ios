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
        setupView()
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
        setRightBarButton()
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
    
    func setRightBarButton() {
        if viewModel.getNotificationsCount() != 0 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(
                    systemName: "trash.circle",
                    withConfiguration: UIImage.SymbolConfiguration(
                        pointSize: 16
                    )
                ),
                style: .plain,
                target: self,
                action: #selector(deleteAllNotifications)
            )
            navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "Base90")
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func deleteAllNotifications() {
        Notifications.notifications.removeAll()
        updateBadge()
        setRightBarButton()
        collectionView.reloadData()
    }
    
    @objc func segmentedControlValueChanged() {
        print("Selected segment index: \(segmentedControl.selectedSegmentIndex)")
    }
}

// MARK: - TabBarDelegate

extension NotificationsViewController: TabBarDelegate {
    func updateBadge() {
        let notificationCount = viewModel.getNotificationsCount()
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
        let notificationCount = viewModel.getNotificationsCount()
        return String(notificationCount)
    }
    
}

extension NotificationsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getNotificationsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationsCollectionViewCell.identifier, for: indexPath) as? NotificationsCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(notification: Notifications.notifications[indexPath.row])
        cell.isUserInteractionEnabled = true
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
    func delete(inCell cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        Notifications.notifications.remove(at: indexPath.item)
        collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: [indexPath])
            updateBadge()
            setRightBarButton()
        })
    }
}
