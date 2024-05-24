//
//  CollegueSheduleCollectionViewCell.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 24.05.2024.
//

import UIKit

protocol CollegueSheduleCollectionViewCellDelegate: AnyObject {
    func inviteCollegue(cell: CollegueSheduleCollectionViewCell)
}

class CollegueSheduleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CollegueSheduleCollectionViewCell"
    weak var delegate: CollegueSheduleCollectionViewCellDelegate?
    
    let timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        timeLabel.textColor = .black
        return timeLabel
    }()
    
    lazy var inviteLabel: UILabel = {
        let inviteLabel = UILabel()
        inviteLabel.font = UIFont(name: "Roboto-Medium", size: 13)
        inviteLabel.text = "Позвать"
        inviteLabel.textAlignment = .center
        inviteLabel.textColor = .black
        inviteLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        inviteLabel.addGestureRecognizer(tapGesture)
        return inviteLabel
    }()
    
    func configure(start: String, end: String) {
        timeLabel.text = "\(start) - \(end)"
        self.backgroundColor = UIColor(named: "Yellow")
        self.layer.cornerRadius = 8
        [timeLabel, inviteLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            inviteLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            inviteLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            inviteLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            inviteLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
        ])
    }
    
    @objc func labelTapped(sender: UITapGestureRecognizer) {
        if let label = sender.view as? UILabel {
            if let cell = label.superview as? CollegueSheduleCollectionViewCell {
                delegate?.inviteCollegue(cell: cell)
            }
        }
    }
}
