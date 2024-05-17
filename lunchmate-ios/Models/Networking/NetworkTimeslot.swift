//
//  NetworkTimeslot.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 15.05.2024.
//

import Foundation

struct NetworkTimeslot: Codable {
    let userId: String
    let date: String?
    let startTime: String
    let endTime: String
    let permanent: Bool
}
