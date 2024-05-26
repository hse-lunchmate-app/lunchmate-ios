//
//  FilterCollectionViewCell.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 26.05.2024.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FilterCollectionViewCell"
    
    let officeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 12)
        label.textColor = .black
        return label
    }()
    
    override func prepareForReuse() {
        officeNameLabel.text = nil
        self.backgroundColor = UIColor(named: "Base5")
    }
    
    func configure(officeName: String) {
        officeNameLabel.text = officeName
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = UIColor(named: "Base5")
        self.layer.cornerRadius = 10
        [officeNameLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        NSLayoutConstraint.activate([
            officeNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            officeNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
