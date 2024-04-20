//
//  Timeslot.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 15.04.2024.
//

import Foundation

struct Timeslot {
    let id: Int
    let weekDay: Int
    let date: String
    let startTime: String
    let endTime: String
    let permanent: Bool
    let collegue: User?
}
