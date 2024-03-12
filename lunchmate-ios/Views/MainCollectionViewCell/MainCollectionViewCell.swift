//
//  MainCollectionViewCell.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 28.02.2024.
//

import UIKit

final class MainCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Identifier
    
    static let identifier = "MainCollectionViewCell"
    
    // MARK: - Subviews

    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont(name: "Roboto-Medium", size: 24)
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private var tastePreferencesLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont(name: "Roboto-Regular", size: 16)
        label.textColor = .black
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var stackWithLabels: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: "Mock photo")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 2.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
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
        nameLabel.text = nil
        tastePreferencesLabel.text = nil
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        tastePreferencesLabel.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left - 88
        nameLabel.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left - 88
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }

    // MARK: - Methods

    func configure(person: MainCellViewModel) {
        nameLabel.text = person.name
        let attributedText = NSMutableAttributedString()
        let textString = NSAttributedString(string: person.tastes)
        let imageAttachment = NSTextAttachment()
        let image = UIImage(systemName: "fork.knife")?.withTintColor(UIColor(named: "Yellow") ?? .yellow)
        imageAttachment.image = image
        let imageString = NSAttributedString(attachment: imageAttachment)
        attributedText.append(imageString)
        attributedText.append(NSAttributedString(" "))
        attributedText.append(textString)
        tastePreferencesLabel.attributedText = attributedText
    }

    private func configureUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(named: "Border")?.cgColor
        [nameLabel, tastePreferencesLabel].forEach {
            stackWithLabels.addArrangedSubview($0)
        }
        [stackWithLabels, imageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        NSLayoutConstraint.activate([
            stackWithLabels.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 8),
            stackWithLabels.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            stackWithLabels.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -8),
            stackWithLabels.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 4)
        ])
    }
}
