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
    
    // MARK: - Methods
    
    func getOffices() {
        apiManager.getOffices() { [weak self] result in
            switch result {
            case .success(let offices):
                self?.offices.value = offices
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getOfficesNames() -> [String] {
        var officesNames: [String] = []
        for i in offices.value {
            officesNames.append(i.name)
        }
        return officesNames
    }
}
