//
//  CustomMessageView.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 05.05.2024.
//

import UIKit

class CustomMessageView: UIView {
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: frame.width - 20, height: frame.height))
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        label.font = UIFont(name: "Roboto-Medium", size: 16)
        return label
    }()
    
    init(message: String) {
        super.init(frame: CGRect(x: 8, y: 0, width: UIScreen.main.bounds.width - 16, height: 40))
        label.text = message
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.white
        addSubview(label)
        layer.cornerRadius = 12
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
