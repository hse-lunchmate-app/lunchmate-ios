//
//  NotificationsCollectionViewCell.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 15.05.2024.
//

import UIKit

protocol NotificationsCollectionViewCellDelegate: AnyObject {
    func delete(inCell cell: UICollectionViewCell)
}

final class NotificationsCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    // MARK: - Identifier
    
    static let identifier = "NotificationsCollectionViewCell"
    
    var swipeGesture: UIPanGestureRecognizer!
    var originalPoint: CGPoint!
    weak var delegate: NotificationsCollectionViewCellDelegate?
    
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
    
    let acceptButton: UIButton = {
        let button = UIButton()
        button.setTitle("Принять", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(named: "Yellow")
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 14)
        return button
    }()
    
    let declineButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отклонить", for: .normal)
        button.setTitleColor(UIColor(named: "Yellow80"), for: .normal)
        button.backgroundColor = UIColor(named: "LightYellow")
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 14)
        return button
    }()
    
    let deleteImageView: UIImageView = {
        let image = UIImage(systemName: "trash")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        return imageView
    }()
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = TimeZone(secondsFromGMT: 3 * 3600)!
        return df
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
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        titleLabel.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left
        messageLabel.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left - 50
        dateLabel.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }
    
    // MARK: - Methods
    
    func configure(notification: Notifications) {
        var stringDate = ""
        var startTime = ""
        var endTime = ""
        if let timeslotDate = notification.timeslot.date {
            let date = dateFormatter.date(from: timeslotDate)
            dateFormatter.dateFormat = "d MMM"
            if let date = date {
                stringDate = dateFormatter.string(from: date)
            }
            dateFormatter.dateFormat = "HH:mm:ss"
            let startDate = dateFormatter.date(from: notification.timeslot.startTime)
            let endDate = dateFormatter.date(from: notification.timeslot.endTime)
            dateFormatter.dateFormat = "HH:mm"
            if let startDate = startDate {
                startTime = dateFormatter.string(from: startDate)
            }
            if let endDate = endDate {
                endTime = dateFormatter.string(from: endDate)
            }
            dateFormatter.dateFormat = "yyyy-MM-dd"
        }
        if notification.accepted == nil {
            titleLabel.text = "Новое приглашение"
            messageLabel.text = notification.collegue.name + " позвал(а) вас на ланч"
            dateLabel.text = "Дата: \(stringDate) с \(startTime) до \(endTime)"
        } else if notification.accepted == true && notification.timeslot.date != dateFormatter.string(from: Date()) {
            titleLabel.text = "Согласие"
            messageLabel.text = notification.collegue.name + " принял(а) приглашение на ланч"
            dateLabel.text = "Дата: \(stringDate) с \(startTime) до \(endTime)"
        } else if notification.accepted == false {
            titleLabel.text = "Отказ"
            messageLabel.text = notification.collegue.name + " отклонил(а) приглашение на ланч"
            dateLabel.text = "Дата: \(stringDate) с \(startTime) до \(endTime)"
        } else {
            titleLabel.text = "Напоминание"
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(secondsFromGMT: 3 * 3600)!
            let currentDate = Date()
            if let timeslotDate = notification.timeslot.date {
                let targetTime = dateFormatter.date(from: "\(timeslotDate) \(notification.timeslot.startTime)")
                if let targetTime = targetTime {
                    let difference = calendar.dateComponents([.hour, .minute], from: currentDate, to: targetTime)
                    if let hours = difference.hour, let minutes = difference.minute {
                        messageLabel.text = notification.collegue.name + " ждет вас на ланче через \(hours * 60 + minutes + 1) " + chooseEnding(minutes: hours * 60 + minutes + 1)
                    }
                    dateLabel.text = "Дата: \(stringDate) с \(startTime) до \(endTime)"
                }
            }
        }
        setupSwipeGesture()
        configureUI()
    }
    
    func chooseEnding(minutes: Int) -> String {
        switch minutes {
        case 11, 12, 13, 14:
            return "минут"
        default:
            break
        }
        switch minutes % 10 {
        case 1:
            return "минута"
        case 2, 3, 4:
            return "минуты"
        default:
            return "минут"
        }
    }

    private func configureUI() {
        contentView.backgroundColor = UIColor(named: "Base0")
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(named: "Yellow70")?.cgColor
        [titleLabel, messageLabel, dateLabel].forEach {
            stackWithLabels.addArrangedSubview($0)
        }
        [stackWithLabels, imageView, acceptButton, declineButton].forEach {
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
            acceptButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            acceptButton.heightAnchor.constraint(equalToConstant: 40),
            acceptButton.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 8),
            declineButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            declineButton.heightAnchor.constraint(equalToConstant: 40),
            declineButton.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -8),
            declineButton.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -8),
            acceptButton.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -8),
            acceptButton.widthAnchor.constraint(equalToConstant: 150),
            declineButton.widthAnchor.constraint(equalToConstant: 150)
        ])
        if titleLabel.text != "Новое приглашение" {
            acceptButton.removeFromSuperview()
            declineButton.removeFromSuperview()
            NSLayoutConstraint.activate([
                stackWithLabels.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -8),
                imageView.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 6),
            ])
        }
    }
    
    func setupSwipeGesture() {
        swipeGesture = UIPanGestureRecognizer(target: self, action:#selector(swiped(_:)))
        swipeGesture.delegate = self
        self.addGestureRecognizer(swipeGesture)
    }

    @objc func swiped(_ gestureRecognizer: UIPanGestureRecognizer) {
        let xDistance:CGFloat = gestureRecognizer.translation(in: self).x
        switch(gestureRecognizer.state) {
        case UIGestureRecognizer.State.began:
            self.originalPoint = self.center
        case UIGestureRecognizer.State.changed:
            let translation: CGPoint = gestureRecognizer.translation(in: self)
            let displacement: CGPoint = CGPoint.init(x: translation.x, y: translation.y)
            if displacement.x + self.originalPoint.x < self.originalPoint.x {
                self.transform = CGAffineTransform.init(translationX: displacement.x, y: 0)
                self.center = CGPoint(x: self.originalPoint.x + xDistance, y: self.originalPoint.y)
            }
        case UIGestureRecognizer.State.ended:
            let hasMovedToFarLeft = self.frame.maxX < UIScreen.main.bounds.width / 2
            if (hasMovedToFarLeft) {
                removeViewFromParentWithAnimation()
                delegate?.delete(inCell: self)
            } else {
                resetViewPositionAndTransformations()
            }
        default:
            break
        }
    }

    func resetViewPositionAndTransformations(){
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: UIView.AnimationOptions(), animations: {
                self.center = self.originalPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
            }, completion: {success in }
        )
    }

    func removeViewFromParentWithAnimation() {
        var animations:(()->Void)!
        animations = {self.center.x = -self.frame.width}
        UIView.animate(withDuration: 0.2, animations: animations , completion: {success in self.removeFromSuperview()})
    }
}
