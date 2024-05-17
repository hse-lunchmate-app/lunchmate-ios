//
//  Lunch.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 14.05.2024.
//

import Foundation

struct Lunch: Codable {
    let id: String
    let master: SimpleUser
    let invitee: SimpleUser
    let timeslot: Timeslot
    let accepted: Bool
    let lunchDate: String
    let createDate: String
}
