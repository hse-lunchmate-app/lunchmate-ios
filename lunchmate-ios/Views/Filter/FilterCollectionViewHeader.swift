//
//  FilterCollectionViewHeader.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 26.05.2024.
//

import UIKit

class FilterCollectionViewHeader: UICollectionReusableView {
    
    static let identifier = "FilterCollectionViewHeader"
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let filterTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 15)
        label.textColor = UIColor(named: "Base90")
        label.text = "Офис"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        [separatorView, filterTypeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            filterTypeLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
            filterTypeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            filterTypeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}


