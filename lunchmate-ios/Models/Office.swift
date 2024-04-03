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
    static var offices = [Office(id: 0, name: "Main", city: City.city), Office(id: 1, name: "Not main", city: City.city)]
}
