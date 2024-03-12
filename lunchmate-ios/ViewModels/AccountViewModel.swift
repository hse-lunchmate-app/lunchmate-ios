//
//  AccountViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 06.03.2024.
//

import Foundation

class AccountViewModel {
    
    // MARK: - Variables
    
    var user: User?
    var isCanEdit = true
    
    // MARK: - Init
    
    init(user: User?) {
        self.user = user
    }
    
    // MARK: - Methods
    
    func changeIsCanEdit(flag: Bool) {
        isCanEdit = flag
    }
    
}
