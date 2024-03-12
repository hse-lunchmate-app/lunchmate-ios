//
//  AccountViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 06.03.2024.
//

import Foundation

class AccountViewModel {
    
    // MARK: - Variables
    
    var user: User
    var descriptions: [String]
    var isCanEdit = true
    
    var titles = [
        "Telegram",
        "Офис",
        "Вкусовые предпочтения",
        "О себе"
    ]
    
    var imageNames = [
        "tg",
        "map-marker",
        "food",
        "about me"
    ]
    
    // MARK: - Init
    
    init() {
        self.user = User.currentUser
        descriptions = [
            user.messenger,
            user.office.name,
            user.tastes,
            user.aboutMe
        ]
    }
    
    init(user: User) {
        self.user = user
        descriptions = [
            user.messenger,
            user.office.name,
            user.tastes,
            user.aboutMe
        ]
    }
    
    // MARK: - Methods
    
    func changeIsCanEdit() {
        isCanEdit = !isCanEdit
    }
    
    func numberOfRows(in section: Int) -> Int {
        return titles.count
    }
    
    func numberOfSections() -> Int {
        return 1
    }
}
