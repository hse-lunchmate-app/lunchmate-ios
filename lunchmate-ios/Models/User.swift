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
    var messenger: String
    var tastes: String
    var aboutMe: String
    var password: String?
    var office: Office
    var image: URL?
}

extension User {
    static var currentUser = User(id: "8", login: "ivan12345", name: "Иван Петров", messenger: "ivan-pro100klass", tastes: "Котлетка с пюрешкой", aboutMe: "Я обычный Иван", password: "1234", office: Office.offices[0], image: nil)
}
