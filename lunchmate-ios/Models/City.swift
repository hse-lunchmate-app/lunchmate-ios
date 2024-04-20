//
//  City.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 27.02.2024.
//

import Foundation

struct City: Codable {
    let id: Int
    let name: String
}


extension City {
    static var cities = [City(id: 1, name: "Москва"), City(id: 2, name: "Нижний Новгород")]
}
