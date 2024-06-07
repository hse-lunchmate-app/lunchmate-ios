//
//  APIManager.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 27.02.2024.
//

import Foundation

final class APIManager {
    
    // MARK: - Properties
    private let baseURL = "http://185.44.8.179:8081/api"
    static let shared = APIManager()
    
    // MARK: - Methods
    
    func getUserId(completion: @escaping (Result<String, Error>) -> Void) {
        if Reachability.isConnectedToNetwork() {
            guard let url = URL(string: baseURL + "/authenticated") else { return }
            var request = URLRequest(url: url)
            guard let token = UserDefaults.standard.string(forKey: "token") else { return }
            request.setValue(token, forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) { data , response, error in
                guard response != nil else { return }
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 403 {
                            completion(.failure(NSError(domain: "Неправильный логин или пароль", code: httpResponse.statusCode, userInfo: nil)))
                        }
                    }
                    completion(.failure(NSError(domain: "Server responded with an error: \(String(describing: response))", code: 0, userInfo: nil)))
                    return
                }
                print(String(describing: response))
                if let data = data {
                    if let userData = try? JSONDecoder().decode(UserNetwork.self, from: data) {
                        completion(.success(userData.id))
                    }
                    else {
                        completion(.failure(NSError(domain: "Cannot convert to user", code: 0, userInfo: nil)))
                    }
                }
            }
            task.resume()
        } else {
            completion(.failure(NSError(domain: "Нет подключения к интернету", code: 1, userInfo: nil)))
        }
    }
    
    func getOffices(completion: @escaping (Result<[Office], Error>) -> Void) {
        if Reachability.isConnectedToNetwork() {
            guard let url = URL(string: baseURL + "/offices") else { return }
            var request = URLRequest(url: url)
            guard let token = UserDefaults.standard.string(forKey: "token") else { return }
            request.setValue(token, forHTTPHeaderField: "Authorization")
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
        } else {
            completion(.failure(NSError(domain: "Нет подключения к интернету", code: 1, userInfo: nil)))
        }
    }

    func getUsers(id: Int, completion: @escaping (Result<[User], Error>) -> Void) {
        if Reachability.isConnectedToNetwork() {
            guard let url = URL(string: baseURL + "/users?officeId=" + String(id)) else { return }
            var request = URLRequest(url: url)
            guard let token = UserDefaults.standard.string(forKey: "token") else { return }
            request.setValue(token, forHTTPHeaderField: "Authorization")
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
        } else {
            completion(.failure(NSError(domain: "Нет подключения к интернету", code: 1, userInfo: nil)))
        }
    }
    
    func getUser(id: String, completion: @escaping (Result<User, Error>) -> Void) {
        if Reachability.isConnectedToNetwork() {
            guard let url = URL(string: baseURL + "/users/" + id) else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }
            var request = URLRequest(url: url)
            guard let token = UserDefaults.standard.string(forKey: "token") else { return }
            request.setValue(token, forHTTPHeaderField: "Authorization")
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
        } else {
            completion(.failure(NSError(domain: "Нет подключения к интернету", code: 1, userInfo: nil)))
        }
    }
    
    func getTimeTable(id: String, date: String = "", free: Bool = false, completion: @escaping (Result<[Timeslot], Error>) -> Void) {
        if Reachability.isConnectedToNetwork() {
            var stringURL = baseURL + "/timetable/\(id)"
            if date != "" {
                stringURL += "?date=\(date)"
            }
            if free == true {
                stringURL += "&free=true"
            }
            guard let url = URL(string: stringURL) else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }
            var request = URLRequest(url: url)
            guard let token = UserDefaults.standard.string(forKey: "token") else { return }
            request.setValue(token, forHTTPHeaderField: "Authorization")
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
                    let timeTable = try JSONDecoder().decode([Timeslot].self, from: data)
                    completion(.success(timeTable))
                } catch {
                    completion(.failure(NSError(domain: "Cannot convert to time table", code: 0, userInfo: nil)))
                }
            }
            task.resume()
        } else {
            completion(.failure(NSError(domain: "Нет подключения к интернету", code: 1, userInfo: nil)))
        }
    }
    
    func postNewSlot(slot: NetworkTimeslot, completion: @escaping (Error?) -> Void) {
        if Reachability.isConnectedToNetwork() {
            guard let url = URL(string: baseURL + "/timetable/slot") else { return }
            var request = URLRequest(url: url)
            guard let token = UserDefaults.standard.string(forKey: "token") else { return }
            request.setValue(token, forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            do {
                let jsonData = try JSONEncoder().encode(slot)
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                print("Error encoding NetworkUser: \(error)")
                completion(error)
                return
            }
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error sending POST request: \(error)")
                    completion(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Server responded with an error: \(String(describing: response))")
                    completion(error)
                    return
                }
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print("POST request successful, response: \(json)")
                        completion(nil)
                    } catch {
                        print("Error parsing JSON response: \(error)")
                        completion(error)
                    }
                }
            }
            task.resume()
        } else {
            completion(NSError(domain: "Нет подключения к интернету", code: 1, userInfo: nil))
        }
    }
    
    func deleteSlot(id: Int, completion: @escaping (Error?) -> Void) {
        if Reachability.isConnectedToNetwork() {
            guard let url = URL(string: baseURL + "/timetable/slot/\(id)") else { return }
            var request = URLRequest(url: url)
            guard let token = UserDefaults.standard.string(forKey: "token") else { return }
            request.setValue(token, forHTTPHeaderField: "Authorization")
            request.httpMethod = "DELETE"
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error sending DELETE request: \(error)")
                    completion(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Server responded with an error: \(String(describing: response))")
                    completion(error)
                    return
                }
                print("DELETE request successful")
                completion(nil)
            }
            task.resume()
        } else {
            completion(NSError(domain: "Нет подключения к интернету", code: 1, userInfo: nil))
        }
    }
    
    func patchSlot(id: Int, updatedSlot: NetworkTimeslot, completion: @escaping (Error?) -> Void) {
        if Reachability.isConnectedToNetwork() {
            guard let url = URL(string: baseURL + "/timetable/slot/\(id)") else { return }
            var request = URLRequest(url: url)
            guard let token = UserDefaults.standard.string(forKey: "token") else { return }
            request.setValue(token, forHTTPHeaderField: "Authorization")
            request.httpMethod = "PATCH"
            do {
                let jsonData = try JSONEncoder().encode(updatedSlot)
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                print("Error encoding NetworkUser: \(error)")
                completion(error)
                return
            }
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error sending PATCH request: \(error)")
                    completion(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Server responded with an error: \(String(describing: response))")
                    completion(error)
                    return
                }
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print("PATCH request successful, response: \(json)")
                        completion(nil)
                    } catch {
                        print("Error parsing JSON response: \(error)")
                        completion(error)
                    }
                }
            }
            task.resume()
        } else {
            completion(NSError(domain: "Нет подключения к интернету", code: 1, userInfo: nil))
        }
    }
    
    func patchUser(id: String, updatedUser: [String:Any], completion: @escaping (Error?) -> Void) {
        if Reachability.isConnectedToNetwork() {
            guard let url = URL(string: baseURL + "/users/\(id)") else { return }
            var request = URLRequest(url: url)
            guard let token = UserDefaults.standard.string(forKey: "token") else { return }
            request.setValue(token, forHTTPHeaderField: "Authorization")
            request.httpMethod = "PATCH"
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: updatedUser, options: [])
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                print("Error encoding NetworkUser: \(error)")
                completion(error)
                return
            }
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error sending PATCH request: \(error)")
                    completion(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Server responded with an error: \(String(describing: response))")
                    completion(error)
                    return
                }
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print("PATCH request successful, response: \(json)")
                        completion(nil)
                    } catch {
                        print("Error parsing JSON response: \(error)")
                        completion(error)
                    }
                }
            }
            task.resume()
        } else {
            completion(NSError(domain: "Нет подключения к интернету", code: 1, userInfo: nil))
        }
    }
    
    func getAcceptedLunches(id: String, completion: @escaping (Result<[Lunch], Error>) -> Void) {
        if Reachability.isConnectedToNetwork() {
            guard let url = URL(string: baseURL + "/lunches/\(id)?accepted=true") else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }
            var request = URLRequest(url: url)
            guard let token = UserDefaults.standard.string(forKey: "token") else { return }
            request.setValue(token, forHTTPHeaderField: "Authorization")
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
                    let lunches = try JSONDecoder().decode([Lunch].self, from: data)
                    completion(.success(lunches))
                } catch {
                    completion(.failure(NSError(domain: "Cannot convert to lunches", code: 0, userInfo: nil)))
                }
            }
            task.resume()
        } else {
            completion(.failure(NSError(domain: "Нет подключения к интернету", code: 1, userInfo: nil)))
        }
    }
    
    func getAllLunches(id: String, completion: @escaping (Result<[Lunch], Error>) -> Void) {
        if Reachability.isConnectedToNetwork() {
            guard let url = URL(string: baseURL + "/lunches/\(id)") else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }
            var request = URLRequest(url: url)
            guard let token = UserDefaults.standard.string(forKey: "token") else { return }
            request.setValue(token, forHTTPHeaderField: "Authorization")
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
                    let lunches = try JSONDecoder().decode([Lunch].self, from: data)
                    completion(.success(lunches))
                } catch {
                    completion(.failure(NSError(domain: "Cannot convert to lunches", code: 0, userInfo: nil)))
                }
            }
            task.resume()
        } else {
            completion(.failure(NSError(domain: "Нет подключения к интернету", code: 1, userInfo: nil)))
        }
    }
    
    func revokeLunch(lunchId: String, completion: @escaping (Error?) -> Void) {
        if Reachability.isConnectedToNetwork() {
            guard let url = URL(string: baseURL + "/lunches/\(lunchId)/revoke") else { return }
            var request = URLRequest(url: url)
            guard let token = UserDefaults.standard.string(forKey: "token") else { return }
            request.setValue(token, forHTTPHeaderField: "Authorization")
            request.httpMethod = "DELETE"
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error sending DELETE request: \(error)")
                    completion(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Server responded with an error: \(String(describing: response))")
                    completion(error)
                    return
                }
                print("DELETE request successful")
                completion(nil)
            }
            task.resume()
        } else {
            completion(NSError(domain: "Нет подключения к интернету", code: 1, userInfo: nil))
        }
    }
    
    func postLunchInvite(lunch: NetworkLunchForPatch, completion: @escaping (Error?) -> Void) {
        if Reachability.isConnectedToNetwork() {
            guard let url = URL(string: baseURL + "/lunches/invite") else { return }
            var request = URLRequest(url: url)
            guard let token = UserDefaults.standard.string(forKey: "token") else { return }
            request.setValue(token, forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            do {
                let jsonData = try JSONEncoder().encode(lunch)
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                print("Error encoding NetworkUser: \(error)")
                completion(error)
                return
            }
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error sending POST request: \(error)")
                    completion(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Server responded with an error: \(String(describing: response))")
                    let response = response as? HTTPURLResponse
                    if response?.statusCode == 403 {
                        completion(NSError(domain: "Нельзя пригласить коллегу на прошедший временной слот!", code: response!.statusCode, userInfo: nil))
                    }
                    return
                }
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print("POST request successful, response: \(json)")
                        completion(nil)
                    } catch {
                        print("Error parsing JSON response: \(error)")
                        completion(error)
                    }
                }
            }
            task.resume()
        } else {
            completion(NSError(domain: "Нет подключения к интернету", code: 1, userInfo: nil))
        }
    }
    
    func declineLunch(lunchId: String, completion: @escaping (Error?) -> Void) {
        if Reachability.isConnectedToNetwork() {
            guard let url = URL(string: baseURL + "/lunches/\(lunchId)/decline") else { return }
            var request = URLRequest(url: url)
            guard let token = UserDefaults.standard.string(forKey: "token") else { return }
            request.setValue(token, forHTTPHeaderField: "Authorization")
            request.httpMethod = "DELETE"
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error sending DELETE request: \(error)")
                    completion(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Server responded with an error: \(String(describing: response))")
                    completion(error)
                    return
                }
                print("DELETE request successful")
                completion(nil)
            }
            task.resume()
        } else {
            completion(NSError(domain: "Нет подключения к интернету", code: 1, userInfo: nil))
        }
    }
    
    func acceptLunch(lunchId: String, completion: @escaping (Error?) -> Void) {
        if Reachability.isConnectedToNetwork() {
            guard let url = URL(string: baseURL + "/lunches/\(lunchId)/accept") else { return }
            var request = URLRequest(url: url)
            guard let token = UserDefaults.standard.string(forKey: "token") else { return }
            request.setValue(token, forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error sending POST request: \(error)")
                    completion(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Server responded with an error: \(String(describing: response))")
                    completion(error)
                    return
                }
                print("POST request successful")
                completion(nil)
            }
            task.resume()
        } else {
            completion(NSError(domain: "Нет подключения к интернету", code: 1, userInfo: nil))
        }
    }
}
