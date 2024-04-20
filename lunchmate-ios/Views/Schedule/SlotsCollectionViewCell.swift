//
//  SlotsCollectionViewCell.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 16.04.2024.
//

import UIKit

class SlotsCollectionViewCell: UICollectionViewCell {
    static let identifier = "SlotsCollectionViewCell"
    
    private var timeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont(name: "Roboto-Medium", size: 20)
        label.textColor = .black
        return label
    }()
    
    private var collegueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont(name: "Roboto-Regular", size: 20)
        label.textColor = UIColor(named: "Blue")
        return label
    }()
    
    private var repeatImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "repeat")?.withTintColor(UIColor(named: "Yellow70") ?? .orange)
        imageView.image = image
        imageView.tintColor = UIColor(named: "Yellow70")
        imageView.isHidden = true
        return imageView
    }()
    
    override func prepareForReuse() {
        collegueLabel.text = nil
        timeLabel.attributedText = nil
        repeatImageView.isHidden = true
    }
    
    func configure(timeslot: Timeslot) {
        timeLabel.text = "\(timeslot.startTime) - \(timeslot.endTime)"
        if let name = timeslot.collegue?.name {
            let attributedText = NSMutableAttributedString()
            let textString = NSAttributedString(string: name)
            let imageAttachment = NSTextAttachment()
            let image = UIImage(systemName: "person.2.fill")?.withTintColor(UIColor(named: "Blue") ?? .blue)
            imageAttachment.image = image
            let imageString = NSAttributedString(attachment: imageAttachment)
            attributedText.append(imageString)
            attributedText.append(NSAttributedString(" "))
            attributedText.append(textString)
            let imageOffset: CGFloat = 1.4
            attributedText.addAttribute(NSAttributedString.Key.baselineOffset, value: imageOffset, range: NSRange(location: 0, length: imageString.length))
            collegueLabel.attributedText = attributedText
        }
        if timeslot.permanent {
            repeatImageView.isHidden = false
        }
        setupUI()
    }
    
    private func setupUI() {
        self.layer.borderColor = UIColor(named: "Base40")?.cgColor
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        
        [timeLabel, collegueLabel, repeatImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            timeLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 32 - 24),
            timeLabel.bottomAnchor.constraint(equalTo: collegueLabel.topAnchor, constant: -8),
            timeLabel.heightAnchor.constraint(equalToConstant: 24),
            repeatImageView.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor),
            repeatImageView.heightAnchor.constraint(equalToConstant: 24),
            repeatImageView.heightAnchor.constraint(equalToConstant: 24),
            repeatImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            repeatImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            collegueLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            collegueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            collegueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
        ])
    }
    
}
