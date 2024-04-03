//
//  AccountEditingHeaderCollectionView.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 01.04.2024.
//

import UIKit

protocol AccountEditingHeaderCollectionViewDelegate: AnyObject {
    func openMenu()
}

class AccountEditingHeaderCollectionView: UICollectionReusableView {
    
    // MARK: - Properties
    
    weak var delegate: AccountEditingHeaderCollectionViewDelegate?
    
    // MARK: - Identifier
    
    static let identifier = "AccountEditingHeaderCollectionView"
    
    // MARK: - Subviews
    
    private lazy var header: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont(name: "Roboto-Medium", size: 15)
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 2.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 44
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openMenu)))
        return imageView
    }()
    
    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        header.text = nil
        imageView.image = nil
        imageView.removeConstraints(imageView.constraints)
        header.removeConstraints(header.constraints)
    }
    
    // MARK: - Methods
    
    func configure(title: String, image: UIImage?) {
        header.text = title
        [header, imageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        if let image {
            imageView.image = image
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: self.topAnchor),
                imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                imageView.heightAnchor.constraint(equalToConstant: 88),
                imageView.widthAnchor.constraint(equalToConstant: 88),
                header.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            ])
        }
        
        NSLayoutConstraint.activate([
            header.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            header.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
    
    @objc func openMenu() {
        delegate?.openMenu()
    }
}

// MARK: - EditAccountViewControllerDelegate

extension AccountEditingHeaderCollectionView: AccountEditingViewControllerDelegate {
    func setNewPhoto(photo: UIImage) {
        imageView.image = photo
    }
}
