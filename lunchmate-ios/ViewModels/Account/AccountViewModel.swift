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
    
    enum Sections: CaseIterable {
        case info
        case shedule
    }
    
    var descriptions: [AccountInfo] = []
    var user: Dynamic<User?> = Dynamic(nil)
    var userId = UserDefaults.standard.string(forKey: "userId")
    var isLoading = Dynamic(false)
    var apiManager = APIManager.shared
    var isCanEdit = true
    
    // MARK: - Methods
    
    func changeIsCanEdit() {
        isCanEdit = !isCanEdit
    }
    
    func numberOfRows(in section: Sections) -> Int {
        switch section {
        case .info:
            return descriptions.count
        case .shedule:
            return 1
        }
    }
    
    func setUserId(newValue: String) {
        userId = newValue
    }
    
    func numberOfSections() -> Int {
        return Sections.allCases.count
    }
    
    func createDescriptions(user: User?) {
        if let user = user {
            let tg = AccountInfo.description("Telegram", user.messenger ?? "Не указан", "tg")
            let office = AccountInfo.description("Офис", user.office.name, "map-marker")
            let food = AccountInfo.description("Вкусовые предпочтения", user.tastes ?? "Без предпочтений", "food")
            let about = AccountInfo.description("О себе", user.aboutMe ?? "Без описания", "about me")
            descriptions = [tg, office, food, about]
        }
    }
    
    func retrieveUser(with id: String, completion: @escaping (_ error: NSError?) -> Void) {
        if isLoading.value == true {
            return
        }
        isLoading.value = true
        apiManager.getUser(id: id) { [weak self] result in
            switch result {
            case .success(let data):
                self?.user.value = data
                completion(nil)
            case .failure(let error):
                completion(error as NSError)
            }
            self?.isLoading.value = false
        }
    }
    
    func getTgDescription() -> String {
        return user.value?.messenger ?? ""
    }
    
    func getImage(completion: @escaping (Data?) -> Void) {
        if let photoURL = user.value?.image {
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
        user.value?.image = newUser.image
    }
}
