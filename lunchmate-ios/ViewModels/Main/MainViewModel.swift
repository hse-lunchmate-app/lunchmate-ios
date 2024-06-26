//
//  MainViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 27.02.2024.
//

import Foundation

class MainViewModel {
    
    // MARK: - Properties
    
    private let apiManager = APIManager.shared
    var users: [User] = []
    var filteredData = Dynamic([MainCellViewModel]())
    var isLoading: Dynamic<Bool> = Dynamic(false)
    var filterOfficeId: Int?
    var user: User?
    let userId = UserDefaults.standard.string(forKey: "userId")
    
    // MARK: - Methods
    
    func getUser(completion: @escaping (NSError?) -> Void) {
        if let userId = userId {
            apiManager.getUser(id: userId) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.user = data
                    completion(nil)
                case .failure(let error):
                    completion(error as NSError)
                }
            }
        }
    }
    
    func getUsers(completion: @escaping (NSError?) -> Void) {
        if isLoading.value == true {
            return
        }
        isLoading.value = true
        var id = user?.office.id
        if let filterOfficeId = filterOfficeId {
            id = filterOfficeId
        } else {
            self.filterOfficeId = user?.office.id
        }
        if let id = id {
            apiManager.getUsers(id: id) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.users = data
                    self?.isLoading.value = false
                    self?.users.removeAll(where: { $0.id == self?.user?.id })
                    self?.filteredData.value = self?.users.compactMap({MainCellViewModel(user: $0)}) ?? []
                    completion(nil)
                case .failure(let error):
                    self?.users = []
                    completion(error as NSError)
                }
            }
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
    
    func retrieveUser(with id: String, completion: @escaping (_ user: User?, _ error: NSError?) -> Void) {
        apiManager.getUser(id: id) { result in
            switch result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error as NSError)
            }
        }
    }

}
