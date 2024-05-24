//
//  AccountViewController.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 27.02.2024.
//

import UIKit

class AccountViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: AccountViewModel
    
    // MARK: - Init
    
    init(viewModel: AccountViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserInfo), name: Notification.Name("AccountInfoDidChange"), object: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("AccountInfoDidChange"), object: nil)
    }
    
    // MARK: - Subviews
    
    private let navigationTitle: UILabel = {
        let navigationTitle = UILabel()
        navigationTitle.text = "Профиль"
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
    
    private lazy var profileCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let profileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        profileCollectionView.register(AccountCollectionViewCell.self, forCellWithReuseIdentifier: AccountCollectionViewCell.identifier)
        profileCollectionView.register(AccountSheduleCollectionViewCell.self, forCellWithReuseIdentifier: AccountSheduleCollectionViewCell.identifier)
        profileCollectionView.register(AccountHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AccountHeaderCollectionView.identifier)
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        profileCollectionView.showsVerticalScrollIndicator = false
        profileCollectionView.backgroundColor = UIColor(named: "Base0")
        profileCollectionView.contentInsetAdjustmentBehavior = .always
        profileCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        (profileCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        (profileCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInsetReference = .fromLayoutMargins
        return profileCollectionView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if viewModel.user.value == nil {
            viewModel.retrieveUser(with: "id3") { error in
                if let error = error {
                    // Обработка ошибки
                }
            }
        }
    }
    
    // MARK: - Methods
    
    private func bind() {
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
        viewModel.user.bind { [weak self] user in
            DispatchQueue.main.async {
                self?.viewModel.createDescriptions(user: user)
                self?.profileCollectionView.reloadData()
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "Base0")
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        navigationItem.titleView = navigationTitle
        [profileCollectionView, activityIndicatorView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            profileCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            profileCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 50),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 50),
            profileCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
        if let user = viewModel.user.value {
            let viewModel = AccountEditingViewModel(user: user)
            let controller = AccountEditingViewController(viewModel: viewModel)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func updateUserInfo(notification: Notification) {
        if let updatedUser = notification.object as? User {
            DispatchQueue.main.async {
                self.viewModel.updateUser(newUser: updatedUser)
                self.viewModel.retrieveUser(with: "id3") { [weak self] error in
                    if let error = error {
                        // Обработка ошибки
                    }
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension AccountViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = AccountViewModel.Sections.allCases[section]
        return viewModel.numberOfRows(in: sectionType)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = AccountViewModel.Sections.allCases[indexPath.section]
        switch sectionType {
        case .info:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCollectionViewCell.identifier, for: indexPath) as? AccountCollectionViewCell else { return UICollectionViewCell() }
            let descriptions = viewModel.descriptions[indexPath.row]
            switch descriptions {
            case .description(let title, let description, let imageTitle):
                cell.configure(
                    title: title,
                    description: description,
                    imageTitle: imageTitle
                )
            }
            return cell
        case .shedule:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountSheduleCollectionViewCell.identifier, for: indexPath) as? AccountSheduleCollectionViewCell else { return UICollectionViewCell() }
            cell.configure()
            cell.sheduleDelegate = self
            if let id = viewModel.user.value?.id {
                cell.viewModel.changeUserId(id: id)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 && !viewModel.isCanEdit {
            UIPasteboard.general.string = viewModel.getTgDescription()
            
            let dimView = UIView(frame: UIScreen.main.bounds)
            dimView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            
            let messageView = CustomMessageView(message: "Telegram скопирован")
            messageView.frame.origin.y = UIScreen.main.bounds.height
            messageView.alpha = 0
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let mainWindow = windowScene.windows.first {
                    mainWindow.addSubview(dimView)
                    mainWindow.addSubview(messageView)
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        messageView.alpha = 1
                        messageView.frame.origin.y -= messageView.frame.height + 35
                    })
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                        UIView.animate(withDuration: 0.3, animations: {
                            dimView.backgroundColor = UIColor.black.withAlphaComponent(0)
                            messageView.alpha = 0
                            messageView.frame.origin.y += messageView.frame.height
                        }, completion: { _ in
                            dimView.removeFromSuperview()
                            messageView.removeFromSuperview()
                        })
                    }
                }
            }
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionType = AccountViewModel.Sections.allCases[indexPath.section]
        switch sectionType {
        case .info:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AccountHeaderCollectionView.identifier, for: indexPath) as? AccountHeaderCollectionView else { return UICollectionReusableView() }
            var image: UIImage? = UIImage(named: "Mock photo")
            var isImageLoaded = false
            self.viewModel.getImage { data in
                if let imageData = data {
                    image = UIImage(data: imageData)
                    isImageLoaded = true
                } else {
                    isImageLoaded = true
                }
                if isImageLoaded {
                    header.configure(name: self.viewModel.user.value?.name ?? "", login: self.viewModel.user.value?.login ?? "", image: image)
                }
            }
            return header
        case .shedule:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AccountHeaderCollectionView.identifier, for: indexPath) as? AccountHeaderCollectionView else { return UICollectionReusableView() }
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sectionType = AccountViewModel.Sections.allCases[section]
        switch sectionType {
        case .info:
            return CGSize(width: view.frame.size.width, height: 176)
        case .shedule:
            return CGSize(width: view.frame.size.width, height: 0)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AccountViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionType = AccountViewModel.Sections.allCases[indexPath.section]
        switch sectionType {
        case .info:
            let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
            let referenceHeight: CGFloat = 100
            let referenceWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
            - sectionInset.left
            - sectionInset.right
            - collectionView.contentInset.left
            - collectionView.contentInset.right
            return CGSize(width: referenceWidth, height: referenceHeight)
        case .shedule:
            if !viewModel.isCanEdit {
                let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
                let referenceWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
                - sectionInset.left
                - sectionInset.right
                - collectionView.contentInset.left
                - collectionView.contentInset.right
                return CGSize(width: referenceWidth, height: 166)
            }
            else {
                return CGSize(width: 0, height: 0)
            }
        }
    }
}

extension AccountViewController: AccountSheduleCollectionViewCellDelegate {
    func showAlert(error: NSError?) {
        if error?.code == 403 {
            let alert = UIAlertController(title: "Ошибка", message: "Нельзя пригласить коллегу на прошедший временной слот!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Успех", message: "Приглашение успешно отправлено", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
