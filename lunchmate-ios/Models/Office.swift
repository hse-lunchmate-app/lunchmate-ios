//
//  Office.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 27.02.2024.
//

import Foundation

struct Office: Codable {
    let id: Int
    let name: String
    let city: City
}

extension Office {
    static var offices = [Office(id: 1, name: "Tinkoff Space", city: City.cities[0]), Office(id: 2, name: "Лобачевский PLAZA", city: City.cities[1])]
}
