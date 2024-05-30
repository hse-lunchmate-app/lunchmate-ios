//
//  NotificationsCollectionViewCell.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 15.05.2024.
//

import UIKit

protocol NotificationsCollectionViewCellDelegate: AnyObject {
    func reloadCollectionView(decline: Bool)
}

final class NotificationsCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    let viewModel = NotificationsCollectionViewCellViewModel()
    weak var delegate: NotificationsCollectionViewCellDelegate?
    
    // MARK: - Identifier
    
    static let identifier = "NotificationsCollectionViewCell"
    
    // MARK: - Subviews
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont(name: "Roboto-Medium", size: 16)
        label.textColor = UIColor(named: "Base90")
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont(name: "Roboto-Regular", size: 14)
        label.textColor = UIColor(named: "Base90")
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont(name: "Roboto-Regular", size: 14)
        label.textColor = UIColor(named: "Base90")
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
    
    lazy var acceptButton: UIButton = {
        let button = UIButton()
        button.setTitle("Принять", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(named: "Yellow")
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 14)
        button.addTarget(self, action: #selector(acceptLunch), for: .touchUpInside)
        return button
    }()
    
    lazy var declineButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отклонить", for: .normal)
        button.setTitleColor(UIColor(named: "Yellow"), for: .normal)
        button.backgroundColor = UIColor(named: "LightYellow")
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 14)
        button.addTarget(self, action: #selector(declineLunch), for: .touchUpInside)
        return button
    }()
    
    let deleteImageView: UIImageView = {
        let image = UIImage(systemName: "trash")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        return imageView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        messageLabel.text = nil
        dateLabel.text = nil
        [stackWithLabels, imageView, declineButton, acceptButton].forEach {
            $0.removeFromSuperview()
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        titleLabel.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left
        messageLabel.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left - 80
        dateLabel.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }
    
    // MARK: - Methods
    
    func configure(lunch: Lunch, selectedIndex: Int) {
        viewModel.lunch = lunch
        var stringDate = viewModel.makeStringDay(lunchDate: lunch.lunchDate)
        var startTime = viewModel.makeTime(time: lunch.timeslot.startTime)
        var endTime = viewModel.makeTime(time: lunch.timeslot.endTime)
        if selectedIndex == 0 {
            if lunch.accepted == false && lunch.invitee.id == "id1" {
                titleLabel.text = "Новое приглашение"
                messageLabel.text = lunch.master.name + " позвал(а) вас на ланч"
                dateLabel.text = "Дата: \(stringDate) с \(startTime) до \(endTime)"
            }
        } else {
            if lunch.accepted == true && lunch.master.id == "id1" {
                titleLabel.text = "Согласие"
                messageLabel.text = lunch.invitee.name + " принял(а) приглашение на ланч"
                dateLabel.text = "Дата: \(stringDate) с \(startTime) до \(endTime)"
            } else if lunch.accepted == true && lunch.invitee.id == "id1" {
                titleLabel.text = "Согласие"
                messageLabel.text = "Вы приняли приглашение на ланч"
                dateLabel.text = "Дата: \(stringDate) с \(startTime) до \(endTime)"
            }
        }
        configureUI()
    }

    private func configureUI() {
        contentView.backgroundColor = UIColor(named: "Base0")
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(named: "Yellow70")?.cgColor
        [titleLabel, messageLabel, dateLabel].forEach {
            stackWithLabels.addArrangedSubview($0)
        }
        [stackWithLabels, imageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        NSLayoutConstraint.activate([
            stackWithLabels.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 8),
            stackWithLabels.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            stackWithLabels.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 68),
            imageView.widthAnchor.constraint(equalToConstant: 68),
            imageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 4),
        ])
        if titleLabel.text == "Новое приглашение" {
            [acceptButton, declineButton].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview($0)
            }
            NSLayoutConstraint.activate([
                acceptButton.topAnchor.constraint(equalTo: stackWithLabels.bottomAnchor, constant: 12),
                acceptButton.heightAnchor.constraint(equalToConstant: 40),
                acceptButton.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 8),
                declineButton.topAnchor.constraint(equalTo: stackWithLabels.bottomAnchor, constant: 12),
                declineButton.heightAnchor.constraint(equalToConstant: 40),
                declineButton.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -8),
                declineButton.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -8),
                acceptButton.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -8),
                acceptButton.widthAnchor.constraint(equalToConstant: 150),
                declineButton.widthAnchor.constraint(equalToConstant: 150),
                imageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 6),
            ])
        } else {
            NSLayoutConstraint.activate([
                stackWithLabels.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -8),
                imageView.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            ])
        }
    }
    
    @objc func declineLunch() {
        viewModel.declineLunchInvite { [weak self] error in
            if error == nil {
                DispatchQueue.main.async {
                    self?.delegate?.reloadCollectionView(decline: true)
                }
            }
        }
    }
    
    @objc func acceptLunch() {
        viewModel.acceptLunchInvite { [weak self] error in
            if error == nil {
                DispatchQueue.main.async {
                    self?.delegate?.reloadCollectionView(decline: false)
                }
            }
        }
    }
}
