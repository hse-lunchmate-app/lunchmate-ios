//
//  CustomTextField.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 02.04.2024.
//

import UIKit

class CustomTextField: UITextField {
    
    // MARK: - Methods

    override var isSecureTextEntry: Bool {
        didSet {
            if isFirstResponder {
                _ = becomeFirstResponder()
            }
        }
    }

    override func becomeFirstResponder() -> Bool {
        let wasFirstResponder = isFirstResponder
        let success = super.becomeFirstResponder()
        if isSecureTextEntry && !wasFirstResponder, let text = self.text {
            insertText("\(text)+")
            deleteBackward()
        }
        return success
    }

}
