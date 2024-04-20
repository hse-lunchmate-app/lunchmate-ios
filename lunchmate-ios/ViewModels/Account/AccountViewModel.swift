//
//  AccountViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 06.03.2024.
//

import Foundation

class AccountViewModel {
    
    // MARK: - Properties
    
    enum AccountInfo {
        case description(String, String, String)
    }
    
    var descriptions: [AccountInfo] = []
    
    var user: User
    
    var isCanEdit = true
    
    // MARK: - Init
    
    init() {
        self.user = User.currentUser
        descriptions = createDescriptions()
    }
    
    init(user: User) {
        self.user = user
        descriptions = createDescriptions()
    }
    
    // MARK: - Methods
    
    func changeIsCanEdit() {
        isCanEdit = !isCanEdit
    }
    
    func numberOfRows(in section: Int) -> Int {
        return descriptions.count
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func createDescriptions() -> [AccountInfo] {
        let tg = AccountInfo.description("Telegram", user.messenger, "tg")
        let office = AccountInfo.description("Офис", user.office.name, "map-marker")
        let food = AccountInfo.description("Вкусовые предпочтения", user.tastes, "food")
        let about = AccountInfo.description("О себе", user.aboutMe, "about me")
        return [tg, office, food, about]
    }
    
    func getTgDescription() -> String {
        return user.messenger
    }
    
    func getImage(completion: @escaping (Data?) -> Void) {
        if let photoURL = user.image {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: photoURL) {
                    DispatchQueue.main.async {
                        completion(data)
                    }
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    func updateUser(newUser: User) {
        user = newUser
        descriptions = createDescriptions()
    }
}
