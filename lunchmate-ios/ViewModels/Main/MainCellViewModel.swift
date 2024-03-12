//
//  MainCellViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 06.03.2024.
//

import Foundation

class MainCellViewModel {
    
    // MARK: - Variables
    
    var id: String
    var name: String
    var tastes: String
    
    // MARK: - Init
    
    init(user: User) {
        self.id = user.id
        self.name = user.name
        self.tastes = user.tastes
    }
}
