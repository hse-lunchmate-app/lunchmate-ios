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
    
    var user: Dynamic<User?> = Dynamic(nil)
    var isLoading = Dynamic(false)
    var apiManager = APIManager.shared
    var isCanEdit = true
    
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
    
    func createDescriptions(user: User?) {
        if let user = user {
            let tg = AccountInfo.description("Telegram", user.messenger, "tg")
            let office = AccountInfo.description("Офис", user.office.name, "map-marker")
            let food = AccountInfo.description("Вкусовые предпочтения", user.tastes, "food")
            let about = AccountInfo.description("О себе", user.aboutMe, "about me")
            descriptions = [tg, office, food, about]
        }
    }
    
    func retrieveUser(with id: String, completion: @escaping (_ error: Error?) -> Void) {
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
                completion(error)
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
