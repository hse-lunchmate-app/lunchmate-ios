//
//  AccountCollectionViewCell.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 12.03.2024.
//

import UIKit

final class AccountCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Identifier
    
    static let identifier = "AccountCollectionViewCell"
    
    // MARK: - Subviews

    private var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont(name: "Roboto-Regular", size: 10)
        label.textColor = UIColor(named: "tinkoffLabel")
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont(name: "Roboto-Regular", size: 15)
        label.textColor = .black
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private var stackWithLabels: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        descriptionLabel.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left - 48
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }

    // MARK: - Methods

    func configure(title: String, description: String, imageTitle: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        imageView.image = UIImage(named: imageTitle)
    }

    private func configureUI() {
        contentView.backgroundColor = UIColor(named: "tinkoffBgLabel")
        contentView.layer.cornerRadius = 8

        [titleLabel, descriptionLabel].forEach {
            stackWithLabels.addArrangedSubview($0)
        }
        
        [stackWithLabels, imageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            stackWithLabels.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 8),
            stackWithLabels.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            stackWithLabels.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -8),
            stackWithLabels.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 4)
        ])
    }
}
