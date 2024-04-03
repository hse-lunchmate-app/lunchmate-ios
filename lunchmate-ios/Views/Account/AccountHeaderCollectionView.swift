//
//  AccountHeaderCollectionView.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 12.03.2024.
//

import UIKit

class AccountHeaderCollectionView: UICollectionReusableView {
    
    // MARK: - Identifier
    
    static let identifier = "HeaderCollectionReusableView"
    
    // MARK: - Subviews
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 2.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 44
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont(name: "Roboto-Medium", size: 22)
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont(name: "Roboto-Regular", size: 16)
        label.textColor = UIColor(named: "Base80")
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        loginLabel.text = nil
    }
    
    // MARK: - Methods
    
    func configure(name: String, login: String, image: UIImage?) {
        if let image {
            imageView.image = image
        }
        nameLabel.text = name
        loginLabel.text = "@" + login
        
        [imageView, nameLabel, loginLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 88),
            imageView.widthAnchor.constraint(equalToConstant: 88),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            loginLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loginLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }
}
