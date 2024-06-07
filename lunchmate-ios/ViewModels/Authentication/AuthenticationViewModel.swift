//
//  AuthenticationViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 07.06.2024.
//

import Foundation


class AuthenticationViewModel {
    
    let apiManager = APIManager.shared
    
    func makeBasicAuthToken(login: String, password: String) {
        let authorizationString = "\(login):\(password)"
        guard let authorizationData = authorizationString.data(using: String.Encoding.utf8) else { return }
        let base64AuthorizationString = authorizationData.base64EncodedString()
        UserDefaults.standard.setValue("Basic \(base64AuthorizationString)", forKey: "token")
    }
    
    func getId(login: String, password: String, completion: @escaping(NSError?) -> Void) {
        makeBasicAuthToken(login: login, password: password)
        apiManager.getUserId() { result in
            switch result {
            case .success(let id):
                UserDefaults.standard.set(id, forKey: "userId")
                completion(nil)
            case .failure(let error):
                completion(error as NSError)
            }
        }
    }
}
