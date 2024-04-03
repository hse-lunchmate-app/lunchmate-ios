//
//  AccountEditingCollectionViewCell.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 01.04.2024.
//

import UIKit
import DropDown

protocol AccountEditingCollectionViewCellDelegate: AnyObject {
    func changeSaveButtonColor(isBlue: Bool)
}

final class AccountEditingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: AccountEditingCollectionViewCellViewModel = AccountEditingCollectionViewCellViewModel(title: "", description: "")
    weak var delegate: AccountEditingCollectionViewCellDelegate?
    
    // MARK: - Identifier
    
    static let identifier = "AccountEditingCollectionViewCell"
    
    // MARK: - Subviews
    
    private lazy var officesDropDown: DropDown = {
        let officesDropDown = DropDown()
        officesDropDown.anchorView = self
        officesDropDown.selectionAction = { index, title in
            self.descriptionTextField.text = title
            self.checkButtonColor(newText: self.descriptionTextField.text ?? "")
        }
        return officesDropDown
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont(name: "Roboto-Regular", size: 10)
        label.textColor = UIColor(named: "tinkoffLabel")
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var descriptionTextField: CustomTextField = {
        let label = CustomTextField(frame: .zero)
        label.font = UIFont(name: "Roboto-Regular", size: 15)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var stackWithLabels: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private lazy var dropDownButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.down")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "tinkoffLabel")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapToItem))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        button.addGestureRecognizer(gesture)
        return button
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
        descriptionTextField.text = nil
        descriptionTextField.leftView = nil
        descriptionTextField.isSecureTextEntry = false
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let maxLabelWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left - 48
        descriptionTextField.frame.size.width = maxLabelWidth
        descriptionTextField.sizeToFit()
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }

    // MARK: - Methods

    func configure(viewModel: AccountEditingCollectionViewCellViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        if viewModel.title == "Пароль" {
            descriptionTextField.isSecureTextEntry = true
        }
        if viewModel.title == "Telegram" {
            let image = UIImage(systemName: "at")?.withRenderingMode(.alwaysTemplate)
            let imageView = UIImageView(image: image)
            imageView.tintColor = UIColor(named: "Yellow") ?? .yellow
            imageView.image = image
            imageView.frame = CGRect(x: 0, y: 0, width: imageView.intrinsicContentSize.width, height: imageView.intrinsicContentSize.height)
            descriptionTextField.leftView = imageView
            descriptionTextField.leftViewMode = .always
            descriptionTextField.text = " " + viewModel.description
        }
        else {
            descriptionTextField.text = viewModel.description
        }
        officesDropDown.dataSource = viewModel.getOfficesNames()
        configureUI()
    }

    private func configureUI() {
        contentView.layer.cornerRadius = 7
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        descriptionTextField.delegate = self

        [titleLabel, descriptionTextField].forEach {
            stackWithLabels.addArrangedSubview($0)
        }
        
        [stackWithLabels, dropDownButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            stackWithLabels.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 4),
            stackWithLabels.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            stackWithLabels.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -4),
            dropDownButton.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            dropDownButton.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -2),
            dropDownButton.widthAnchor.constraint(equalToConstant: 24),
        ])
        
        if viewModel.title != "Офис" {
            dropDownButton.removeFromSuperview()
            NSLayoutConstraint.activate([
                stackWithLabels.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -8)
            ])
            
        }
    }
    
    func getTitleAndDescription() -> (String?, String?) {
        return (titleLabel.text, descriptionTextField.text)
    }
    
    @objc private func didTapToItem() {
        officesDropDown.show()
    }
    
    private func checkButtonColor(newText: String) {
        if newText != viewModel.description {
            delegate?.changeSaveButtonColor(isBlue: true)
        }
        else {
            delegate?.changeSaveButtonColor(isBlue: false)
        }
    }
}

// MARK: - UITextFieldDelegate

extension AccountEditingCollectionViewCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if titleLabel.text == "Офис" {
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text?.replacingCharacters(in: Range(range, in: textField.text ?? "")!, with: string) ?? "").trimmingCharacters(in: .whitespaces)
        checkButtonColor(newText: newText)
        if titleLabel.text == "Telegram" {
            if range.location == 0 {
                return false
            }
        }
        return true
    }
}

