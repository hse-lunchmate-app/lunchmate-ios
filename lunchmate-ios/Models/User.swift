//
//  User.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 27.02.2024.
//

import Foundation

struct User: Codable {
    let id: String
    var login: String
    var name: String
    var messenger: String?
    var tastes: String?
    var aboutMe: String?
    var office: Office
    var image: URL?
}

struct UserNetwork: Codable {
    let id: String
    let login: String
}
