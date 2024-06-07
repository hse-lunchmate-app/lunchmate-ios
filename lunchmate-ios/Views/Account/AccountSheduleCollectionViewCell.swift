//
//  AccountSheduleCollectionViewCell.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 24.05.2024.
//

import UIKit

protocol AccountViewControllerDelegate: AnyObject {
    func changeIsRightButtonEnabled()
    func changeIsLeftButtonEnabled()
}

protocol AccountSheduleCollectionViewCellDelegate: AnyObject {
    func showAlert(error: NSError?)
}

final class AccountSheduleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AccountSheduleCollectionViewCell"
    let viewModel = AccountScheduleCellViewModel()
    weak var delegate: AccountViewControllerDelegate?
    weak var sheduleDelegate: AccountSheduleCollectionViewCellDelegate?
    
    lazy var plugLabel: UILabel = {
        let label = UILabel()
        label.text = "Здесь пока ничего нет..."
        label.font = UIFont(name: "Roboto-Medium", size: 18)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var collegueSheduleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collegueSheduleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collegueSheduleCollectionView.register(CollegueSheduleCollectionViewCell.self, forCellWithReuseIdentifier: CollegueSheduleCollectionViewCell.identifier)
        collegueSheduleCollectionView.register(CollegueSheduleHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollegueSheduleHeaderCollectionView.identifier)
        collegueSheduleCollectionView.delegate = self
        collegueSheduleCollectionView.dataSource = self
        collegueSheduleCollectionView.showsVerticalScrollIndicator = false
        collegueSheduleCollectionView.backgroundColor = UIColor(named: "tinkoffBgLabel")
        collegueSheduleCollectionView.contentInsetAdjustmentBehavior = .always
        collegueSheduleCollectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        (collegueSheduleCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        (collegueSheduleCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInsetReference = .fromLayoutMargins
        collegueSheduleCollectionView.isScrollEnabled = false
        collegueSheduleCollectionView.layer.cornerRadius = 8
        return collegueSheduleCollectionView
    }()
    
    func configure() {
        bind()
        [collegueSheduleCollectionView, plugLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        NSLayoutConstraint.activate([
            collegueSheduleCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            collegueSheduleCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collegueSheduleCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collegueSheduleCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            plugLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            plugLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 36)
        ])
        viewModel.changeCurrentDate(direction: nil)
    }
    
    func bind() {
        viewModel.newDateText.bind { [weak self] date in
            self?.collegueSheduleCollectionView.reloadData()
        }
        viewModel.timeslots.bind { [weak self] timeslots in
            DispatchQueue.main.async {
                if !timeslots.isEmpty {
                    self?.plugLabel.isHidden = true
                } else {
                    self?.plugLabel.isHidden = false
                }
                self?.collegueSheduleCollectionView.reloadData()
            }
        }
    }
    
}

extension AccountSheduleCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.timeslots.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollegueSheduleCollectionViewCell.identifier, for: indexPath) as? CollegueSheduleCollectionViewCell else { return UICollectionViewCell() }
        let timeslot = viewModel.timeslots.value[indexPath.row]
        let start = viewModel.makeDateString(from: timeslot.startTime)
        let end = viewModel.makeDateString(from: timeslot.endTime)
        cell.configure(start: start, end: end)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollegueSheduleHeaderCollectionView.identifier, for: indexPath) as? CollegueSheduleHeaderCollectionView else { return UICollectionReusableView() }
        header.configure(date: viewModel.newDateText.value)
        header.delegate = self
        delegate = header
        return header
    }
}

extension AccountSheduleCollectionViewCell: CollegueSheduleHeaderCollectionViewDelegate {
    func updateRightDay() {
        if !viewModel.changeCurrentDate(direction: true) {
            delegate?.changeIsRightButtonEnabled()
        }
    }
    
    func updateLeftDay() {
        if !viewModel.changeCurrentDate(direction: false) {
            delegate?.changeIsLeftButtonEnabled()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AccountSheduleCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: self.frame.width - 50, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 88, height: 58)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: self.frame.width / 2 - 88 - 20, bottom: 0, right: self.frame.width / 2 - 88 - 20)
    }
}

extension AccountSheduleCollectionViewCell: CollegueSheduleCollectionViewCellDelegate {
    func inviteCollegue(cell: CollegueSheduleCollectionViewCell) {
        if let indexPath = collegueSheduleCollectionView.indexPath(for: cell) {
            viewModel.postNewLunchInvite(timeslot: viewModel.timeslots.value[indexPath.row]) { [weak self] error in
                DispatchQueue.main.async {
                    if let error = error as? NSError {
                        self?.sheduleDelegate?.showAlert(error: error)
                    } else {
                        self?.sheduleDelegate?.showAlert(error: nil)
                    }
                }
            }
        }
    }
}
