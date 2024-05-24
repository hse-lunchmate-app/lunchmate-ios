//
//  CollegueSheduleHeaderCollectionView.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 24.05.2024.
//

import UIKit

protocol CollegueSheduleHeaderCollectionViewDelegate: AnyObject {
    func updateRightDay()
    func updateLeftDay()
}

class CollegueSheduleHeaderCollectionView: UICollectionReusableView {
    
    static let identifier = "CollegueSheduleHeaderCollectionView"
    weak var delegate: CollegueSheduleHeaderCollectionViewDelegate?
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = UIFont(name: "Roboto-Medium", size: 18)
        label.textColor = UIColor(named: "Base90")
        return label
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(
                systemName: "chevron.right",
                withConfiguration: UIImage.SymbolConfiguration(
                    scale: .medium
                )
            ),
            for: .normal
        )
        return button
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(
                systemName: "chevron.left",
                withConfiguration: UIImage.SymbolConfiguration(
                    scale: .medium
                )
            ),
            for: .normal
        )
        button.isEnabled = false
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor(named: "Base90")
        return label
    }()
    
    func configure(date: String) {
        [title, leftButton, dateLabel, rightButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        dateLabel.text = date
        
        rightButton.addTarget(self, action: #selector(updateRightDay), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(updateLeftDay), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            title.topAnchor.constraint(equalTo: self.topAnchor),
            rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            dateLabel.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor),
            dateLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 36),
            leftButton.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 9),
            dateLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            rightButton.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 9),
        ])
    }
    
    @objc func updateRightDay() {
        leftButton.isEnabled = true
        delegate?.updateRightDay()
    }
    
    @objc func updateLeftDay() {
        rightButton.isEnabled = true
        delegate?.updateLeftDay()
    }
}

extension CollegueSheduleHeaderCollectionView: AccountViewControllerDelegate {
    func changeIsRightButtonEnabled() {
        rightButton.isEnabled = false
    }
    
    func changeIsLeftButtonEnabled() {
        leftButton.isEnabled = false
    }
}
