//
//  APIManager.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 27.02.2024.
//

import Foundation

final class APIManager {
    
    // MARK: - Properties
    private let baseURL = "http://185.44.8.179:8080"
    static let shared = APIManager()
    
    // MARK: - Methods

    func getOffices(completion: @escaping (_ data: [Office]) -> Void) {
        guard let url = URL(string: baseURL + "/offices") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data , response, error in
            guard response != nil else { return }
            guard let data else {return}
            if let officesData = try? JSONDecoder().decode([Office].self, from: data) {
                completion(officesData)
            }
            else {
                print("Fail")
            }
        }
        task.resume()
    }

    func getUsers(id: Int, completion: @escaping (_ data: [User], _ error: Error?) -> Void) {
        guard let url = URL(string: baseURL + "/users?officeId=" + String(id)) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data , response, error in
            if let error = error {
                completion([], error)
                return
            }
            guard response != nil else { return }
            guard let data else {return}
            do {
                let usersData = try JSONDecoder().decode([User].self, from: data)
                completion(usersData, nil)
            } catch {
                completion([], error)
            }
        }
        task.resume()
    }
    
    func getUser(id: String, completion: @escaping (_ data: User?, _ error: Error?) -> Void) {
        guard let url = URL(string: baseURL + "/users/" + id) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data , response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard response != nil else { return }
            guard let data else {return}
            do {
                let userData = try JSONDecoder().decode(User.self, from: data)
                completion(userData, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
