//
//  UISearchBarExtencion.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 06.03.2024.
//

import UIKit

extension UISearchBar {
    func changeSearchBarColor(color: UIColor) {
        let size = CGSize(width: self.frame.size.width, height: 45)
        UIGraphicsBeginImageContext(size)
        color.setFill()
        UIBezierPath(rect: self.frame).fill()
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.setSearchFieldBackgroundImage(bgImage, for: .normal)
    }
}
