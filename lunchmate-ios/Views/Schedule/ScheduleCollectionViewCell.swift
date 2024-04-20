//
//  ScheduleCollectionViewCell.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 15.04.2024.
//

import UIKit

class ScheduleCollectionViewCell: UICollectionViewCell {
    static let identifier = "ScheduleCollectionViewCell"
    
    private var dayLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont(name: "Roboto-Medium", size: 16)
        label.textColor = UIColor(named: "Blue")
        return label
    }()
    
    private var weekLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont(name: "Roboto-Regular", size: 16)
        label.textColor = UIColor(named: "Blue")
        return label
    }()
    
    private var forkAndKnifeImageView: UIImageView = {
        let image = UIImage(systemName: "fork.knife")?.withTintColor(UIColor(named: "Blue") ?? .blue) ?? UIImage()
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weekLabel.text = nil
        dayLabel.text = nil
        weekLabel.textColor = UIColor(named: "Blue")
        dayLabel.textColor = UIColor(named: "Blue")
        forkAndKnifeImageView.tintColor = UIColor(named: "Blue")
        forkAndKnifeImageView.image = UIImage(systemName: "fork.knife")?.withTintColor(UIColor(named: "Blue") ?? .blue) ?? UIImage()
        self.backgroundColor = nil
        self.isUserInteractionEnabled = true
        self.isSelected = false
    }
    
    private func makeDay(date: Date) -> (String, String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"

        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: "ru_RU")
        
        dayFormatter.dateFormat = "EE"
        let dayOfWeek = dayFormatter.string(from: date)
        
        dayFormatter.dateFormat = "dd"
        let dayOfMonth = dayFormatter.string(from: date)
        
        return (dayOfWeek, dayOfMonth)
    }
    
    func configure(date: Date) {
        let day = makeDay(date: date)
        dayLabel.text = day.1
        weekLabel.text = day.0
        configureUI()
    }
    
    func changeSelectedCell() {
        weekLabel.textColor = .black
        dayLabel.textColor = .black
        forkAndKnifeImageView.tintColor = .black
        self.backgroundColor = UIColor(named: "Yellow")
        self.layer.borderWidth = 0
    }
    
    func changeUsualCell() {
        weekLabel.textColor = UIColor(named: "Blue")
        dayLabel.textColor = UIColor(named: "Blue")
        forkAndKnifeImageView.tintColor = UIColor(named: "Blue")
        self.backgroundColor = .white
        self.layer.borderWidth = 1
    }
    
    func changeDisabledCell() {
        forkAndKnifeImageView.image = nil
        weekLabel.textColor = UIColor(named: "DisabledCell")
        dayLabel.textColor = UIColor(named: "DisabledCell")
        self.layer.borderWidth = 0
        self.isUserInteractionEnabled = false
    }
    
    func deleteImage() {
        forkAndKnifeImageView.image = nil
    }
    
    private func configureUI() {
        [weekLabel, dayLabel, forkAndKnifeImageView].forEach {
            stack.addArrangedSubview($0)
        }
        self.addSubview(stack)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(named: "Blue")?.cgColor
        self.layer.cornerRadius = 23
        
        if self.isSelected {
            changeSelectedCell()
        }
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 14),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -14),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14),
            forkAndKnifeImageView.heightAnchor.constraint(equalToConstant: 18)
        ])
        
    }
}
