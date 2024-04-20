//
//  AccountEditingCollectionViewCellViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 03.04.2024.
//

import Foundation


class AccountEditingCollectionViewCellViewModel {
    
    // MARK: - Properties
    
    let apiManager = APIManager.shared
    let offices = Dynamic([Office]())
    let title: String
    let description: String
    
    // MARK: - Init
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
    func getOffices() {
        apiManager.getOffices() { [weak self] data in
            guard let self = self else { return }
            self.offices.value = data
        }
    }
    
    // MARK: - Methods
    
    func getOfficesNames() -> [String] {
        var officesNames: [String] = []
        for i in offices.value {
            officesNames.append(i.name)
        }
        return officesNames
    }
}
