//
//  AccountEditingViewController.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 27.02.2024.
//

import UIKit
import Photos

protocol AccountEditingViewControllerDelegate: AnyObject {
    func setNewPhoto(photo: UIImage)
}

class AccountEditingViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: AccountEditingViewModel
    weak var delegate: AccountEditingViewControllerDelegate?
    
    // MARK: - Init
    
    init(viewModel: AccountEditingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    
    private let navigationTitle: UILabel = {
        let navigationTitle = UILabel()
        navigationTitle.text = "Редактирование профиля"
        navigationTitle.textColor = UIColor(named: "Base90")
        navigationTitle.font = UIFont(name: "SFPro-Semibold", size: 17)
        navigationTitle.sizeToFit()
        return navigationTitle
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AccountEditingCollectionViewCell.self, forCellWithReuseIdentifier: AccountEditingCollectionViewCell.identifier)
        collectionView.register(AccountEditingHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AccountEditingHeaderCollectionView.identifier)
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
        navigationItem.rightBarButtonItem?.isEnabled = false
        [collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    @objc private func saveChanges() {
        setNewData()
        viewModel.changeAccountInfo()
        navigationController?.popViewController(animated: true)
    }
    
    private func setNewData() {
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                if let cell = collectionView.cellForItem(at: IndexPath(item: item, section: section)) as? AccountEditingCollectionViewCell {
                    let data = cell.getTitleAndDescription()
                    viewModel.setNewInfo(title: data.0, description: data.1)
                }
            }
        }
    }
    
    private func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        setNewData()
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func deletePhoto() {
        if viewModel.user.image != nil {
            changeSaveButtonColor(isBlue: true)
        }
        else {
            changeSaveButtonColor(isBlue: false)
        }
        viewModel.setNewImageURL(url: nil)
        collectionView.reloadData()
    }
    
}

// MARK: - AccountEditingHeaderCollectionViewDelegate

extension AccountEditingViewController: AccountEditingHeaderCollectionViewDelegate {
    func openMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Выбрать новое фото", style: .default) { (action) in
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self.choosePhotoFromLibrary()
                    }
                case .denied, .restricted:
                    // Разрешение отклонено или ограничено, обработка случая отсутствия доступа к галерее
                    break
                case .notDetermined:
                    // Пользователь еще не принял решение, можно попросить разрешение еще раз
                    break
                case .limited:
                    break
                @unknown default:
                    // Другие случаи, обработка по умолчанию
                    break
                }
            }
        }
        alertController.addAction(action1)
        if viewModel.isImageUrlAvilible() {
            let action2 = UIAlertAction(title: "Удалить фото", style: .default) { (action) in
                self.deletePhoto()
            }
            alertController.addAction(action2)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (action) in }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension AccountEditingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountEditingCollectionViewCell.identifier, for: indexPath) as? AccountEditingCollectionViewCell else { return UICollectionViewCell() }
        configureCell(for: cell, at: indexPath)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        AccountEditingViewModel.Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = AccountEditingViewModel.Section.allCases[section]
        switch sectionType {
        case .personalData:
            return 4
        case .contactInformation:
            return 1
        case .accountData:
            return 1
        }
    }

    func configureCell(for cell: AccountEditingCollectionViewCell, at indexPath: IndexPath) {
        let sectionType = AccountEditingViewModel.Section.allCases[indexPath.section]
        switch sectionType {
        case .personalData:
            configurePersonalDataCell(cell, at: indexPath)
        case .contactInformation:
            configureContactInformationCell(cell, at: indexPath)
        case .accountData:
            configureAccountDataCell(cell, at: indexPath)
        }
    }
    
    func configurePersonalDataCell(_ cell: AccountEditingCollectionViewCell, at indexPath: IndexPath) {
        let index = AccountEditingViewModel.PersonalData.allCases[indexPath.row]
        switch index {
        case .name:
            let viewModel = AccountEditingCollectionViewCellViewModel(
                title: index.rawValue,
                description: viewModel.user.name
            )
            cell.delegate = self
            cell.configure(viewModel: viewModel)
        case .office:
            let viewModel = AccountEditingCollectionViewCellViewModel(
                title: index.rawValue,
                description: viewModel.user.office.name
            )
            cell.delegate = self
            cell.configure(viewModel: viewModel)
        case .tastes:
            let viewModel = AccountEditingCollectionViewCellViewModel(
                title: index.rawValue,
                description: viewModel.user.tastes
            )
            cell.delegate = self
            cell.configure(viewModel: viewModel)
        case .about:
            let viewModel = AccountEditingCollectionViewCellViewModel(
                title: index.rawValue,
                description: viewModel.user.aboutMe
            )
            cell.delegate = self
            cell.configure(viewModel: viewModel)
        }
    }
    
    func configureContactInformationCell(_ cell: AccountEditingCollectionViewCell, at indexPath: IndexPath) {
        let index = AccountEditingViewModel.ContactInformation.allCases[indexPath.row]
        switch index {
        case .tg:
            let viewModel = AccountEditingCollectionViewCellViewModel(
                title: index.rawValue,
                description: viewModel.user.messenger
            )
            cell.delegate = self
            cell.configure(viewModel: viewModel)
        }
    }
    
    func configureAccountDataCell(_ cell: AccountEditingCollectionViewCell, at indexPath: IndexPath) {
        let index = AccountEditingViewModel.AccountData.allCases[indexPath.row]
        switch index {
        case .login:
            let viewModel = AccountEditingCollectionViewCellViewModel(
                title: index.rawValue,
                description: viewModel.user.login
            )
            cell.delegate = self
            cell.configure(viewModel: viewModel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AccountEditingHeaderCollectionView.identifier, for: indexPath) as? AccountEditingHeaderCollectionView else { return UICollectionReusableView() }
        header.delegate = self
        configureHeader(for: header, at: indexPath)
        return header
    }
    
    func configureHeader(for header: AccountEditingHeaderCollectionView, at indexPath: IndexPath) {
        let sectionType = AccountEditingViewModel.Section.allCases[indexPath.section]
        if sectionType == .personalData {
            viewModel.getImage { data in
                if let imageData = data, let image = UIImage(data: imageData) {
                    header.configure(title: sectionType.rawValue, image: image)
                } else {
                    header.configure(title: sectionType.rawValue, image: UIImage(named: "Mock photo"))
                }
            }
        } else {
            header.configure(title: sectionType.rawValue, image: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sectionType = AccountEditingViewModel.Section.allCases[section]
        let height: Double = sectionType == .personalData ? 130 : 50
        return CGSize(width: view.frame.size.width, height: height)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AccountEditingViewController: UICollectionViewDelegateFlowLayout {
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

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension AccountEditingViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageUrl = info[.imageURL] as? URL {
            if viewModel.user.image != imageUrl {
                changeSaveButtonColor(isBlue: true)
            }
            else {
                changeSaveButtonColor(isBlue: false)
            }
            viewModel.setNewImageURL(url: imageUrl)
            collectionView.reloadData()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - AccountEditingCollectionViewCellDelegate

extension AccountEditingViewController: AccountEditingCollectionViewCellDelegate {
    func changeSaveButtonColor(isBlue: Bool) {
        if isBlue {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}
