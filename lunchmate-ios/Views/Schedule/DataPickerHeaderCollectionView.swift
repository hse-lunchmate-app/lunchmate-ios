//
//  DataPickerHeaderCollectionView.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 15.04.2024.
//

import UIKit

protocol DataPickerHeaderCollectionViewDelegate: AnyObject {
    func updateRightWeek()
    func updateLeftWeek()
}

class DataPickerHeaderCollectionView: UICollectionReusableView {
    static let identifier = "DataPickerHeaderCollectionReusableView"
    
    weak var delegate: DataPickerHeaderCollectionViewDelegate?
    
    private let rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(
                systemName: "chevron.right",
                withConfiguration: UIImage.SymbolConfiguration(
                    scale: .large
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
                    scale: .large
                )
            ),
            for: .normal
        )
        button.isEnabled = false
        return button
    }()
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFPro-Semibold", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    func configure(month: String) {
        monthLabel.text = month
        [leftButton, monthLabel, rightButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        rightButton.addTarget(self, action: #selector(updateRightWeek), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(updateLeftWeek), for: .touchUpInside)
        NSLayoutConstraint.activate([
            rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            monthLabel.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor),
            monthLabel.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor),
            monthLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 36 - 5),
            leftButton.topAnchor.constraint(equalTo: self.topAnchor),
            monthLabel.topAnchor.constraint(equalTo: self.topAnchor),
            rightButton.topAnchor.constraint(equalTo: self.topAnchor),
        ])
    }
    
    @objc func updateRightWeek() {
        leftButton.isEnabled = true
        delegate?.updateRightWeek()
    }
    
    @objc func updateLeftWeek() {
        rightButton.isEnabled = true
        delegate?.updateLeftWeek()
    }
}

extension DataPickerHeaderCollectionView: ScheduleViewControllerDelegate {
    func changeIsLeftButtonEnabled() {
        leftButton.isEnabled = false
    }
    
    func changeIsRightButtonEnabled() {
        rightButton.isEnabled = false
    }
}


