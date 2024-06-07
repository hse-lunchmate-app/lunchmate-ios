//
//  FilterViewController.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 06.03.2024.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func updateData(filterOfficeId: Int)
}

class FilterViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: FilterViewModel
    weak var delegate: FilterViewControllerDelegate?
    
    // MARK: - Subviews
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 20)
        label.textColor = UIColor(named: "Base90")
        label.text = "Фильтр"
        return label
    }()
    
    let slideIdicator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 3
        return view
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Применить фильтр", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .disabled)
        button.backgroundColor = UIColor(named: "Yellow")
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 14)
        return button
    }()
    
    private lazy var collectionView: DynamicHeightCollectionView = {
        let layout = CustomViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
        collectionView.register(FilterCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FilterCollectionViewHeader.identifier)
        collectionView.register(FilterCollectionViewFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FilterCollectionViewFooter.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(named: "Base0")
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        return collectionView
    }()
    
    // MARK: - Init
    
    init(viewModel: FilterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.addTarget(self, action: #selector(saveFilter), for: .touchUpInside)
        bind()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getOffices() { [weak self] error in
            if error.code == 1 {
                let alert = UIAlertController(title: "Ошибка", message: "Отсутсвует подключение к интернету", preferredStyle: .alert)
                self?.present(alert, animated: true)
            }
        }
    }
    
    // MARK: - Methods
    
    @objc private func saveFilter() {
        if viewModel.isAnotherOffice() {
            delegate?.updateData(filterOfficeId: viewModel.offices.value[viewModel.selectedIndexPath[0].row].id)
        }
        self.dismiss(animated: true)
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(named: "Base0")
        [slideIdicator, titleLabel, collectionView, saveButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            slideIdicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            slideIdicator.heightAnchor.constraint(equalToConstant: 6),
            slideIdicator.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.15),
            slideIdicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: slideIdicator.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 34),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func bind() {
        viewModel.offices.bind { [weak self] value in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension FilterViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return FilterViewModel.FilterType.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = FilterViewModel.FilterType.allCases[section]
        switch sectionType {
        case .office:
            return viewModel.offices.value.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = FilterViewModel.FilterType.allCases[indexPath.section]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
        switch sectionType {
        case .office:
            cell.configure(officeName: viewModel.offices.value[indexPath.row].name)
            if indexPath == viewModel.selectedIndexPath[indexPath.section] {
                cell.backgroundColor = UIColor(named: "Yellow")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FilterCollectionViewHeader.identifier, for: indexPath) as! FilterCollectionViewHeader
            
            return headerView
        }
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FilterCollectionViewFooter.identifier, for: indexPath) as! FilterCollectionViewFooter
            return footerView
        }
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FilterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionType = FilterViewModel.FilterType.allCases[indexPath.section]
        switch sectionType {
        case .office:
            let referenceHeight: CGFloat = 22
            let padding: CGFloat = 10
            let text = viewModel.offices.value[indexPath.row].name
            let width = text.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 12) ?? .systemFont(ofSize: 12)]).width + padding
            return CGSize(width: width, height: referenceHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: viewModel.selectedIndexPath[indexPath.section]) as? FilterCollectionViewCell {
            cell.backgroundColor = UIColor(named: "Base5")
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell {
            cell.backgroundColor = UIColor(named: "Yellow")
            viewModel.selectedIndexPath[indexPath.section] = indexPath
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 70.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == viewModel.selectedIndexPath.count - 1 {
            return CGSize(width: 0, height: 16.5)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
}


