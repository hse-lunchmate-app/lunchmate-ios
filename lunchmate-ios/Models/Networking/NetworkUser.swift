//
//  NetworkUser.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 14.05.2024.
//

import Foundation

struct NetworkUser: Codable {
    let id: String
    let login: String
    let name: String
    let messenger: String
    let tastes: String
    let aboutMe: String
    let officeId: Int
}
