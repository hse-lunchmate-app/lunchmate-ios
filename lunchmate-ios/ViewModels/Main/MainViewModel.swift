//
//  MainViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 27.02.2024.
//

import Foundation

class MainViewModel {
    
    // MARK: - Constants
    
    private let apiManager = APIManager.shared
    
    // MARK: - Variables
    
    var users: [User] = []
    var filteredData = Dynamic([MainCellViewModel]())
    var isLoading: Dynamic<Bool> = Dynamic(false)
    
    // MARK: - Methods
    
    
    func getUser() {
        apiManager.getUser(id: "id3") { [weak self] result in
            switch result {
            case .success(let data):
                self?.getUsers(user: data)
            case .failure(let error):
                break
            }
        }
    }
    
    func getUsers(user: User) {
        if isLoading.value == true {
            return
        }
        isLoading.value = true
        apiManager.getUsers(id: user.office.id) { [weak self] result in
            switch result {
            case .success(let data):
                self?.users = data
            case .failure(let error):
                self?.users = []
            }
            self?.isLoading.value = false
            self?.users.removeAll(where: { $0.office.id != user.office.id })
            self?.users.removeAll(where: { $0.id == user.id })
            self?.filteredData.value = self?.users.compactMap({MainCellViewModel(user: $0)}) ?? []
        }
    }
    
    func filterUsers(text: String?) {
        guard let text = text else { return }
        if text != "" {
            let newData = users.filter { $0.name.lowercased().contains(text.lowercased()) }
            filteredData.value = newData.compactMap({MainCellViewModel(user: $0)})
        }
        else {
            filteredData.value = users.compactMap({MainCellViewModel(user: $0)})
        }
    }
    
    func numberOfRows(in section: Int) -> Int {
        return filteredData.value.count
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func retrieveUser(with id: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) {
        apiManager.getUser(id: id) { result in
            switch result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

}
