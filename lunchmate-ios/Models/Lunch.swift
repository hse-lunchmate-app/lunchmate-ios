//
//  Lunch.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 14.05.2024.
//

import Foundation

struct Lunch {
    let id: String
    let master: User
    let invitee: User
    let timeslot: Timeslot
    let accepted: Bool
    let lunchDate: String
    let createDate: String
}
