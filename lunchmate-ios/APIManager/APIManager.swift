//
//  APIManager.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 27.02.2024.
//

import Foundation

final class APIManager {
    
    // MARK: - Properties
    
    private let baseURL = "http://185.44.8.151:8080"
    static let shared = APIManager()
    
    // MARK: - Methods

    func getCities(completion: @escaping (_ data: [City]) -> Void) {
        guard let url = URL(string: baseURL + "/cities") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data , response, error in
            guard response != nil else { return }
            guard let data else {return}
            if let citiesData = try? JSONDecoder().decode([City].self, from: data) {
                completion(citiesData)
            }
            else {
                print("Fail")
            }
        }
        task.resume()
    }

    func getUsers(id: Int, completion: @escaping (_ data: [User]) -> Void) {
        guard let url = URL(string: baseURL + "/users?id=" + String(id)) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data , response, error in
            guard response != nil else { return }
            guard let data else {return}
            if let usersData = try? JSONDecoder().decode([User].self, from: data) {
                completion(usersData)
            }
            else {
                print("Fail")
            }
        }
        task.resume()
    }
}
