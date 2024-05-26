//
//  CustomViewFlowLayout.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 26.05.2024.
//

import UIKit

class CustomViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let answer = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        for i in 1..<answer.count {
            let currentLayoutAttributes = answer[i]
            let prevLayoutAttributes = answer[i - 1]
            let maximumSpacing: CGFloat = 10
            let origin = prevLayoutAttributes.frame.maxX
            if currentLayoutAttributes.indexPath.section != prevLayoutAttributes.indexPath.section {
                continue
            }
            if origin + maximumSpacing + currentLayoutAttributes.frame.size.width < collectionViewContentSize.width {
                var frame = currentLayoutAttributes.frame
                frame.origin.x = origin + maximumSpacing
                currentLayoutAttributes.frame = frame
            }
        }
        
        return answer
    }
}
