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
            user.name = description
        case "Офис":
            if let office = retriveOffice(with: description) {
                user.office = office
            }
        case "Вкусовые предпочтения":
            user.tastes = description
        case "О себе":
            user.aboutMe = description
        case "Telegram":
            user.messenger = description.trimmingCharacters(in: .whitespaces)
        case "Логин":
            user.login = description
        default:
            break
        }
    }
    
    func changeAccountInfo() {
        let newUser = NetworkUserForPatch(login: user.login, name: user.name, messenger: user.messenger, tastes: user.tastes, aboutMe: user.aboutMe, officeId: user.office.id)
        apiManager.patchUser(id: "id3", updatedUser: newUser) { [weak self] error in
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
    
    func retriveOffice(with name: String) -> Office? {
        guard let office = Office.offices.first (where: {$0.name == name}) else { return nil }
        return office
    }
}
