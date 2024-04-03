//
//  AccountEditingCollectionViewCellViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 03.04.2024.
//

import Foundation


class AccountEditingCollectionViewCellViewModel {
    
    // MARK: - Properties
    
    let title: String
    let description: String
    
    // MARK: - Init
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
    // MARK: - Methods
    
    func getOfficesNames() -> [String] {
        var officesNames: [String] = []
        for i in Office.offices {
            officesNames.append(i.name)
        }
        return officesNames
    }
}
