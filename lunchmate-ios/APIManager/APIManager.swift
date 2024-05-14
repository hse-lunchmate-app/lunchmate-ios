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

    func getOffices(completion: @escaping (Result<[Office], Error>) -> Void) {
        guard let url = URL(string: baseURL + "/offices") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data , response, error in
            guard response != nil else { return }
            guard let data else {return}
            if let officesData = try? JSONDecoder().decode([Office].self, from: data) {
                completion(.success(officesData))
            }
            else {
                completion(.failure(NSError(domain: "Cannot convert to offices", code: 0, userInfo: nil)))
            }
        }
        task.resume()
    }

    func getUsers(id: Int, completion: @escaping (Result<[User], Error>) -> Void) {
        guard let url = URL(string: baseURL + "/users?officeId=" + String(id)) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data , response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard response != nil else { return }
            guard let data else {return}
            do {
                let usersData = try JSONDecoder().decode([User].self, from: data)
                completion(.success(usersData))
            } catch {
                completion(.failure(NSError(domain: "Cannot convert to users", code: 0, userInfo: nil)))
            }
        }
        task.resume()
    }
    
    func getUser(id: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: baseURL + "/users/" + id) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data , response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            do {
                let userData = try JSONDecoder().decode(User.self, from: data)
                completion(.success(userData))
            } catch {
                completion(.failure(NSError(domain: "Cannot convert to user", code: 0, userInfo: nil)))
            }
        }
        task.resume()
    }

    
    func postNewUser(user: NetworkUser) {
        guard let url = URL(string: baseURL + "/users") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
        } catch {
            print("Error encoding NetworkUser: \(error)")
            return
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error sending POST request: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Server responded with an error: \(String(describing: response))")
                return
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("POST request successful, response: \(json)")
                } catch {
                    print("Error parsing JSON response: \(error)")
                }
            }
        }
        task.resume()
    }
}
