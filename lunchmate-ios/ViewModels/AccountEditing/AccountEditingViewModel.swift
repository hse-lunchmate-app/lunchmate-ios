//
//  AccountEditingViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 31.03.2024.
//

import Foundation


class AccountEditingViewModel {
    
    // MARK: - Properties
    
    enum Section: String, CaseIterable {
        case personalData = "Личные данные"
        case contactInformation = "Контактная информация"
        case accountData = "Учетные данные"
    }
    
    enum PersonalData: String, CaseIterable {
        case name = "Имя"
        case office = "Офис"
        case tastes = "Вкусовые предпочтения"
        case about = "О себе"
    }
    
    enum ContactInformation: String, CaseIterable {
        case tg = "Telegram"
    }
    
    enum AccountData: String, CaseIterable {
        case login = "Логин"
    }
    
    var user: User
    var userInfo: [String:Any] = [:]
    var apiManager = APIManager.shared
    
    init(user: User) {
        self.user = user
    }
    
    // MARK: - Methods
    
    func setNewInfo(title: String?, description: String?) {
        guard let title else { return }
        let description = (description == "" ? " " : description) ?? " "
        switch title {
        case "Имя":
            if user.name != description {
                userInfo["name"] = description
            }
        case "Офис":
            break
        case "Вкусовые предпочтения":
            if user.tastes != description {
                userInfo["tastes"] = description
            }
        case "О себе":
            if user.aboutMe != description {
                userInfo["aboutMe"] = description
            }
        case "Telegram":
            if user.messenger != description.trimmingCharacters(in: .whitespaces) {
                userInfo["messenger"] = description.trimmingCharacters(in: .whitespaces)
            }
        case "Логин":
            if user.login != description {
                userInfo["login"] = description
            }
        default:
            break
        }
    }
    
    func changeAccountInfo() {
        apiManager.patchUser(id: "id3", updatedUser: userInfo) { [weak self] error in
            if error == nil {
                NotificationCenter.default.post(name: Notification.Name("AccountInfoDidChange"), object: self?.user)
            }
        }
    }
    
    func setNewImageURL(url: URL?) {
        user.image = url
    }
    
    func isImageUrlAvilible() -> Bool {
        return user.image != nil ? true : false
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
    
    func retriveOffice(with name: String, completion: @escaping (Office?) -> Void) {
        apiManager.getOffices() { result in
            switch result {
            case .success(let offices):
                completion(offices.first(where: {$0.name == name}))
            case .failure(let error):
                completion(nil)
            }
        }
    }

}
